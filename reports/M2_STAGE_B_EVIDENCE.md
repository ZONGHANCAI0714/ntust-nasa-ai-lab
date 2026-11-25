# M2 Stage B Execution Evidence

Directive: MAIN-RB-M2-004; Stage B trend, quality, data dictionary, contract, traceability and contract tests only.

## Governance and runtime

- GitHub main SHA and exact-SHA governance reads: `972d4abf146b9fb5000b31253afae03ae326689e`; M0 PASS, M1 PASS, M2 Stage A accepted, this work item authorized by MAIN.
- Local main HEAD matched; no staged files. Direct `git ls-remote origin refs/heads/main` failed with Exit Code 128 due connection failure; GitHub connector independently verified main SHA and governance.
- Runtime: Windows PowerShell 5.1.26100.9818; .NET 4.0.30319.42000; timestamp: 2026-11-25T00:44:16.9650758+08:00 (Asia/Taipei).
- Invocation: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\M2_STAGE_B_ANALYZE.ps1` (process-scoped override; no persistent policy change).
- Script SHA256: 9F435F949C36B7AFE7800DBFA39C9628678C97C8ABF2C349417FC67BF700C650. Dependencies: PowerShell/.NET standard libraries only.

## Input integrity

- train_FD001.txt; size=3515356; before=963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8; after=963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8; unchanged=True.
- test_FD001.txt; size=2228855; before=3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851; after=3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851; unchanged=True.
- RUL_FD001.txt; size=429; before=A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA; after=A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA; unchanged=True.


## Failed attempts and rework

A parse-only check initially found five syntax errors before data access. The syntax was corrected; a later parse-only check returned PARSER_ERRORS=0.
The following failed executions stopped before report writes. Their error output is retained below. Local path information is redacted.

Attempt 1: PowerShell 5.1 process-scoped Bypass invocation; timestamp 2026-11-25T00:26:11.6485477+08:00; Exit Code 1.
Actual command: powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\M2_STAGE_B_ANALYZE.ps1
REDACTED_COPY_OF_ACTUAL_STDERR:
```text
M2_STAGE_B_STATUS=FAILED
ERROR=Argument types do not match
```
Parent command output: CHILD_EXIT_CODE=1.

Attempt 2: parser check plus the same process-scoped Bypass invocation; timestamp not separately captured; parser output was PARSER_ERRORS=0; analysis Exit Code 1.
REDACTED_COPY_OF_ACTUAL_STDERR:
```text
M2_STAGE_B_STATUS=FAILED
ERROR=Argument types do not match
ERROR_LINE=218
ERROR_COMMAND=    $contract=[ordered]@{
ERROR_STACK=at <ScriptBlock>, <LOCAL_PROJECT_ROOT>\tools\M2_STAGE_B_ANALYZE.ps1: line 218
```
Parent command output: CHILD_EXIT_CODE=1.
Cause and correction: PowerShell rejected generic-list conversion while constructing the JSON contract object. Contract arrays now use typed-list ToArray() values; the subsequent execution completed successfully.

Attempt 3: re-run after adding raw-source reference audit; timestamp not separately captured; Exit Code 1. Actual stderr is retained below. The failure exposed an audit-key collision because Train and Test share physical line numbers; the key was corrected to include split name and physical line number.
```text
M2_STAGE_B_STATUS=FAILED
ERROR=RAW_SOURCE_LOOKUP_FAILED:TEST-U1-S3 line=1
ERROR_LINE=174
ERROR_COMMAND=raw source sample audit loop; key collision between split-local physical line numbers
ERROR_STACK=at <ScriptBlock>, <LOCAL_PROJECT_ROOT>\tools\M2_STAGE_B_ANALYZE.ps1: line 174
```
Parent command output: CHILD_EXIT_CODE=1.
Correction: key source line references by split and physical line. The next execution completed and independently verified 2679/2679 references.

## Actual stdout

```text
M2_STAGE_B_STATUS=SUCCESS
GOVERNANCE_MAIN_SHA=972d4abf146b9fb5000b31253afae03ae326689e
TRAIN_ROWS=20631;UNITS=100;CYCLE_RANGE=1..362
TEST_ROWS=13096;UNITS=100;CYCLE_RANGE=1..303
RUL_ROWS=100;COLUMNS=1;TEST_UNITS=100;TEST_UNIT_ORDER_ASCENDING=True;RUL_ALIGNMENT=ORDER_BASED_MAPPING
TREND_SAMPLES=18;UNITS_PER_SPLIT=1,50,100;SENSORS=1,3,9;RAW_SOURCE_REFERENCES=2679/2679
CONTRACT_JSON_VALID=True;CONTRACT_VERSION=1.0.0-DRAFT;TESTS=16/16_PASS
SOURCE_HASHES_UNCHANGED=True
INPUT_SHA256_AFTER[train_FD001.txt]=963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8
INPUT_SHA256_AFTER[test_FD001.txt]=3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851
INPUT_SHA256_AFTER[RUL_FD001.txt]=A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA
SCRIPT_SHA256=9F435F949C36B7AFE7800DBFA39C9628678C97C8ABF2C349417FC67BF700C650
OUTPUTS=10_AUTHORIZED_FILES
EXIT_CODE=0
CHILD_EXIT_CODE=0
```

## Stderr and exit

Stderr: empty. Exit Code: 0. All contract tests passed.

## Reproduction

From the project root, run the invocation above in Windows PowerShell 5.1. The script verifies source hashes before parsing, computes Stage B outputs, verifies source hashes afterward, executes T01-T16 using the in-memory query functions, validates JSON syntax, and writes only the nine non-script authorized output files.

## Limitations

- Sensor physical meanings and units are not provided by the source schema and remain UNKNOWN.
- Test RUL has no Unit ID; row-order association is an explicit trusted-standard assumption, not direct identity verification.
- Trend claims are descriptive statistics, not failure diagnosis or causal inference.
- Whitespace format does not permit identifying the exact column of an omitted token in a short row.
## Post-review rework addendum

- Corrected the Stage B governance label from `23569699136676306c5a1692462daa4913fadd3b` to `972d4abf146b9fb5000b31253afae03ae326689e` in the trend report and the generator used for future runs. Historical execution logs were preserved unchanged.
- Removed only the duplicate RUL input hash line; the retained line preserves the original before/after SHA256 and unchanged result.
- Added the bounded JSON/Markdown/data-dictionary consistency checks to `M2_STAGE_B_CONTRACT_TESTS.md`; corrected run: 9/9 PASS, Exit Code 0. The initial checker mismatch and correction are recorded there and here.
- No Stage B data analysis was rerun. The source correction is static; the corrected script was parser-checked. This does not claim the corrected script was the original executed binary.
- Static parse command: PowerShell 5.1 [System.Management.Automation.Language.Parser]::ParseInput against `tools/M2_STAGE_B_ANALYZE.ps1`; actual output SCRIPT_PARSE_ERRORS=0; command Exit Code 0.
- ORIGINAL_EXECUTED_SCRIPT_SHA256: `9F435F949C36B7AFE7800DBFA39C9628678C97C8ABF2C349417FC67BF700C650`
- CORRECTED_SCRIPT_SHA256: `D20A9B5FF22389FB55D12711793CE08179E40AA73958058A73EFEFFB8DEBC7FE`

## Reproducibility correction addendum (B-REWORK-02)

### Corrections

- Removed the extra RUL hash append from the generator input section. Its generated input section now has one RUL source-hash entry.
- Added nine executed consistency assertions to the generator and to its generated contract-test report. A failed assertion stops with DATA_CONTRACT_INCONSISTENT.
- The generator reads and validates prior evidence before work, then appends each run as a separate section. It preserves the three failed attempts, original execution record, earlier checker failure, corrections and limitations.
- This addendum uses repository-relative paths in code formatting. Historical measurements and error output were not edited.

### Script history

- ORIGINAL_EXECUTED_SCRIPT_SHA256: `9F435F949C36B7AFE7800DBFA39C9628678C97C8ABF2C349417FC67BF700C650`
- Previous post-review script SHA256: `D20A9B5FF22389FB55D12711793CE08179E40AA73958058A73EFEFFB8DEBC7FE`
- Corrected generator SHA256 for this rework: `EC68D890B90BE7EFC5D7E79D1D396A5BB5184F93A663938CE97179366E31C5AA`
- The corrected generator was executed in VerifyOnly mode. It was not represented as the original executed binary.

### Static checks

- Parser command: PowerShell 5.1 `System.Management.Automation.Language.Parser::ParseInput` on `tools/M2_STAGE_B_ANALYZE.ps1`; output `SCRIPT_PARSE_ERRORS=0`; Exit Code 0.
- Pre-run static generation inspection: nine assertion names present; VerifyOnly branch precedes file writes; prior-evidence guard present; RUL hash generator entry count is one; Exit Code 0.
- Three source SHA256 values were checked before VerifyOnly and matched the accepted Stage A values. The run rechecked them after reading; all remained unchanged.

### VerifyOnly execution record

Command: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\\M2_STAGE_B_ANALYZE.ps1 -VerifyOnly`
Stderr: empty. Child Exit Code: 0. Parent Exit Code: 0. No report files were written by VerifyOnly.

Actual stdout:
```text
M2_STAGE_B_STATUS=SUCCESS
GOVERNANCE_MAIN_SHA=972d4abf146b9fb5000b31253afae03ae326689e
TRAIN_ROWS=20631;UNITS=100;CYCLE_RANGE=1..362
TEST_ROWS=13096;UNITS=100;CYCLE_RANGE=1..303
RUL_ROWS=100;COLUMNS=1;TEST_UNITS=100;TEST_UNIT_ORDER_ASCENDING=True;RUL_ALIGNMENT=ORDER_BASED_MAPPING
TREND_SAMPLES=18;UNITS_PER_SPLIT=1,50,100;SENSORS=1,3,9;RAW_SOURCE_REFERENCES=2679/2679
CONTRACT_JSON_VALID=True;CONTRACT_VERSION=1.0.0-DRAFT;TESTS=16/16_PASS
SOURCE_HASHES_UNCHANGED=True
INPUT_SHA256_AFTER[train_FD001.txt]=963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8
INPUT_SHA256_AFTER[test_FD001.txt]=3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851
INPUT_SHA256_AFTER[RUL_FD001.txt]=A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA
SCRIPT_SHA256=EC68D890B90BE7EFC5D7E79D1D396A5BB5184F93A663938CE97179366E31C5AA
CONTRACT_STATIC_CHECKS=9/9_PASS
CONTRACT_CHECK[dataset_and_version]=PASS
CONTRACT_CHECK[canonical_columns]=PASS
CONTRACT_CHECK[sensor_mapping]=PASS
CONTRACT_CHECK[split_definitions]=PASS
CONTRACT_CHECK[query_fields]=PASS
CONTRACT_CHECK[error_codes]=PASS
CONTRACT_CHECK[rul_policy]=PASS
CONTRACT_CHECK[empty_result_semantics]=PASS
CONTRACT_CHECK[serialization_policy]=PASS
T01_T16=16/16_PASS
RUL_HASH_ENTRY_COUNT=1
EVIDENCE_HISTORY_PRESERVED=True
MODE=VERIFY_ONLY_NO_FILES_WRITTEN
OUTPUT_WRITE=SKIPPED
EXIT_CODE=0
CHILD_EXIT_CODE=0
PARENT_EXIT_CODE=0
```

Git Stage/Commit/Push were not run. M2 acceptance remains pending and M3 remains locked.

### Final VerifyOnly pass after report-generation assertions

Command: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\M2_STAGE_B_ANALYZE.ps1 -VerifyOnly`
Execution timestamp was not printed by the parent command wrapper. Child Exit Code: 0; parent Exit Code: 0; stderr empty.

Actual stdout:
```text
M2_STAGE_B_STATUS=SUCCESS
GOVERNANCE_MAIN_SHA=972d4abf146b9fb5000b31253afae03ae326689e
TRAIN_ROWS=20631;UNITS=100;CYCLE_RANGE=1..362
TEST_ROWS=13096;UNITS=100;CYCLE_RANGE=1..303
RUL_ROWS=100;COLUMNS=1;TEST_UNITS=100;TEST_UNIT_ORDER_ASCENDING=True;RUL_ALIGNMENT=ORDER_BASED_MAPPING
TREND_SAMPLES=18;UNITS_PER_SPLIT=1,50,100;SENSORS=1,3,9;RAW_SOURCE_REFERENCES=2679/2679
CONTRACT_JSON_VALID=True;CONTRACT_VERSION=1.0.0-DRAFT;TESTS=16/16_PASS
SOURCE_HASHES_UNCHANGED=True
INPUT_SHA256_AFTER[train_FD001.txt]=963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8
INPUT_SHA256_AFTER[test_FD001.txt]=3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851
INPUT_SHA256_AFTER[RUL_FD001.txt]=A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA
SCRIPT_SHA256=46B1A5EA5B339A68B70E59B32806270AD5DAF0DBCDBCA9A24AE73834E1631995
CONTRACT_STATIC_CHECKS=9/9_PASS
CONTRACT_CHECK[dataset_and_version]=PASS
CONTRACT_CHECK[canonical_columns]=PASS
CONTRACT_CHECK[sensor_mapping]=PASS
CONTRACT_CHECK[split_definitions]=PASS
CONTRACT_CHECK[query_fields]=PASS
CONTRACT_CHECK[error_codes]=PASS
CONTRACT_CHECK[rul_policy]=PASS
CONTRACT_CHECK[empty_result_semantics]=PASS
CONTRACT_CHECK[serialization_policy]=PASS
T01_T16=16/16_PASS
RUL_HASH_ENTRY_COUNT=1
EVIDENCE_HISTORY_PRESERVED=True
MODE=VERIFY_ONLY_NO_FILES_WRITTEN
OUTPUT_WRITE=SKIPPED
EXIT_CODE=0
CHILD_EXIT_CODE=0
GENERATED_REPORT_ASSERTIONS=PASS;T01_T16_ROWS=16;CONSISTENCY_ROWS=9;EVIDENCE_FENCES=12
PARENT_EXIT_CODE=0
```

This pass used the final corrected generator hash listed above. No Stage B reports were regenerated by VerifyOnly.