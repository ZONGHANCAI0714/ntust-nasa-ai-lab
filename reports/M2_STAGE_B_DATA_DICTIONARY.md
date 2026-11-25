# M2 Stage B Data Dictionary

Train/Test source columns are whitespace-delimited and numeric. Unverified physical quantities and units are explicitly UNKNOWN. A source column number is one-based.

| Source column | Canonical field | Data type | Semantic meaning | Unit | Allowed query usage | Missing-value policy |
|---:|---|---|---|---|---|---|
| 1 | unit_id | integer | Engine unit identifier | not applicable | unit filter | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 2 | cycle | integer | Observed operating cycle | not applicable | cycle filter and ordering | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 3 | op_setting_1 | number | Operating setting 1 | UNKNOWN | observation context only | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 4 | op_setting_2 | number | Operating setting 2 | UNKNOWN | observation context only | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 5 | op_setting_3 | number | Operating setting 3 | UNKNOWN | observation context only | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 6 | sensor_1 | number | Sensor channel 1; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 7 | sensor_2 | number | Sensor channel 2; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 8 | sensor_3 | number | Sensor channel 3; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 9 | sensor_4 | number | Sensor channel 4; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 10 | sensor_5 | number | Sensor channel 5; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 11 | sensor_6 | number | Sensor channel 6; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 12 | sensor_7 | number | Sensor channel 7; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 13 | sensor_8 | number | Sensor channel 8; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 14 | sensor_9 | number | Sensor channel 9; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 15 | sensor_10 | number | Sensor channel 10; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 16 | sensor_11 | number | Sensor channel 11; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 17 | sensor_12 | number | Sensor channel 12; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 18 | sensor_13 | number | Sensor channel 13; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 19 | sensor_14 | number | Sensor channel 14; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 20 | sensor_15 | number | Sensor channel 15; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 21 | sensor_16 | number | Sensor channel 16; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 22 | sensor_17 | number | Sensor channel 17; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 23 | sensor_18 | number | Sensor channel 18; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 24 | sensor_19 | number | Sensor channel 19; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 25 | sensor_20 | number | Sensor channel 20; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |
| 26 | sensor_21 | number | Sensor channel 21; physical quantity is not verified. | UNKNOWN | sensor observation and trend query | No zero imputation; malformed short rows are rejected and missing position is unknown in whitespace format. |

## RUL fields

| Field | Source | Meaning | Unit | Availability | Derived flag | Alignment | Assumption/limitation |
|---|---|---|---|---|---|---|---|
| SOURCE_TEST_RUL | RUL_FD001.txt; one numeric source row per test unit | Source RUL associated with final observed Test cycle | UNKNOWN | Final observed cycle only | false | ORDER_BASED_MAPPING | File has no Unit ID; depends on TRUSTED_FD001_STANDARD_ROW_ORDER. |
| DERIVED_TRAIN_RUL | Derived from Train max cycle | max_cycle_for_unit - current_cycle | UNKNOWN | Observed Train cycle | true | Per-unit maximum cycle | Not interchangeable with source Test RUL. |

Missing policy: source missing values are never converted to zero. No matching query observation is an error; an invalid field is a request/schema error; null in a future response means absent, not zero.