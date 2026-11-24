# M2 Stage A Worker Return

```yaml
TYPE: RESEARCH_WORKER_RETURN
DIRECTIVE_ID: MAIN-RB-M2-001
WORK_ITEM_ID: M2-RB-001

FROM: RESEARCH_OWN_WORKER
RETURN_TO: STUDENT-RESEARCH

EXECUTION_PHASE: STAGE_A_RAW_DATA_VALIDATION
EXECUTION_STATUS: SUCCESS
GOVERNANCE_MAIN_SHA: 23569699136676306c5a1692462daa4913fadd3b
INPUT_FILES:
  train_FD001.txt: <LOCAL_PROJECT_ROOT>\train_FD001.txt
  test_FD001.txt: <LOCAL_PROJECT_ROOT>\test_FD001.txt
  RUL_FD001.txt: <LOCAL_PROJECT_ROOT>\RUL_FD001.txt
INPUT_SIZES:
  train_FD001.txt: 3515356
  test_FD001.txt: 2228855
  RUL_FD001.txt: 429
INPUT_SHA256_BEFORE:
  train_FD001.txt: 963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8
  test_FD001.txt: 3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851
  RUL_FD001.txt: A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA
INPUT_SHA256_AFTER:
  train_FD001.txt: 963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8
  test_FD001.txt: 3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851
  RUL_FD001.txt: A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA
INPUT_HASHES_UNCHANGED: True
TRAIN_ROWS: 20631
TRAIN_COLUMNS: 26
TRAIN_UNITS: 100
TEST_ROWS: 13096
TEST_COLUMNS: 26
TEST_UNITS: 100
RUL_ROWS: 100
RUL_COLUMNS: 1
TRAIN_CYCLE_RANGE: 1..362
TEST_CYCLE_RANGE: 1..303
COLUMN_MAPPING: 1 unit_id; 2 cycle; 3-5 op_setting_1..3; 6-26 sensor_1..21; validated per parsed row.
UNIT_CYCLE_VALIDATION: TRAIN_DUPLICATES=0; TEST_DUPLICATES=0
RAW_INDEX: Full metadata index generated; no sensor/setting values exported.
RUL_ALIGNMENT: ASSUMED_UNVERIFIED_NO_RUL_UNIT_ID; rows=100; test_units=100
DATA_QUALITY: See M2_STAGE_A_QUALITY.md; no row removal or imputation.
OUTPUT_FILES:
  - tools/M2_STAGE_A_VALIDATE.ps1
  - reports/M2_STAGE_A_FILE_MANIFEST.md
  - reports/M2_STAGE_A_SCHEMA.md
  - reports/M2_STAGE_A_UNIT_CYCLE_INDEX.md
  - reports/M2_STAGE_A_SEMANTICS.md
  - reports/M2_STAGE_A_QUALITY.md
  - reports/M2_STAGE_A_EVIDENCE.md
  - reports/M2_STAGE_A_WORKER_RETURN.md
EXECUTION_COMMANDS: [Parser.ParseFile validation, powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\M2_STAGE_A_VALIDATE.ps1]
EXIT_CODES: [0, 0]
STDERR: EMPTY on corrected run
GIT_COMMIT_SHA: NOT_AVAILABLE
GITHUB_COMMIT_URL: NOT_AVAILABLE
REMOTE_VERIFICATION: NOT_PERFORMED_STAGE_A_ONLY
STOP_IF_TRIGGERED: NONE
STAGE_B_STATUS: NOT_AUTHORIZED
MAIN_STAGE_A_ACCEPTANCE: PENDING
M2_FINAL_ACCEPTANCE: PENDING
```

## MAIN-RB-M2-002 evidence rework addendum

Governance main SHA: `23569699136676306c5a1692462daa4913fadd3b` (GitHub connector; governance files read at that SHA; M1 PASS; M2 LOCKED). Direct `git ls-remote` failed to connect, Exit Code 128. No Git write was performed.

Script verification: `tools/M2_STAGE_A_VALIDATE.ps1` exists and its SHA-256 matches the value in the original execution evidence: `86D57EB8B09EE9A969B12DA6D0674B57BE2D768DC39F33802A20324B08100003`. The embedded script content matches after final-newline normalization. It was neither rerun nor modified.

| Split | Sample | Physical line / parsed index | Unit / cycle | Fields | Index comparison |
|---|---|---:|---:|---|---|
| TRAIN | First / Unit 1 Cycle 1 | 1 / 1 | 1 / 1 | 26 finite numeric | PASS |
| TRAIN | Unit 1 Cycle 2 | 2 / 2 | 1 / 2 | 26 finite numeric | PASS |
| TRAIN | Unit 2 Cycle 1 | 193 / 193 | 2 / 1 | 26 finite numeric | PASS |
| TRAIN | Last | 20631 / 20631 | 100 / 200 | 26 finite numeric | PASS |
| TEST | First / Unit 1 Cycle 1 | 1 / 1 | 1 / 1 | 26 finite numeric | PASS |
| TEST | Unit 1 Cycle 2 | 2 / 2 | 1 / 2 | 26 finite numeric | PASS |
| TEST | Unit 2 Cycle 1 | 32 / 32 | 2 / 1 | 26 finite numeric | PASS |
| TEST | Last | 13096 / 13096 | 100 / 198 | 26 finite numeric | PASS |

The Unit/Cycle pair in each source row matches the metadata index. The remaining 24 operating-setting and sensor fields were checked for finite numeric parsing; raw row values are not included here.

RUL alignment: one column and 100 finite records; 100 unique Test units in ascending order 1–100; existing order-based map matches source RUL rows 1–100 and the semantics table for 100/100 rows, with no duplicate or missing mapped rows. `RUL_UNIT_ID_DIRECT_VERIFICATION: NOT_POSSIBLE`; `SEMANTIC_DEPENDENCY: TRUSTED_FD001_STANDARD_ROW_ORDER`.

Input SHA-256 unchanged: Train `963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8`; Test `3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851`; RUL `A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA`.

Modified reports: `reports/M2_STAGE_A_EVIDENCE.md` (closed the actual-stdout fence and appended the rework audit); this file (appended this rework summary). No source data or script was modified. Eight final artifact SHA-256 values are returned to Research Brain in the accompanying message to avoid self-referential hashes.
