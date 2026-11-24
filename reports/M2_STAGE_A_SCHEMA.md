# M2 Stage A Train/Test Schema Validation

Expected mapping (1-based): columns 1-2 are unit and cycle, columns 3-5 are operating settings, and columns 6-26 are sensor_1 through sensor_21. These are expected definitions; observed counts and validity below are measured.

| Position | Expected name | Train numeric count | Test numeric count |
|---:|---|---:|---:|
| 1 | unit_id | 20631 | 13096 |
| 2 | cycle | 20631 | 13096 |
| 3 | op_setting_1 | 20631 | 13096 |
| 4 | op_setting_2 | 20631 | 13096 |
| 5 | op_setting_3 | 20631 | 13096 |
| 6 | sensor_1 | 20631 | 13096 |
| 7 | sensor_2 | 20631 | 13096 |
| 8 | sensor_3 | 20631 | 13096 |
| 9 | sensor_4 | 20631 | 13096 |
| 10 | sensor_5 | 20631 | 13096 |
| 11 | sensor_6 | 20631 | 13096 |
| 12 | sensor_7 | 20631 | 13096 |
| 13 | sensor_8 | 20631 | 13096 |
| 14 | sensor_9 | 20631 | 13096 |
| 15 | sensor_10 | 20631 | 13096 |
| 16 | sensor_11 | 20631 | 13096 |
| 17 | sensor_12 | 20631 | 13096 |
| 18 | sensor_13 | 20631 | 13096 |
| 19 | sensor_14 | 20631 | 13096 |
| 20 | sensor_15 | 20631 | 13096 |
| 21 | sensor_16 | 20631 | 13096 |
| 22 | sensor_17 | 20631 | 13096 |
| 23 | sensor_18 | 20631 | 13096 |
| 24 | sensor_19 | 20631 | 13096 |
| 25 | sensor_20 | 20631 | 13096 |
| 26 | sensor_21 | 20631 | 13096 |

- Train: actual columns parsed per valid record = 26; nonblank records=20631; valid parsed records=20631; malformed records=0.
- Test: actual columns parsed per valid record = 26; nonblank records=13096; valid parsed records=13096; malformed records=0.
- Delimiter: whitespace split after trimming; repeated spaces/tabs do not create empty fields; trailing whitespace does not create imaginary fields.
- Numeric validation: invariant-culture `Double.TryParse`; NaN and positive/negative infinity rejected. `unit_id` and `cycle` additionally require finite Int32 integer semantics.
- RUL: one field per valid record; parsed numeric values=100; invalid records=0; negative values=0.

Malformed records are listed with physical line and reason in the File Manifest; they are not silently discarded.