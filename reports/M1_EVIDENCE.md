# M1 Execution Evidence

## Governance and delivery state

- Current GitHub `main` SHA checked via the GitHub API: `f7d75186ff4ba688c553ee501c95b3afa624670c`.
- `AGENTS.md` was read at that commit. Its governance content matches the project governance rules.
- M0 is recorded as PASS in the remote `WORK_ITEM.md` / `DECISIONS.md` history. Phase A acceptance and B1 file-preparation authorization are supplied by directives `MAIN-RB-011` and `MAIN-RB-012`.
- The local branch is `main`, local HEAD is the same SHA, and `git status --short --branch` reported no ahead/behind divergence. Existing untracked files are listed below; they were not read, staged, or modified.
- The local Git executable's `ls-remote` request failed with exit 128 because the Codex PowerShell environment could not connect to github.com:443. Remote state was independently verified through the connected GitHub API and exact-commit file reads. No remote SHA was inferred from local HEAD.
- B1 only: no Git add, commit, or push was executed. B2 remains on hold for Research Brain review and release.

## Phase A input and execution

- Input: `synthetic_sensor.csv`
- File size: 234 bytes
- Encoding: `UTF-8-VALID`, decoded with strict UTF-8 and no BOM
- SHA-256 before: `CD536B46EB628909FDC986BBAD956C24A2E50AFB287968998374BEFC62204377`
- SHA-256 after: `CD536B46EB628909FDC986BBAD956C24A2E50AFB287968998374BEFC62204377`
- Read status: success; six data rows and four columns
- Runtime: Windows PowerShell 5.1.26100.9818
- Execution timestamp: `2026-11-23T20:35:41.8192669+08:00`
- Exit code: 0
- Stderr: no stderr output observed
- Full original command: `NOT_AVAILABLE` as a standalone persisted command artifact. Reproduction reference: the in-memory PowerShell analysis issued under `MAIN-RB-011`; no `.ps1` file was created.

### REDACTED_COPY_OF_ACTUAL_OUTPUT

The following is a redacted copy of actual Phase A stdout. Only the identifying absolute input path was replaced with `synthetic_sensor.csv`; numeric results, SHA256 values, timestamps, and methods are preserved.

```text
=== M1 PHASE A DATASET PROFILE ===
TIMESTAMP=2026-11-23T20:35:41.8192669+08:00
POWERSHELL_VERSION=5.1.26100.9818
INPUT_FILE=synthetic_sensor.csv
FILE_SIZE_BYTES=234
SHA256_BEFORE=CD536B46EB628909FDC986BBAD956C24A2E50AFB287968998374BEFC62204377
ENCODING=UTF-8-VALID
READ_STATUS=SUCCESS
ACTUAL_ROWS=6
ACTUAL_COLUMNS=4
COLUMN_NAMES=timestamp, load_pct, coolant_out_c, oil_pressure_bar
DUPLICATE_COUNT=1
DUPLICATE_METHOD=ALL_FIELDS_EXACT_STRING_MATCH
DUPLICATE_LOCATION=DataRow=6, FirstOccurrence=5
COLUMN=timestamp
  TYPE=String
  MISSING_COUNT=0
  NON_MISSING_COUNT=6
COLUMN=load_pct
  TYPE=Numeric
  MISSING_COUNT=0
  NON_MISSING_COUNT=6
  COUNT=6
  MIN=50
  MAX=70
  MEAN=63.3333333333333
  STD_SAMPLE=10.3279555898864
COLUMN=coolant_out_c
  TYPE=Numeric
  MISSING_COUNT=0
  NON_MISSING_COUNT=6
  COUNT=6
  MIN=78
  MAX=84
  MEAN=81.6666666666667
  STD_SAMPLE=2.58198889747161
COLUMN=oil_pressure_bar
  TYPE=Numeric
  MISSING_COUNT=1
  NON_MISSING_COUNT=5
  COUNT=5
  MIN=3.8
  MAX=4
  MEAN=3.9
  STD_SAMPLE=0.1
TOTAL_MISSING=1
MISSING_METHOD=NULL_EMPTY_OR_WHITESPACE
STANDARD_DEVIATION=SAMPLE_N_MINUS_1
SHA256_AFTER=CD536B46EB628909FDC986BBAD956C24A2E50AFB287968998374BEFC62204377
RAW_DATA_UNCHANGED=TRUE
ANALYSIS_STATUS=SUCCESS
```

## B1 governance and local Git command evidence

Commands were run from `<LOCAL_PROJECT_ROOT>` on `2026-11-23T21:16:07+08:00`.

| Command | Result | Exit |
|---|---|---:|
| `git -C <repo> rev-parse --show-toplevel` | `<LOCAL_PROJECT_ROOT>` | 0 |
| `git -C <repo> branch --show-current` | `main` | 0 |
| `git -C <repo> status --short --branch` | `## main...origin/main`; untracked entries shown below | 0 |
| `git -C <repo> rev-parse HEAD` | `f7d75186ff4ba688c553ee501c95b3afa624670c` | 0 |
| `git ls-remote origin refs/heads/main` | Could not connect to github.com:443 | 128 |

Remote `main` and its governance files were read through GitHub at the same SHA. Local untracked entries at inspection time:

```text
?? "Damage Propagation Modeling.pdf"
?? RUL_FD001.txt
?? synthetic_sensor.csv
?? test_FD001.txt
?? train_FD001.txt
```

These entries were not opened except the specifically authorized synthetic CSV during Phase A. None were staged or altered. No branch divergence was reported.

After creating the three authorized reports, `git status --short` returned exit 0 and showed those existing untracked entries plus `?? reports/`. `git diff --check` returned exit 0 with empty output. Since Git diff-check does not include untracked files, the three new Markdown files were also read back and checked directly: each has a final newline and zero trailing-whitespace matches. No unauthorized file was modified or staged.

## Reproduction and limitations

Refer to directive `MAIN-RB-011` for the PowerShell parser and calculation logic. It uses strict UTF-8 decoding, comma-delimited parsing with quoted-field support, treats the first parsed record as the header, validates record widths, counts exact full-row string duplicates, counts empty/whitespace missing values, and calculates numeric summaries using invariant-culture parsing and sample standard deviation (`n - 1`).

The exact command text is not stored as a separate artifact, and no source script was created. Evidence is the actual captured output above. Timestamp semantics were not validated. The analysis does not represent FD001, ML, or RUL results.
