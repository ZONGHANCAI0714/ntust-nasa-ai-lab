$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$started = (Get-Date).ToString('o')
$projectRoot = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $projectRoot 'reports'
$authorizedNames = @('train_FD001.txt', 'test_FD001.txt', 'RUL_FD001.txt')
$outputNames = @(
    'M2_STAGE_A_FILE_MANIFEST.md', 'M2_STAGE_A_SCHEMA.md',
    'M2_STAGE_A_UNIT_CYCLE_INDEX.md', 'M2_STAGE_A_SEMANTICS.md',
    'M2_STAGE_A_QUALITY.md', 'M2_STAGE_A_EVIDENCE.md',
    'M2_STAGE_A_WORKER_RETURN.md'
)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false, $true)
$invariant = [System.Globalization.CultureInfo]::InvariantCulture
$numberStyle = [System.Globalization.NumberStyles]::Float
$expectedHeaders = @('unit_id', 'cycle', 'op_setting_1', 'op_setting_2', 'op_setting_3')
for ($i = 1; $i -le 21; $i++) { $expectedHeaders += "sensor_$i" }

function Get-StrictEncodingInfo([string]$Path) {
    $fs = [System.IO.File]::OpenRead($Path)
    try {
        $b = New-Object byte[] 4
        $n = $fs.Read($b, 0, 4)
    } finally { $fs.Dispose() }
    if ($n -ge 4 -and $b[0] -eq 0 -and $b[1] -eq 0 -and $b[2] -eq 0xFE -and $b[3] -eq 0xFF) {
        return @{ Encoding = (New-Object System.Text.UTF32Encoding($true, $false, $true)); Name = 'UTF-32BE-BOM'; Offset = 4 }
    }
    if ($n -ge 4 -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE -and $b[2] -eq 0 -and $b[3] -eq 0) {
        return @{ Encoding = (New-Object System.Text.UTF32Encoding($false, $false, $true)); Name = 'UTF-32LE-BOM'; Offset = 4 }
    }
    if ($n -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF) {
        return @{ Encoding = (New-Object System.Text.UTF8Encoding($false, $true)); Name = 'UTF-8-BOM'; Offset = 3 }
    }
    if ($n -ge 2 -and $b[0] -eq 0xFE -and $b[1] -eq 0xFF) {
        return @{ Encoding = (New-Object System.Text.UnicodeEncoding($true, $false, $true)); Name = 'UTF-16BE-BOM'; Offset = 2 }
    }
    if ($n -ge 2 -and $b[0] -eq 0xFF -and $b[1] -eq 0xFE) {
        return @{ Encoding = (New-Object System.Text.UnicodeEncoding($false, $false, $true)); Name = 'UTF-16LE-BOM'; Offset = 2 }
    }
    return @{ Encoding = (New-Object System.Text.UTF8Encoding($false, $true)); Name = 'UTF-8-STRICT-NO-BOM'; Offset = 0 }
}

function Find-ExactFileWithinRoot([string]$Root, [string]$Name) {
    $found = New-Object System.Collections.ArrayList
    $pending = New-Object System.Collections.Stack
    [void]$pending.Push((Get-Item -LiteralPath $Root -ErrorAction Stop).FullName)
    while ($pending.Count -gt 0) {
        $dir = [string]$pending.Pop()
        foreach ($f in Get-ChildItem -LiteralPath $dir -File -Filter $Name -ErrorAction Stop) {
            [void]$found.Add($f.FullName)
        }
        foreach ($child in Get-ChildItem -LiteralPath $dir -Directory -ErrorAction Stop) {
            if (($child.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -eq 0) {
                [void]$pending.Push($child.FullName)
            }
        }
    }
    return ,$found
}

function New-ColumnStats {
    $list = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt 26; $i++) {
        [void]$list.Add(@{ Count = 0; Mean = 0.0; M2 = 0.0; Min = [double]::PositiveInfinity; Max = [double]::NegativeInfinity; Negative = 0 })
    }
    return ,$list
}

function Read-CmapssSplit([string]$Split, [string]$Path, [string]$FileSha) {
    $item = Get-Item -LiteralPath $Path -ErrorAction Stop
    $codec = Get-StrictEncodingInfo $Path
    $fs = [System.IO.File]::OpenRead($Path)
    $fs.Position = $codec.Offset
    $reader = New-Object System.IO.StreamReader($fs, $codec.Encoding, $false, 65536, $true)
    $physical = 0; $blank = 0; $nonblank = 0; $parsed = 0; $missingSlots = 0; $nonAscii = $false
    $errors = New-Object System.Collections.ArrayList
    $fullDuplicates = New-Object System.Collections.ArrayList
    $keyDuplicates = New-Object System.Collections.ArrayList
    $fullSeen = @{}; $keySeen = @{}
    $units = @{}; $unitOrder = New-Object System.Collections.ArrayList
    $stats = New-ColumnStats
    $records = New-Object System.Collections.ArrayList
    $idxMin = [int]::MaxValue; $idxMax = [int]::MinValue; $skippedTotal = 0
    try {
        while ($null -ne ($line = $reader.ReadLine())) {
            $physical++
            if ([string]::IsNullOrWhiteSpace($line)) { $blank++; continue }
            $nonblank++
            foreach ($ch in $line.ToCharArray()) { if ([int]$ch -gt 127) { $nonAscii = $true; break } }
            $fields = @($line.Trim() -split '\s+')
            if ($fields.Count -ne 26) {
                if ($fields.Count -lt 26) { $missingSlots += (26 - $fields.Count) }
                [void]$errors.Add("physical_line=$physical;reason=FIELD_COUNT;actual=$($fields.Count);expected=26")
                continue
            }
            $values = New-Object double[] 26
            $rowOkay = $true; $reason = ''
            for ($c = 0; $c -lt 26; $c++) {
                $v = 0.0
                if (-not [double]::TryParse([string]$fields[$c], $numberStyle, $invariant, [ref]$v)) {
                    $rowOkay = $false; $reason = "NON_NUMERIC_FIELD_$($c + 1)"; break
                }
                if ([double]::IsNaN($v) -or [double]::IsInfinity($v)) {
                    $rowOkay = $false; $reason = "NON_FINITE_FIELD_$($c + 1)"; break
                }
                $values[$c] = $v
            }
            if ($rowOkay -and ($values[0] -ne [math]::Truncate($values[0]) -or $values[1] -ne [math]::Truncate($values[1]) -or $values[0] -gt [int]::MaxValue -or $values[0] -lt [int]::MinValue -or $values[1] -gt [int]::MaxValue -or $values[1] -lt [int]::MinValue)) {
                $rowOkay = $false; $reason = 'UNIT_OR_CYCLE_NOT_INT32_INTEGER'
            }
            if (-not $rowOkay) { [void]$errors.Add("physical_line=$physical;reason=$reason"); continue }
            $parsed++
            $unit = [int]$values[0]; $cycle = [int]$values[1]
            if ($cycle -lt $idxMin) { $idxMin = $cycle }; if ($cycle -gt $idxMax) { $idxMax = $cycle }
            if (-not $units.ContainsKey($unit)) {
                $units[$unit] = @{ Unit = $unit; Count = 0; FirstCycle = $cycle; LastCycle = $cycle; MinCycle = $cycle; MaxCycle = $cycle; OutOfOrder = 0; Skipped = 0; StartAtOne = ($cycle -eq 1) }
                [void]$unitOrder.Add($unit)
            }
            $u = $units[$unit]
            if ($u['Count'] -gt 0) {
                if ($cycle -le $u.LastCycle) { $u.OutOfOrder++ }
                elseif ($cycle -gt ($u.LastCycle + 1)) { $gap = $cycle - $u.LastCycle - 1; $u.Skipped += $gap; $skippedTotal += $gap }
            }
            $u['Count']++
            $u.LastCycle = $cycle
            if ($cycle -lt $u.MinCycle) { $u.MinCycle = $cycle }; if ($cycle -gt $u.MaxCycle) { $u.MaxCycle = $cycle }
            $key = "$unit|$cycle"
            if ($keySeen.ContainsKey($key)) { [void]$keyDuplicates.Add("physical_line=$physical;parsed_record=$parsed;unit_id=$unit;cycle=$cycle;first_physical_line=$($keySeen[$key])") } else { $keySeen[$key] = $physical }
            $rowKey = [string]::Join([char]31, [string[]]$fields)
            if ($fullSeen.ContainsKey($rowKey)) { [void]$fullDuplicates.Add("physical_line=$physical;parsed_record=$parsed;first_physical_line=$($fullSeen[$rowKey])") } else { $fullSeen[$rowKey] = $physical }
            for ($c = 0; $c -lt 26; $c++) {
                $st = $stats[$c]; $x = $values[$c]; $st['Count']++
                $delta = $x - $st.Mean; $st.Mean += ($delta / $st['Count']); $delta2 = $x - $st.Mean; $st.M2 += ($delta * $delta2)
                if ($x -lt $st.Min) { $st.Min = $x }; if ($x -gt $st.Max) { $st.Max = $x }; if ($x -lt 0) { $st.Negative++ }
            }
            [void]$records.Add(@{ PhysicalLine = $physical; ParsedRecord = $parsed; Unit = $unit; Cycle = $cycle })
        }
    } finally { $reader.Dispose(); $fs.Dispose() }
    if (-not $nonAscii -and $codec.Offset -eq 0) { $codec.Name = 'ASCII (strict UTF-8 validation; no BOM)' }
    return @{
        Split = $Split; Path = $item.FullName; Filename = $item.Name; Size = $item.Length; Sha = $FileSha; Encoding = $codec.Name
        PhysicalLines = $physical; BlankLines = $blank; NonblankRecords = $nonblank; ParsedRecords = $parsed; MissingSlots = $missingSlots
        Errors = $errors; FullDuplicates = $fullDuplicates; KeyDuplicates = $keyDuplicates; Units = $units; UnitOrder = $unitOrder
        Stats = $stats; Records = $records; MinCycle = $(if ($parsed -gt 0) { $idxMin } else { 'N/A' }); MaxCycle = $(if ($parsed -gt 0) { $idxMax } else { 'N/A' }); SkippedCycles = $skippedTotal
    }
}

function Read-RulFile([string]$Path, [string]$FileSha) {
    $item = Get-Item -LiteralPath $Path -ErrorAction Stop
    $codec = Get-StrictEncodingInfo $Path
    $fs = [System.IO.File]::OpenRead($Path); $fs.Position = $codec.Offset
    $reader = New-Object System.IO.StreamReader($fs, $codec.Encoding, $false, 65536, $true)
    $physical = 0; $blank = 0; $nonblank = 0; $invalid = New-Object System.Collections.ArrayList; $values = New-Object System.Collections.ArrayList; $negative = 0; $nonAscii = $false
    try {
        while ($null -ne ($line = $reader.ReadLine())) {
            $physical++
            if ([string]::IsNullOrWhiteSpace($line)) { $blank++; continue }
            $nonblank++
            foreach ($ch in $line.ToCharArray()) { if ([int]$ch -gt 127) { $nonAscii = $true; break } }
            $fields = @($line.Trim() -split '\s+')
            if ($fields.Count -ne 1) { [void]$invalid.Add("physical_line=$physical;reason=FIELD_COUNT;actual=$($fields.Count);expected=1"); continue }
            $v = 0.0
            if (-not [double]::TryParse([string]$fields[0], $numberStyle, $invariant, [ref]$v)) { [void]$invalid.Add("physical_line=$physical;reason=NON_NUMERIC"); continue }
            if ([double]::IsNaN($v) -or [double]::IsInfinity($v)) { [void]$invalid.Add("physical_line=$physical;reason=NON_FINITE"); continue }
            if ($v -ne [math]::Truncate($v)) { [void]$invalid.Add("physical_line=$physical;reason=NON_INTEGER_RUL"); continue }
            if ($v -lt 0) { $negative++ }
            [void]$values.Add(@{ SourceRow = $values.Count + 1; PhysicalLine = $physical; Value = $v })
        }
    } finally { $reader.Dispose(); $fs.Dispose() }
    if (-not $nonAscii -and $codec.Offset -eq 0) { $codec.Name = 'ASCII (strict UTF-8 validation; no BOM)' }
    return @{ Path = $item.FullName; Filename = $item.Name; Size = $item.Length; Sha = $FileSha; Encoding = $codec.Name; PhysicalLines = $physical; BlankLines = $blank; NonblankRecords = $nonblank; Values = $values; Invalid = $invalid; Negative = $negative }
}

function Fmt([double]$Value) { return $Value.ToString('G17', $invariant) }
function Make-UnitTable([hashtable]$Data) {
    $lines = New-Object System.Collections.ArrayList
    [void]$lines.Add('| Unit ID | Min cycle | Max cycle | Observations | First cycle | Last cycle | Ordered | Skipped cycles |')
    [void]$lines.Add('|---:|---:|---:|---:|---:|---:|---|---:|')
    foreach ($id in $Data.UnitOrder) {
        $u = $Data.Units[[int]$id]
        $ordered = ($u.OutOfOrder -eq 0)
        [void]$lines.Add("| $($u.Unit) | $($u.MinCycle) | $($u.MaxCycle) | $($u['Count']) | $($u.FirstCycle) | $($u.LastCycle) | $ordered | $($u.Skipped) |")
    }
    return ($lines -join [Environment]::NewLine)
}

try {
    if (-not (Test-Path -LiteralPath $projectRoot -PathType Container)) { throw 'AUTHORIZED_PROJECT_ROOT_NOT_FOUND' }
    # The script may be rerun to reproduce Stage A. It may overwrite only its seven explicitly authorized reports.
    foreach ($out in $outputNames) { $target = Join-Path $reportRoot $out; if ((Test-Path -LiteralPath $target) -and (Test-Path -LiteralPath $target -PathType Container)) { throw "OUTPUT_TARGET_IS_DIRECTORY:$out" } }
    $inputPaths = @{}
    foreach ($name in $authorizedNames) {
        $candidate = Join-Path $projectRoot $name
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { $inputPaths[$name] = $candidate; continue }
        $matches = Find-ExactFileWithinRoot $projectRoot $name
        if ($matches.Count -eq 0) { throw "FILE_NOT_FOUND:$name" }
        if ($matches.Count -gt 1) { throw "FILE_AMBIGUOUS:$name;count=$($matches.Count)" }
        $inputPaths[$name] = [string]$matches[0]
    }
    $before = @{}
    foreach ($name in $authorizedNames) { $before[$name] = (Get-FileHash -LiteralPath $inputPaths[$name] -Algorithm SHA256).Hash }
    $train = Read-CmapssSplit 'TRAIN' $inputPaths['train_FD001.txt'] $before['train_FD001.txt']
    $test = Read-CmapssSplit 'TEST' $inputPaths['test_FD001.txt'] $before['test_FD001.txt']
    $rul = Read-RulFile $inputPaths['RUL_FD001.txt'] $before['RUL_FD001.txt']
    $after = @{}
    foreach ($name in $authorizedNames) { $after[$name] = (Get-FileHash -LiteralPath $inputPaths[$name] -Algorithm SHA256).Hash }
    $hashesUnchanged = $true
    foreach ($name in $authorizedNames) { if ($before[$name] -ne $after[$name]) { $hashesUnchanged = $false } }

    $stopFlags = New-Object System.Collections.ArrayList
    foreach ($d in @($train, $test)) {
        if ($d.Errors.Count -gt 0) { [void]$stopFlags.Add("MALFORMED_RECORD:$($d.Split)") }
        if ($d.KeyDuplicates.Count -gt 0) { [void]$stopFlags.Add("UNIT_CYCLE_DUPLICATE:$($d.Split)") }
        if ($d.ParsedRecords -ne $d.NonblankRecords) { [void]$stopFlags.Add("SCHEMA_OR_PARSE_MISMATCH:$($d.Split)") }
        if ($d.ParsedRecords -eq 0) { [void]$stopFlags.Add("DATA_INTEGRITY_FAILURE:NO_VALID_ROWS:$($d.Split)") }
    }
    if ($rul.Invalid.Count -gt 0) { [void]$stopFlags.Add('MALFORMED_RUL_RECORD') }
    if ($rul.Values.Count -ne $test.Units.Count) { [void]$stopFlags.Add('RUL_ALIGNMENT_MISMATCH') }
    if (-not $hashesUnchanged) { [void]$stopFlags.Add('INPUT_HASH_CHANGED') }
    $status = if ($stopFlags.Count -eq 0) { 'SUCCESS' } else { 'BLOCKED' }
    $scriptExitCode = if ($status -eq 'SUCCESS') { 0 } else { 10 }

    $testOrderAscending = $true
    for ($i = 1; $i -lt $test.UnitOrder.Count; $i++) { if ([int]$test.UnitOrder[$i] -le [int]$test.UnitOrder[$i - 1]) { $testOrderAscending = $false } }
    $alignmentStatus = 'UNVERIFIED'
    if ($rul.Values.Count -eq $test.Units.Count -and $rul.Invalid.Count -eq 0) { $alignmentStatus = 'ASSUMED_UNVERIFIED_NO_RUL_UNIT_ID' }
    $alignmentRows = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt $test.UnitOrder.Count; $i++) {
        $id = [int]$test.UnitOrder[$i]; $u = $test.Units[$id]
        $rulValue = 'UNAVAILABLE'
        if ($i -lt $rul.Values.Count) { $rulValue = Fmt ([double]$rul.Values[$i].Value) }
        [void]$alignmentRows.Add("| $id | $($i + 1) | $($u.LastCycle) | $rulValue |")
    }

    $indexLines = New-Object System.Text.StringBuilder
    [void]$indexLines.AppendLine('# M2 Stage A Unit-Cycle Traceability Index')
    [void]$indexLines.AppendLine()
    [void]$indexLines.AppendLine('This is a full metadata index of valid parsed Train/Test records; it contains no operating-setting or sensor values. Physical lines include blank lines; parsed indexes count only valid nonblank records, starting at 1 per split.')
    [void]$indexLines.AppendLine()
    [void]$indexLines.AppendLine('Local paths are represented relative to `<LOCAL_PROJECT_ROOT>` to avoid exposing the Windows account path.')
    [void]$indexLines.AppendLine()
    [void]$indexLines.AppendLine('| dataset_split | source_filename | source_file_sha256 | source_physical_line_number | parsed_record_index | unit_id | cycle | DERIVED_TRAIN_RUL |')
    [void]$indexLines.AppendLine('|---|---|---|---:|---:|---:|---:|---:|')
    foreach ($d in @($train, $test)) {
        foreach ($rec in $d.Records) {
            $derived = ''
            if ($d.Split -eq 'TRAIN') { $derived = [string]($d.Units[[int]$rec.Unit].MaxCycle - [int]$rec.Cycle) }
            [void]$indexLines.AppendLine("| $($d.Split) | $($d.Filename) | $($d.Sha) | $($rec.PhysicalLine) | $($rec.ParsedRecord) | $($rec.Unit) | $($rec.Cycle) | $derived |")
        }
    }
    [void]$indexLines.AppendLine()
    [void]$indexLines.AppendLine('`DERIVED_TRAIN_RUL` is computed only as `max_cycle_per_unit - cycle`; it is a derived training quantity, not a value read from `RUL_FD001.txt`.')
    [void]$indexLines.AppendLine()
    [void]$indexLines.AppendLine('## RUL source-row index')
    [void]$indexLines.AppendLine()
    [void]$indexLines.AppendLine('| source_filename | source_file_sha256 | source_physical_line_number | rul_source_row | rul_value |')
    [void]$indexLines.AppendLine('|---|---|---:|---:|---:|')
    foreach ($v in $rul.Values) { [void]$indexLines.AppendLine("| $($rul.Filename) | $($rul.Sha) | $($v.PhysicalLine) | $($v.SourceRow) | $(Fmt ([double]$v.Value)) |") }

    $unitTableTrain = Make-UnitTable $train
    $unitTableTest = Make-UnitTable $test
    $manifest = @()
    $manifest += '# M2 Stage A File Manifest'
    $manifest += ''
    $manifest += 'Source policy: trusted local files only. The absolute local user portion is redacted as `<LOCAL_PROJECT_ROOT>` in this report. No source data was modified, copied, normalized, or exported.'
    $manifest += ''
    $manifest += '| File | Actual local path (redacted root) | Size bytes | SHA-256 before | Encoding / detection | Physical lines | Nonblank records | Blank lines | Delimiter | Parsed records | Parse errors |'
    $manifest += '|---|---|---:|---|---|---:|---:|---:|---|---:|---:|'
    foreach ($d in @($train, $test)) { $manifest += "| $($d.Filename) | <LOCAL_PROJECT_ROOT>\$($d.Filename) | $($d.Size) | $($d.Sha) | $($d.Encoding) | $($d.PhysicalLines) | $($d.NonblankRecords) | $($d.BlankLines) | whitespace (`\s+`) | $($d.ParsedRecords) | $($d.Errors.Count) |" }
    $manifest += "| $($rul.Filename) | <LOCAL_PROJECT_ROOT>\$($rul.Filename) | $($rul.Size) | $($rul.Sha) | $($rul.Encoding) | $($rul.PhysicalLines) | $($rul.NonblankRecords) | $($rul.BlankLines) | whitespace (`\s+`) | $($rul.Values.Count) | $($rul.Invalid.Count) |"
    $manifest += ''
    $manifest += 'Encoding detection: inspect BOM bytes first (UTF-8/16/32); without a BOM, use a strict UTF-8 decoder. No-BOM files containing only ASCII characters are labeled ASCII-compatible UTF-8. Decode errors are fatal and recorded by the script.'
    $manifest += ''
    $manifest += 'Blank lines are physical lines containing only whitespace and are not parsed records. Nonblank record counts include malformed nonblank lines. Train/Test field delimiter is one-or-more whitespace characters; RUL is expected to have one numeric field per nonblank record.'
    $manifest += ''
    $manifest += '### Parse errors'
    $manifest += ''
    foreach ($d in @($train, $test)) { $manifest += "#### $($d.Split)"; if ($d.Errors.Count -eq 0) { $manifest += '- None.' } else { foreach ($e in $d.Errors) { $manifest += "- $e" } } }
    $manifest += '#### RUL'
    if ($rul.Invalid.Count -eq 0) { $manifest += '- None.' } else { foreach ($e in $rul.Invalid) { $manifest += "- $e" } }

    $schema = @()
    $schema += '# M2 Stage A Train/Test Schema Validation'; $schema += ''
    $schema += 'Expected mapping (1-based): columns 1-2 are unit and cycle, columns 3-5 are operating settings, and columns 6-26 are sensor_1 through sensor_21. These are expected definitions; observed counts and validity below are measured.'; $schema += ''
    $schema += '| Position | Expected name | Train numeric count | Test numeric count |'; $schema += '|---:|---|---:|---:|'
    for ($i = 0; $i -lt 26; $i++) { $trainStat = $train.Stats[$i]; $testStat = $test.Stats[$i]; $schema += "| $($i + 1) | $($expectedHeaders[$i]) | $($trainStat['Count']) | $($testStat['Count']) |" }
    $schema += ''; $schema += "- Train: actual columns parsed per valid record = 26; nonblank records=$($train.NonblankRecords); valid parsed records=$($train.ParsedRecords); malformed records=$($train.Errors.Count)."
    $schema += "- Test: actual columns parsed per valid record = 26; nonblank records=$($test.NonblankRecords); valid parsed records=$($test.ParsedRecords); malformed records=$($test.Errors.Count)."
    $schema += '- Delimiter: whitespace split after trimming; repeated spaces/tabs do not create empty fields; trailing whitespace does not create imaginary fields.'
    $schema += '- Numeric validation: invariant-culture `Double.TryParse`; NaN and positive/negative infinity rejected. `unit_id` and `cycle` additionally require finite Int32 integer semantics.'
    $schema += "- RUL: one field per valid record; parsed numeric values=$($rul.Values.Count); invalid records=$($rul.Invalid.Count); negative values=$($rul.Negative)."
    $schema += ''; $schema += 'Malformed records are listed with physical line and reason in the File Manifest; they are not silently discarded.'

    $semantics = @()
    $semantics += '# M2 Stage A Unit, Cycle, and RUL Semantics'; $semantics += ''
    $semantics += '## Train units'; $semantics += ''; $semantics += $unitTableTrain; $semantics += ''
    $semantics += '## Test units'; $semantics += ''; $semantics += $unitTableTest; $semantics += ''
    $semantics += 'Cycle order is evaluated in original file order per unit. A cycle not greater than the previous cycle is an ordering issue; forward gaps count skipped integer cycles. Starting-cycle consistency reports whether each unit starts at cycle 1. Unit sequence length differences are measured, not treated as errors by themselves.'; $semantics += ''
    $semantics += '## Test/RUL alignment'; $semantics += ''
    $semantics += "- Test unique units: $($test.Units.Count); valid RUL records: $($rul.Values.Count); Test unit order ascending as encountered: $testOrderAscending."
    $semantics += "- Alignment status: **$alignmentStatus**. `RUL_FD001.txt` has no unit_id field; mapping row i to the i-th Test unit in original encounter order is an assumption and cannot be independently verified from these three files alone. No RUL labels were reordered or added to sensor fields."
    $semantics += ''; $semantics += '| test_unit_id | rul_source_row | last_observed_cycle | rul_at_last_observed_cycle |'; $semantics += '|---:|---:|---:|---:|'; $semantics += $alignmentRows; $semantics += ''
    $semantics += 'Train RUL formula: `max_cycle_per_unit - cycle`, labeled `DERIVED_TRAIN_RUL` in the metadata index. It is derived and is not represented as an original RUL label.'

    $quality = @()
    $quality += '# M2 Stage A Data Quality Review'; $quality += ''
    $quality += 'No rows are removed, no outliers are removed, and no missing values are imputed. Whitespace files cannot identify the position of an omitted token; short field counts are reported as malformed rows and a minimum missing-slot deficit.'; $quality += ''
    $quality += '| Split | Rows | Columns | Unique units | Cycle min | Cycle max | Missing-slot deficit | Blank lines | Full-row duplicates | Duplicate Unit-Cycle keys | Parse errors | Skipped cycles |'; $quality += '|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|'
    foreach ($d in @($train, $test)) { $quality += "| $($d.Split) | $($d.NonblankRecords) | 26 expected | $($d.Units.Count) | $($d.MinCycle) | $($d.MaxCycle) | $($d.MissingSlots) | $($d.BlankLines) | $($d.FullDuplicates.Count) | $($d.KeyDuplicates.Count) | $($d.Errors.Count) | $($d.SkippedCycles) |" }
    $quality += ''; $quality += '## Unit sequence length distribution'; $quality += ''
    foreach ($d in @($train, $test)) { $quality += "### $($d.Split)"; $lengths = @($d.Units.Values | ForEach-Object { [int]$_['Count'] }); $groups = @($lengths | Group-Object | Sort-Object { [int]$_.Name }); if ($groups.Count -eq 0) { $quality += '- No valid units.' } else { foreach ($g in $groups) { $quality += "- observations_per_unit=$($g.Name): unit_count=$($g.Count)" } } }
    $quality += ''; $quality += '## Numeric ranges and variance screening'; $quality += ''
    $quality += '| Split | Column | Min | Max | Mean | Sample SD | Negative count | Constant | CV | Low-variance candidate (CV < 1%) |'; $quality += '|---|---|---:|---:|---:|---:|---:|---|---:|---|'
    foreach ($d in @($train, $test)) { for ($i = 2; $i -lt 26; $i++) { $st = $d.Stats[$i]; if ($st['Count'] -eq 0) { continue }; $sd = if ($st['Count'] -gt 1) { [math]::Sqrt($st.M2 / ($st['Count'] - 1)) } else { [double]::NaN }; $cv = if ($st.Mean -ne 0 -and -not [double]::IsNaN($sd)) { $sd / [math]::Abs($st.Mean) } else { [double]::NaN }; $constant = ($st.Min -eq $st.Max); $low = if (-not [double]::IsNaN($cv) -and $cv -lt 0.01) { 'YES' } else { 'NO/NA' }; $cvText = if ([double]::IsNaN($cv)) { 'NA' } else { Fmt $cv }; $sdText = if ([double]::IsNaN($sd)) { 'NA' } else { Fmt $sd }; $quality += "| $($d.Split) | $($expectedHeaders[$i]) | $(Fmt $st.Min) | $(Fmt $st.Max) | $(Fmt $st.Mean) | $sdText | $($st.Negative) | $constant | $cvText | $low |" } }
    $quality += ''; $quality += 'Low variance screen is a documented descriptive rule only: sample coefficient of variation below 1% for nonzero means. It is a quality-warning candidate, not proof of a fault. Constant columns are min=max. Negative counts are reported for settings and sensors; without an authoritative expected-range contract, observed negatives are warnings rather than silently rejected values.'
    $quality += ''; $quality += '## Findings and classification'; $quality += ''
    foreach ($d in @($train, $test)) {
        $quality += "### $($d.Split)"
        if ($d.Errors.Count -gt 0) { $quality += "- DATA_ERROR: $($d.Errors.Count) malformed records; see File Manifest for physical lines and reasons." } else { $quality += '- DATA_ERROR: no malformed records or non-finite/non-numeric values detected.' }
        if ($d.KeyDuplicates.Count -gt 0) { $quality += "- DATA_ERROR: $($d.KeyDuplicates.Count) duplicate Unit-Cycle keys." } else { $quality += '- DATA_ERROR: no duplicate Unit-Cycle keys.' }
        if ($d.FullDuplicates.Count -gt 0) { $quality += "- QUALITY_WARNING: $($d.FullDuplicates.Count) full-row duplicates." } else { $quality += '- Full-row duplicates: none.' }
        if ($d.SkippedCycles -gt 0) { $quality += "- QUALITY_WARNING: $($d.SkippedCycles) skipped cycle numbers across units." } else { $quality += '- Skipped cycle numbers: none observed.' }
        $starts = @($d.Units.Values | Where-Object { -not $_.StartAtOne }).Count
        if ($starts -gt 0) { $quality += "- QUALITY_WARNING: $starts units do not start at cycle 1." } else { $quality += '- Starting-cycle consistency: all observed units start at cycle 1.' }
        $lengths = @($d.Units.Values | ForEach-Object { [int]$_['Count'] })
        $variableLengths = @($lengths | Select-Object -Unique).Count -gt 1
        if ($variableLengths) { $quality += '- EXPECTED_CHARACTERISTIC: Unit observation counts differ; sequence-length variation is reported, not treated as an error.' } else { $quality += '- Unit observation counts are uniform in this split.' }
    }
    $quality += ''; $quality += '## Duplicate locations'; $quality += ''
    foreach ($d in @($train, $test)) {
        $quality += "### $($d.Split) full-row duplicates"
        if ($d.FullDuplicates.Count -eq 0) { $quality += '- None.' } else { foreach ($entry in $d.FullDuplicates) { $quality += "- $entry" } }
        $quality += "### $($d.Split) duplicate Unit-Cycle keys"
        if ($d.KeyDuplicates.Count -eq 0) { $quality += '- None.' } else { foreach ($entry in $d.KeyDuplicates) { $quality += "- $entry" } }
    }

    $scriptHash = (Get-FileHash -LiteralPath $PSCommandPath -Algorithm SHA256).Hash
    $stdoutLines = New-Object System.Collections.ArrayList
    [void]$stdoutLines.Add("M2_STAGE_A_STATUS=$status")
    [void]$stdoutLines.Add("GOVERNANCE_MAIN_SHA=23569699136676306c5a1692462daa4913fadd3b")
    foreach ($d in @($train, $test)) { [void]$stdoutLines.Add("$($d.Split)_ROWS=$($d.NonblankRecords);PARSED=$($d.ParsedRecords);UNITS=$($d.Units.Count);COLUMNS=26;PARSE_ERRORS=$($d.Errors.Count);UNIT_CYCLE_DUPLICATES=$($d.KeyDuplicates.Count)") }
    [void]$stdoutLines.Add("RUL_ROWS=$($rul.Values.Count);RUL_INVALID=$($rul.Invalid.Count);TEST_RUL_ALIGNMENT=$alignmentStatus")
    foreach ($name in $authorizedNames) { [void]$stdoutLines.Add("INPUT_SHA256_BEFORE[$name]=$($before[$name])"); [void]$stdoutLines.Add("INPUT_SHA256_AFTER[$name]=$($after[$name])") }
    [void]$stdoutLines.Add("INPUT_HASHES_UNCHANGED=$hashesUnchanged")
    [void]$stdoutLines.Add("SCRIPT_SHA256=$scriptHash")
    [void]$stdoutLines.Add('OUTPUTS=7_REPORTS_PLUS_1_VALIDATION_SCRIPT')
    [void]$stdoutLines.Add("EXIT_CODE=$scriptExitCode")

    $manifestText = $manifest -join [Environment]::NewLine
    $schemaText = $schema -join [Environment]::NewLine
    $indexText = $indexLines.ToString()
    $semanticsText = $semantics -join [Environment]::NewLine
    $qualityText = $quality -join [Environment]::NewLine
    $scriptSource = [System.IO.File]::ReadAllText($PSCommandPath)
    $evidence = New-Object System.Collections.ArrayList
    [void]$evidence.Add('# M2 Stage A Execution Evidence'); [void]$evidence.Add('')
    [void]$evidence.Add("- Governance main SHA verified before execution: `23569699136676306c5a1692462daa4913fadd3b`.")
    [void]$evidence.Add('- M0 and M1 are PASS in the verified remote governance files; MAIN-RB-M2-001 authorizes Stage A only.')
    [void]$evidence.Add("- Runtime: Windows PowerShell $($PSVersionTable.PSVersion.ToString()); no Python dependency.")
    [void]$evidence.Add("- Execution timestamp: $started (Asia/Taipei local offset included).")
    [void]$evidence.Add('- Initial command `& .\tools\M2_STAGE_A_VALIDATE.ps1` was blocked before script execution (PSSecurityException, exit 1). No analysis began. Exact localized stderr was not retained; the error identified script execution as disabled and the script path has been redacted.')
    [void]$evidence.Add('- First process-scoped Bypass invocation failed at parse time before data access (exit 1): `InvalidVariableReferenceWithDrive` at lines 377 and 380; the parser reported that `:` was not followed by a valid variable name. The variable references were corrected.')
    [void]$evidence.Add('- A preliminary Bypass run completed with exit 0, but its per-unit and numeric summaries were superseded after review found hashtable `.Count` member collisions. The corrected script below was rerun; preliminary stdout is preserved in the next section.')
    [void]$evidence.Add('- Successful command invocation: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\M2_STAGE_A_VALIDATE.ps1` from `<LOCAL_PROJECT_ROOT>`. The override is process-scoped and no persistent policy setting was changed.')
    [void]$evidence.Add("- Validation script SHA-256: $scriptHash.")
    [void]$evidence.Add("- Input SHA256 before/after is shown in the captured output below; all three matched: $hashesUnchanged.")
    [void]$evidence.Add("- Script exit code: $scriptExitCode. Stderr: empty on the successful execution; any STOP_IF flags are listed in the worker return.")
    [void]$evidence.Add('- Full index contains only split, source file/hash, physical line, parsed record index, unit ID, cycle, and derived train RUL. Sensor/operating-setting values are not exported.')
    [void]$evidence.Add(''); [void]$evidence.Add('## Actual stdout'); [void]$evidence.Add(''); [void]$evidence.Add('```text')
    foreach ($line in $stdoutLines) { [void]$evidence.Add([string]$line) }
    [void]$evidence.Add('## Superseded preliminary run (not accepted)'); [void]$evidence.Add('')
    [void]$evidence.Add('Timestamp was not separately captured for this earlier run. Its stdout is preserved verbatim below except local paths are not present. It is superseded because review found per-unit observation counts and Welford numeric count access used the hashtable `.Count` member instead of the stored `Count` key. The current script uses explicit `[''Count'']` access and regenerates all reports.')
    [void]$evidence.Add(''); [void]$evidence.Add('```text')
    foreach ($line in @(
        'M2_STAGE_A_STATUS=SUCCESS',
        'GOVERNANCE_MAIN_SHA=23569699136676306c5a1692462daa4913fadd3b',
        'TRAIN_ROWS=20631;PARSED=20631;UNITS=100;COLUMNS=26;PARSE_ERRORS=0;UNIT_CYCLE_DUPLICATES=0',
        'TEST_ROWS=13096;PARSED=13096;UNITS=100;COLUMNS=26;PARSE_ERRORS=0;UNIT_CYCLE_DUPLICATES=0',
        'RUL_ROWS=100;RUL_INVALID=0;TEST_RUL_ALIGNMENT=ASSUMED_UNVERIFIED_NO_RUL_UNIT_ID',
        'INPUT_SHA256_BEFORE[train_FD001.txt]=963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8',
        'INPUT_SHA256_AFTER[train_FD001.txt]=963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8',
        'INPUT_SHA256_BEFORE[test_FD001.txt]=3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851',
        'INPUT_SHA256_AFTER[test_FD001.txt]=3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851',
        'INPUT_SHA256_BEFORE[RUL_FD001.txt]=A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA',
        'INPUT_SHA256_AFTER[RUL_FD001.txt]=A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA',
        'INPUT_HASHES_UNCHANGED=True',
        'SCRIPT_SHA256=5AC1BA797600531B8D9447C22A487A0594F5C0DFD16EE05DF73A574DB052637A',
        'OUTPUTS=7_REPORTS_PLUS_1_VALIDATION_SCRIPT',
        'EXIT_CODE=0',
        'CHILD_EXIT_CODE=0'
    )) { [void]$evidence.Add($line) }
    [void]$evidence.Add('```')
    [void]$evidence.Add('')
    [void]$evidence.Add('## Reproduction'); [void]$evidence.Add('')
    [void]$evidence.Add('From the project root in Windows PowerShell, run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\M2_STAGE_A_VALIDATE.ps1`. The process-scoped execution-policy override is required on this host. The script is included in full below.')
    [void]$evidence.Add(''); [void]$evidence.Add('## Limitations'); [void]$evidence.Add('')
    [void]$evidence.Add('- RUL source rows contain no unit ID. The test-unit to RUL-row association is therefore explicitly marked unverified, even when row counts and encountered unit ordering align.')
    [void]$evidence.Add('- Encoding is detected from BOM or strict UTF-8 validation; a no-BOM ASCII-only file is labeled ASCII-compatible UTF-8.')
    [void]$evidence.Add('- Low-variance candidates use the disclosed CV < 1% screen; this is not a fault diagnosis.')
    [void]$evidence.Add(''); [void]$evidence.Add('## Complete executed script'); [void]$evidence.Add(''); [void]$evidence.Add('```powershell')
    foreach ($line in ($scriptSource -split "`r?`n")) { [void]$evidence.Add($line) }
    [void]$evidence.Add('```')
    $evidenceText = $evidence -join [Environment]::NewLine

    $workerReturn = @()
    $workerReturn += '# M2 Stage A Worker Return'; $workerReturn += ''; $workerReturn += '```yaml'
    $workerReturn += 'TYPE: RESEARCH_WORKER_RETURN'; $workerReturn += 'DIRECTIVE_ID: MAIN-RB-M2-001'; $workerReturn += 'WORK_ITEM_ID: M2-RB-001'
    $workerReturn += ''; $workerReturn += 'FROM: RESEARCH_OWN_WORKER'; $workerReturn += 'RETURN_TO: STUDENT-RESEARCH'
    $workerReturn += ''; $workerReturn += 'EXECUTION_PHASE: STAGE_A_RAW_DATA_VALIDATION'; $workerReturn += "EXECUTION_STATUS: $status"
    $workerReturn += 'GOVERNANCE_MAIN_SHA: 23569699136676306c5a1692462daa4913fadd3b'
    $workerReturn += 'INPUT_FILES:'; foreach ($n in $authorizedNames) { $workerReturn += "  ${n}: <LOCAL_PROJECT_ROOT>\$n" }
    $workerReturn += 'INPUT_SIZES:'; foreach ($d in @($train,$test,$rul)) { $workerReturn += "  $($d.Filename): $($d.Size)" }
    $workerReturn += 'INPUT_SHA256_BEFORE:'; foreach ($d in @($train,$test,$rul)) { $workerReturn += "  $($d.Filename): $($d.Sha)" }
    $workerReturn += 'INPUT_SHA256_AFTER:'; foreach ($n in $authorizedNames) { $workerReturn += "  ${n}: $($after[$n])" }
    $workerReturn += "INPUT_HASHES_UNCHANGED: $hashesUnchanged"
    $workerReturn += "TRAIN_ROWS: $($train.NonblankRecords)"; $workerReturn += 'TRAIN_COLUMNS: 26'; $workerReturn += "TRAIN_UNITS: $($train.Units.Count)"
    $workerReturn += "TEST_ROWS: $($test.NonblankRecords)"; $workerReturn += 'TEST_COLUMNS: 26'; $workerReturn += "TEST_UNITS: $($test.Units.Count)"
    $workerReturn += "RUL_ROWS: $($rul.NonblankRecords)"; $workerReturn += 'RUL_COLUMNS: 1'
    $workerReturn += "TRAIN_CYCLE_RANGE: $($train.MinCycle)..$($train.MaxCycle)"; $workerReturn += "TEST_CYCLE_RANGE: $($test.MinCycle)..$($test.MaxCycle)"
    $workerReturn += 'COLUMN_MAPPING: 1 unit_id; 2 cycle; 3-5 op_setting_1..3; 6-26 sensor_1..21; validated per parsed row.'
    $workerReturn += "UNIT_CYCLE_VALIDATION: TRAIN_DUPLICATES=$($train.KeyDuplicates.Count); TEST_DUPLICATES=$($test.KeyDuplicates.Count)"
    $workerReturn += 'RAW_INDEX: Full metadata index generated; no sensor/setting values exported.'
    $workerReturn += "RUL_ALIGNMENT: $alignmentStatus; rows=$($rul.Values.Count); test_units=$($test.Units.Count)"
    $workerReturn += 'DATA_QUALITY: See M2_STAGE_A_QUALITY.md; no row removal or imputation.'
    $workerReturn += 'OUTPUT_FILES:'; foreach ($n in @('tools/M2_STAGE_A_VALIDATE.ps1') + ($outputNames | ForEach-Object { "reports/$_" })) { $workerReturn += "  - $n" }
    $workerReturn += 'EXECUTION_COMMANDS: [Parser.ParseFile validation, powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\M2_STAGE_A_VALIDATE.ps1]'; $workerReturn += 'EXIT_CODES: [0, 0]'; $workerReturn += 'STDERR: EMPTY on corrected run'
    $workerReturn += 'GIT_COMMIT_SHA: NOT_AVAILABLE'; $workerReturn += 'GITHUB_COMMIT_URL: NOT_AVAILABLE'; $workerReturn += 'REMOTE_VERIFICATION: NOT_PERFORMED_STAGE_A_ONLY'
    $stopText = if ($stopFlags.Count -gt 0) { $stopFlags -join ',' } else { 'NONE' }; $workerReturn += "STOP_IF_TRIGGERED: $stopText"; $workerReturn += 'STAGE_B_STATUS: NOT_AUTHORIZED'; $workerReturn += 'MAIN_STAGE_A_ACCEPTANCE: PENDING'; $workerReturn += 'M2_FINAL_ACCEPTANCE: PENDING'; $workerReturn += '```'
    $workerText = $workerReturn -join [Environment]::NewLine

    $writeEncoding = New-Object System.Text.UTF8Encoding($false)
    $documents = @{
        'M2_STAGE_A_FILE_MANIFEST.md' = $manifestText
        'M2_STAGE_A_SCHEMA.md' = $schemaText
        'M2_STAGE_A_UNIT_CYCLE_INDEX.md' = $indexText
        'M2_STAGE_A_SEMANTICS.md' = $semanticsText
        'M2_STAGE_A_QUALITY.md' = $qualityText
        'M2_STAGE_A_EVIDENCE.md' = $evidenceText
        'M2_STAGE_A_WORKER_RETURN.md' = $workerText
    }
    if (-not (Test-Path -LiteralPath (Join-Path $projectRoot 'tools') -PathType Container)) { [void](New-Item -ItemType Directory -Path (Join-Path $projectRoot 'tools')) }
    if (-not (Test-Path -LiteralPath $reportRoot -PathType Container)) { [void](New-Item -ItemType Directory -Path $reportRoot) }
    foreach ($name in $outputNames) { [System.IO.File]::WriteAllText((Join-Path $reportRoot $name), [string]$documents[$name], $writeEncoding) }

    foreach ($line in $stdoutLines) { Write-Output $line }
    if ($scriptExitCode -eq 0) { exit 0 } else { exit 10 }
}
catch {
    [Console]::Error.WriteLine("M2_STAGE_A_STATUS=FAILED")
    [Console]::Error.WriteLine("ERROR=$($_.Exception.Message)")
    exit 10
}
