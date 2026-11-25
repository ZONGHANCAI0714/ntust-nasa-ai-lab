# M2 FD001 Contract Verification T01-T16

All tests executed against in-memory query validation built from the hash-verified local files. T07/T08 also reread an actual source line. T15 uses only an in-memory simulated expected hash; no source file was changed.

| Test | Input | Expected result | Actual result | Pass/Fail | Evidence reference |
|---|---|---|---|---|---|
| T01 | TRAIN unit 1 | valid unit response | valid observation | PASS | TRAIN unit catalog and observation index |
| T02 | TEST unit 1 | valid unit response | valid observation | PASS | TEST unit catalog and observation index |
| T03 | sensor_3 | sensor catalog member | catalog member | PASS | Data dictionary sensor catalog |
| T04 | TRAIN unit 1 cycle 2 sensor_3 | observed numeric value | observed numeric value | PASS | TRAIN physical source row for Unit 1 Cycle 2 |
| T05 | TEST unit 50 sensor_3 cycles 1..303 | ascending cycle order | ascending | PASS | Actual trend query result |
| T06 | Unit 1 Cycle 1 sensor_3 in both splits | split-specific responses | TRAIN and TEST independently returned | PASS | Two split-qualified source references |
| T07 | TRAIN line 1 | source line parses to indexed Unit/Cycle | source line verified | PASS | train_FD001.txt physical line 1, parsed index 1 |
| T08 | TRAIN line 1 source column 8 vs sensor_3 response | exact parsed value and JSON round-trip equality | exact source/query/JSON match | PASS | TRAIN source line 1; sensor_3 maps to source column 8; JSON ConvertTo-Json/ConvertFrom-Json round trip |
| T09 | TRAIN unit 1 cycle 1 | derived RUL = max cycle - cycle | value=191;derived=True | PASS | TRAIN unit 1 observed last cycle and cycle 1 |
| T10 | TEST unit 1 final observed cycle 31 | source RUL row 1 under order mapping | source_row=1;value_match=True | PASS | TEST unit encounter order and RUL_FD001.txt physical/source row 1 |
| T11 | TRAIN unit 99999 | INVALID_UNIT | INVALID_UNIT | PASS | Actual observation query validator |
| T12 | TRAIN unit 1 sensor_22 | INVALID_SENSOR | INVALID_SENSOR | PASS | Actual observation query validator |
| T13 | TRAIN unit 1 cycle 363 | INVALID_CYCLE | INVALID_CYCLE | PASS | Actual observation query validator |
| T14 | VALIDATION unit 1 cycle 1 sensor_3 | INVALID_SPLIT | INVALID_SPLIT | PASS | Actual observation query validator |
| T15 | Simulated expected hash of 64 zeroes for unchanged Train file | SOURCE_HASH_MISMATCH; actual file untouched | SOURCE_HASH_MISMATCH | PASS | In-memory expected-vs-actual SHA comparison; no source file modification |
| T16 | TEST unit 1, valid inclusive cycles 50..55 | successful empty trend; unit has no records in interval | count=0 | PASS | Unit 1 last observed cycle is below 50; requested bounds are within TEST split domain |

Error policy is exercised through the same query functions used for valid observations and trends; results are not filled from expected values alone.
## Bounded cross-artifact consistency verification (post-review)

Command: PowerShell 5.1 inline assertions using `ConvertFrom-Json`, regular-expression parsing of dictionary rows, and exact Markdown field/error-row membership checks over the JSON contract, this Markdown contract, and the data dictionary. No source data was read for this static cross-artifact check.

| Check | Actual result |
|---|---|
| Dataset ID and contract version | PASS - NASA_CMAPSS_FD001; 1.0.0-DRAFT |
| Canonical columns | PASS - 26 ordered source columns and all 26 dictionary rows matched |
| Sensor identifiers and mapping | PASS - sensor_1..sensor_21 mapped to source columns 6..26 in JSON and dictionary |
| TRAIN/TEST split definitions | PASS - both split manifest entries and documented split definitions matched |
| Observation/trend fields | PASS - observation request/response and trend request/response fields matched field-by-field |
| Error codes | PASS - 9 JSON error codes each matched a Markdown row |
| RUL source/derived policies | PASS - Train formula/derived flag and Test one-column order mapping, direct-ID limitation, and trusted-order dependency matched |
| Empty-result semantics | PASS - valid empty trend success, empty arrays, count 0, and distinction from invalid/missing requests matched |
| Serialization policy | PASS - round-trip precision, negative-zero normalization, null-versus-zero, and cycle ordering matched |

Actual corrected consistency-check command exit code: 0 (9 checks). An earlier checker invocation exited 1 because its expected Markdown field formatting omitted per-field backticks; corrected field-token comparison passed all checks. This was a checker matcher defect, not a contract inconsistency.
## Generator-integrated reproducibility validation (B-REWORK-02)

Actual command: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\M2_STAGE_B_ANALYZE.ps1 -VerifyOnly`. The corrected generator built the report outputs in memory, executed the nine cross-artifact assertions and T01-T16, then exited before writing report files.

Actual results: `CONTRACT_STATIC_CHECKS=9/9_PASS`; `T01_T16=16/16_PASS`; `RUL_HASH_ENTRY_COUNT=1`; `EVIDENCE_HISTORY_PRESERVED=True`; `MODE=VERIFY_ONLY_NO_FILES_WRITTEN`; child and parent Exit Code 0. Full stdout and source hashes are recorded in `M2_STAGE_B_EVIDENCE.md`.

The prior T01-T16 results and checker failure history above are retained. The generator now creates this consistency section from executed assertion results; it does not insert hardcoded PASS entries.

Final generated-output assertion from VerifyOnly: GENERATED_REPORT_ASSERTIONS=PASS;T01_T16_ROWS=16;CONSISTENCY_ROWS=9;EVIDENCE_FENCES=12; Exit Code 0.