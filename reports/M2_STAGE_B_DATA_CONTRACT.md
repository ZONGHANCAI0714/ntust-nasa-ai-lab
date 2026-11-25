# M2 FD001 Data Contract 1.0.0-DRAFT

Dataset ID: `NASA_CMAPSS_FD001`. This is a local data contract for future Engineering integration; it does not implement an HTTP API or website. The JSON artifact is the machine-readable source of exact field names and constraints.

## Source manifest

| File | SHA256 | Records | Columns | Split |
|---|---|---:|---:|---|
| train_FD001.txt | 963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8 | 20631 | 26 | TRAIN |
| test_FD001.txt | 3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851 | 13096 | 26 | TEST |
| RUL_FD001.txt | A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA | 100 | 1 | TEST_RUL |

## Contract structures

- source_manifest: `source_filename`, `source_sha256`, `record_count`, `column_count`, `dataset_split`
- engine_unit: `dataset_split`, `unit_id`, `available_cycles`, `first_cycle`, `last_cycle`
- sensor_catalog: `sensor_id`, `canonical_name`, `source_column`, `data_type`, `unit`
- observation_request: `dataset_split`, `unit_id`, `cycle`, `sensor_id`
- observation_response: `dataset_split`, `unit_id`, `cycle`, `sensor_id`, `sensor_value`, `source_reference`, `quality_flags`
- trend_request: `dataset_split`, `unit_id`, `sensor_id`, `cycle_start`, `cycle_end`
- trend_response: `dataset_split`, `unit_id`, `sensor_id`, `ordered_cycles`, `sensor_values`, `observation_count`, `source_references`, `quality_flags`
- rul_response: `dataset_split`, `unit_id`, `rul_value`, `rul_source_row`, `source_file_sha256`, `derived_flag`, `alignment_method`, `semantic_limitations`
- source_reference: `source_filename`, `source_sha256`, `physical_line_number`, `parsed_record_index`
- error_response: `error_code`, `message`, `request_context`

## Query rules

- Split values are TRAIN and TEST; valid Unit IDs are the verified actual membership for the selected split. Sensor IDs are sensor_1 through sensor_21.
- Observation key: `(dataset_split, unit_id, cycle, sensor_id)`. Trend key: `(dataset_split, unit_id, sensor_id, cycle_start, cycle_end)`; bounds are inclusive.
- Only observed cycles return observations. Trend cycles sort ascending; missing cycles are not interpolated. A valid unit and valid interval with no matching rows returns a successful empty trend (empty arrays and observation_count 0).
- Invalid split/unit/cycle/sensor return the corresponding error code. A valid observation key without a row returns OBSERVATION_NOT_FOUND.
- Train and Test remain separate, even when numeric Unit IDs overlap.

## RUL rules

- Train RUL is DERIVED_TRAIN_RUL = `max_cycle_for_unit - current_cycle`; `derived_flag=true`.
- Test RUL comes from RUL_FD001.txt, uses ORDER_BASED_MAPPING, `derived_flag=false`, and returns source row and source SHA only at the final observed cycle.
- The RUL file has no Unit ID. Identity is not directly verified; semantics depend on TRUSTED_FD001_STANDARD_ROW_ORDER. Early-cycle Test requests return RUL_ALIGNMENT_UNAVAILABLE; no early-cycle formula is silently applied.

## Serialization

- JSON numbers preserve parsed source precision; display summaries use round-trip G17. Same-runtime source checks use exact parsed Double equality.
- Missing/null is never numeric zero; negative zero serializes as zero. Empty trends use empty arrays and count 0. Source line and record indexes are positive integers.

## Errors

| Code | Trigger | Message semantics | Request context | Retry can change result? |
|---|---|---|---|---|
| FILE_NOT_FOUND | A required trusted source file is absent. | Return a non-success response with code FILE_NOT_FOUND and describe the trigger without substituting empty or zero-valued data. | Echo only the relevant split, unit, cycle/bounds, sensor, or source filename supplied or implicated by the request. | True |
| SOURCE_HASH_MISMATCH | Actual source SHA256 differs from the accepted hash. | Return a non-success response with code SOURCE_HASH_MISMATCH and describe the trigger without substituting empty or zero-valued data. | Echo only the relevant split, unit, cycle/bounds, sensor, or source filename supplied or implicated by the request. | False |
| INVALID_SPLIT | dataset_split is not TRAIN or TEST. | Return a non-success response with code INVALID_SPLIT and describe the trigger without substituting empty or zero-valued data. | Echo only the relevant split, unit, cycle/bounds, sensor, or source filename supplied or implicated by the request. | False |
| INVALID_UNIT | Unit ID is not a member of the requested split. | Return a non-success response with code INVALID_UNIT and describe the trigger without substituting empty or zero-valued data. | Echo only the relevant split, unit, cycle/bounds, sensor, or source filename supplied or implicated by the request. | False |
| INVALID_CYCLE | Cycle/bounds are not positive integers, reversed, or outside the split-wide cycle domain. | Return a non-success response with code INVALID_CYCLE and describe the trigger without substituting empty or zero-valued data. | Echo only the relevant split, unit, cycle/bounds, sensor, or source filename supplied or implicated by the request. | False |
| INVALID_SENSOR | Sensor ID is not sensor_1 through sensor_21. | Return a non-success response with code INVALID_SENSOR and describe the trigger without substituting empty or zero-valued data. | Echo only the relevant split, unit, cycle/bounds, sensor, or source filename supplied or implicated by the request. | False |
| OBSERVATION_NOT_FOUND | Request is valid but no matching observation exists. | Return a non-success response with code OBSERVATION_NOT_FOUND and describe the trigger without substituting empty or zero-valued data. | Echo only the relevant split, unit, cycle/bounds, sensor, or source filename supplied or implicated by the request. | True |
| SCHEMA_MISMATCH | Source rows violate the verified column or numeric schema. | Return a non-success response with code SCHEMA_MISMATCH and describe the trigger without substituting empty or zero-valued data. | Echo only the relevant split, unit, cycle/bounds, sensor, or source filename supplied or implicated by the request. | True |
| RUL_ALIGNMENT_UNAVAILABLE | Test source RUL was requested for a non-final observed cycle or cannot be mapped. | Return a non-success response with code RUL_ALIGNMENT_UNAVAILABLE and describe the trigger without substituting empty or zero-valued data. | Echo only the relevant split, unit, cycle/bounds, sensor, or source filename supplied or implicated by the request. | False |

## Version and evidence

- Contract version: `1.0.0-DRAFT`.
- Machine-readable file: `contracts/M2_FD001_DATA_CONTRACT_1.0.0-DRAFT.json`.
- Contract tests T01-T16 and their actual outcomes are recorded in `reports/M2_STAGE_B_CONTRACT_TESTS.md`.
- This contract records query semantics only; no API endpoint, model, or website is implemented.