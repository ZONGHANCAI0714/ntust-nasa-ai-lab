# M2 Stage B Train/Test Data Quality

Classifications: ERROR blocks a valid contract response; WARNING identifies an observed concern; EXPECTED_CHARACTERISTIC is documented behavior. Whitespace format cannot locate an omitted token within a short row, so missing slots are not assigned to a guessed column.

| Split | Rows | Columns | Unique units | Cycle range | Blank lines | Malformed | Parse errors | Non-finite | Missing-slot deficit | Duplicate Unit-Cycle | Full-row duplicates | Cycle gaps | Cycle order errors |
|---|---:|---:|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| TRAIN | 20631 | 26 | 100 | 1..362 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| TEST | 13096 | 26 | 100 | 1..303 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

## Per-unit cycle coverage

| Split | Unit | First cycle | Last cycle | Observations | Missing cycle count | Continuous from first to last | Starts at 1 |
|---|---:|---:|---:|---:|---:|---|---|
| TRAIN | 1 | 1 | 192 | 192 | 0 | True | True |
| TRAIN | 2 | 1 | 287 | 287 | 0 | True | True |
| TRAIN | 3 | 1 | 179 | 179 | 0 | True | True |
| TRAIN | 4 | 1 | 189 | 189 | 0 | True | True |
| TRAIN | 5 | 1 | 269 | 269 | 0 | True | True |
| TRAIN | 6 | 1 | 188 | 188 | 0 | True | True |
| TRAIN | 7 | 1 | 259 | 259 | 0 | True | True |
| TRAIN | 8 | 1 | 150 | 150 | 0 | True | True |
| TRAIN | 9 | 1 | 201 | 201 | 0 | True | True |
| TRAIN | 10 | 1 | 222 | 222 | 0 | True | True |
| TRAIN | 11 | 1 | 240 | 240 | 0 | True | True |
| TRAIN | 12 | 1 | 170 | 170 | 0 | True | True |
| TRAIN | 13 | 1 | 163 | 163 | 0 | True | True |
| TRAIN | 14 | 1 | 180 | 180 | 0 | True | True |
| TRAIN | 15 | 1 | 207 | 207 | 0 | True | True |
| TRAIN | 16 | 1 | 209 | 209 | 0 | True | True |
| TRAIN | 17 | 1 | 276 | 276 | 0 | True | True |
| TRAIN | 18 | 1 | 195 | 195 | 0 | True | True |
| TRAIN | 19 | 1 | 158 | 158 | 0 | True | True |
| TRAIN | 20 | 1 | 234 | 234 | 0 | True | True |
| TRAIN | 21 | 1 | 195 | 195 | 0 | True | True |
| TRAIN | 22 | 1 | 202 | 202 | 0 | True | True |
| TRAIN | 23 | 1 | 168 | 168 | 0 | True | True |
| TRAIN | 24 | 1 | 147 | 147 | 0 | True | True |
| TRAIN | 25 | 1 | 230 | 230 | 0 | True | True |
| TRAIN | 26 | 1 | 199 | 199 | 0 | True | True |
| TRAIN | 27 | 1 | 156 | 156 | 0 | True | True |
| TRAIN | 28 | 1 | 165 | 165 | 0 | True | True |
| TRAIN | 29 | 1 | 163 | 163 | 0 | True | True |
| TRAIN | 30 | 1 | 194 | 194 | 0 | True | True |
| TRAIN | 31 | 1 | 234 | 234 | 0 | True | True |
| TRAIN | 32 | 1 | 191 | 191 | 0 | True | True |
| TRAIN | 33 | 1 | 200 | 200 | 0 | True | True |
| TRAIN | 34 | 1 | 195 | 195 | 0 | True | True |
| TRAIN | 35 | 1 | 181 | 181 | 0 | True | True |
| TRAIN | 36 | 1 | 158 | 158 | 0 | True | True |
| TRAIN | 37 | 1 | 170 | 170 | 0 | True | True |
| TRAIN | 38 | 1 | 194 | 194 | 0 | True | True |
| TRAIN | 39 | 1 | 128 | 128 | 0 | True | True |
| TRAIN | 40 | 1 | 188 | 188 | 0 | True | True |
| TRAIN | 41 | 1 | 216 | 216 | 0 | True | True |
| TRAIN | 42 | 1 | 196 | 196 | 0 | True | True |
| TRAIN | 43 | 1 | 207 | 207 | 0 | True | True |
| TRAIN | 44 | 1 | 192 | 192 | 0 | True | True |
| TRAIN | 45 | 1 | 158 | 158 | 0 | True | True |
| TRAIN | 46 | 1 | 256 | 256 | 0 | True | True |
| TRAIN | 47 | 1 | 214 | 214 | 0 | True | True |
| TRAIN | 48 | 1 | 231 | 231 | 0 | True | True |
| TRAIN | 49 | 1 | 215 | 215 | 0 | True | True |
| TRAIN | 50 | 1 | 198 | 198 | 0 | True | True |
| TRAIN | 51 | 1 | 213 | 213 | 0 | True | True |
| TRAIN | 52 | 1 | 213 | 213 | 0 | True | True |
| TRAIN | 53 | 1 | 195 | 195 | 0 | True | True |
| TRAIN | 54 | 1 | 257 | 257 | 0 | True | True |
| TRAIN | 55 | 1 | 193 | 193 | 0 | True | True |
| TRAIN | 56 | 1 | 275 | 275 | 0 | True | True |
| TRAIN | 57 | 1 | 137 | 137 | 0 | True | True |
| TRAIN | 58 | 1 | 147 | 147 | 0 | True | True |
| TRAIN | 59 | 1 | 231 | 231 | 0 | True | True |
| TRAIN | 60 | 1 | 172 | 172 | 0 | True | True |
| TRAIN | 61 | 1 | 185 | 185 | 0 | True | True |
| TRAIN | 62 | 1 | 180 | 180 | 0 | True | True |
| TRAIN | 63 | 1 | 174 | 174 | 0 | True | True |
| TRAIN | 64 | 1 | 283 | 283 | 0 | True | True |
| TRAIN | 65 | 1 | 153 | 153 | 0 | True | True |
| TRAIN | 66 | 1 | 202 | 202 | 0 | True | True |
| TRAIN | 67 | 1 | 313 | 313 | 0 | True | True |
| TRAIN | 68 | 1 | 199 | 199 | 0 | True | True |
| TRAIN | 69 | 1 | 362 | 362 | 0 | True | True |
| TRAIN | 70 | 1 | 137 | 137 | 0 | True | True |
| TRAIN | 71 | 1 | 208 | 208 | 0 | True | True |
| TRAIN | 72 | 1 | 213 | 213 | 0 | True | True |
| TRAIN | 73 | 1 | 213 | 213 | 0 | True | True |
| TRAIN | 74 | 1 | 166 | 166 | 0 | True | True |
| TRAIN | 75 | 1 | 229 | 229 | 0 | True | True |
| TRAIN | 76 | 1 | 210 | 210 | 0 | True | True |
| TRAIN | 77 | 1 | 154 | 154 | 0 | True | True |
| TRAIN | 78 | 1 | 231 | 231 | 0 | True | True |
| TRAIN | 79 | 1 | 199 | 199 | 0 | True | True |
| TRAIN | 80 | 1 | 185 | 185 | 0 | True | True |
| TRAIN | 81 | 1 | 240 | 240 | 0 | True | True |
| TRAIN | 82 | 1 | 214 | 214 | 0 | True | True |
| TRAIN | 83 | 1 | 293 | 293 | 0 | True | True |
| TRAIN | 84 | 1 | 267 | 267 | 0 | True | True |
| TRAIN | 85 | 1 | 188 | 188 | 0 | True | True |
| TRAIN | 86 | 1 | 278 | 278 | 0 | True | True |
| TRAIN | 87 | 1 | 178 | 178 | 0 | True | True |
| TRAIN | 88 | 1 | 213 | 213 | 0 | True | True |
| TRAIN | 89 | 1 | 217 | 217 | 0 | True | True |
| TRAIN | 90 | 1 | 154 | 154 | 0 | True | True |
| TRAIN | 91 | 1 | 135 | 135 | 0 | True | True |
| TRAIN | 92 | 1 | 341 | 341 | 0 | True | True |
| TRAIN | 93 | 1 | 155 | 155 | 0 | True | True |
| TRAIN | 94 | 1 | 258 | 258 | 0 | True | True |
| TRAIN | 95 | 1 | 283 | 283 | 0 | True | True |
| TRAIN | 96 | 1 | 336 | 336 | 0 | True | True |
| TRAIN | 97 | 1 | 202 | 202 | 0 | True | True |
| TRAIN | 98 | 1 | 156 | 156 | 0 | True | True |
| TRAIN | 99 | 1 | 185 | 185 | 0 | True | True |
| TRAIN | 100 | 1 | 200 | 200 | 0 | True | True |
| TEST | 1 | 1 | 31 | 31 | 0 | True | True |
| TEST | 2 | 1 | 49 | 49 | 0 | True | True |
| TEST | 3 | 1 | 126 | 126 | 0 | True | True |
| TEST | 4 | 1 | 106 | 106 | 0 | True | True |
| TEST | 5 | 1 | 98 | 98 | 0 | True | True |
| TEST | 6 | 1 | 105 | 105 | 0 | True | True |
| TEST | 7 | 1 | 160 | 160 | 0 | True | True |
| TEST | 8 | 1 | 166 | 166 | 0 | True | True |
| TEST | 9 | 1 | 55 | 55 | 0 | True | True |
| TEST | 10 | 1 | 192 | 192 | 0 | True | True |
| TEST | 11 | 1 | 83 | 83 | 0 | True | True |
| TEST | 12 | 1 | 217 | 217 | 0 | True | True |
| TEST | 13 | 1 | 195 | 195 | 0 | True | True |
| TEST | 14 | 1 | 46 | 46 | 0 | True | True |
| TEST | 15 | 1 | 76 | 76 | 0 | True | True |
| TEST | 16 | 1 | 113 | 113 | 0 | True | True |
| TEST | 17 | 1 | 165 | 165 | 0 | True | True |
| TEST | 18 | 1 | 133 | 133 | 0 | True | True |
| TEST | 19 | 1 | 135 | 135 | 0 | True | True |
| TEST | 20 | 1 | 184 | 184 | 0 | True | True |
| TEST | 21 | 1 | 148 | 148 | 0 | True | True |
| TEST | 22 | 1 | 39 | 39 | 0 | True | True |
| TEST | 23 | 1 | 130 | 130 | 0 | True | True |
| TEST | 24 | 1 | 186 | 186 | 0 | True | True |
| TEST | 25 | 1 | 48 | 48 | 0 | True | True |
| TEST | 26 | 1 | 76 | 76 | 0 | True | True |
| TEST | 27 | 1 | 140 | 140 | 0 | True | True |
| TEST | 28 | 1 | 158 | 158 | 0 | True | True |
| TEST | 29 | 1 | 171 | 171 | 0 | True | True |
| TEST | 30 | 1 | 143 | 143 | 0 | True | True |
| TEST | 31 | 1 | 196 | 196 | 0 | True | True |
| TEST | 32 | 1 | 145 | 145 | 0 | True | True |
| TEST | 33 | 1 | 50 | 50 | 0 | True | True |
| TEST | 34 | 1 | 203 | 203 | 0 | True | True |
| TEST | 35 | 1 | 198 | 198 | 0 | True | True |
| TEST | 36 | 1 | 126 | 126 | 0 | True | True |
| TEST | 37 | 1 | 121 | 121 | 0 | True | True |
| TEST | 38 | 1 | 125 | 125 | 0 | True | True |
| TEST | 39 | 1 | 37 | 37 | 0 | True | True |
| TEST | 40 | 1 | 133 | 133 | 0 | True | True |
| TEST | 41 | 1 | 123 | 123 | 0 | True | True |
| TEST | 42 | 1 | 156 | 156 | 0 | True | True |
| TEST | 43 | 1 | 172 | 172 | 0 | True | True |
| TEST | 44 | 1 | 54 | 54 | 0 | True | True |
| TEST | 45 | 1 | 152 | 152 | 0 | True | True |
| TEST | 46 | 1 | 146 | 146 | 0 | True | True |
| TEST | 47 | 1 | 73 | 73 | 0 | True | True |
| TEST | 48 | 1 | 78 | 78 | 0 | True | True |
| TEST | 49 | 1 | 303 | 303 | 0 | True | True |
| TEST | 50 | 1 | 74 | 74 | 0 | True | True |
| TEST | 51 | 1 | 144 | 144 | 0 | True | True |
| TEST | 52 | 1 | 189 | 189 | 0 | True | True |
| TEST | 53 | 1 | 164 | 164 | 0 | True | True |
| TEST | 54 | 1 | 121 | 121 | 0 | True | True |
| TEST | 55 | 1 | 113 | 113 | 0 | True | True |
| TEST | 56 | 1 | 136 | 136 | 0 | True | True |
| TEST | 57 | 1 | 160 | 160 | 0 | True | True |
| TEST | 58 | 1 | 176 | 176 | 0 | True | True |
| TEST | 59 | 1 | 94 | 94 | 0 | True | True |
| TEST | 60 | 1 | 147 | 147 | 0 | True | True |
| TEST | 61 | 1 | 159 | 159 | 0 | True | True |
| TEST | 62 | 1 | 232 | 232 | 0 | True | True |
| TEST | 63 | 1 | 155 | 155 | 0 | True | True |
| TEST | 64 | 1 | 168 | 168 | 0 | True | True |
| TEST | 65 | 1 | 71 | 71 | 0 | True | True |
| TEST | 66 | 1 | 147 | 147 | 0 | True | True |
| TEST | 67 | 1 | 71 | 71 | 0 | True | True |
| TEST | 68 | 1 | 187 | 187 | 0 | True | True |
| TEST | 69 | 1 | 54 | 54 | 0 | True | True |
| TEST | 70 | 1 | 152 | 152 | 0 | True | True |
| TEST | 71 | 1 | 68 | 68 | 0 | True | True |
| TEST | 72 | 1 | 131 | 131 | 0 | True | True |
| TEST | 73 | 1 | 112 | 112 | 0 | True | True |
| TEST | 74 | 1 | 137 | 137 | 0 | True | True |
| TEST | 75 | 1 | 88 | 88 | 0 | True | True |
| TEST | 76 | 1 | 205 | 205 | 0 | True | True |
| TEST | 77 | 1 | 162 | 162 | 0 | True | True |
| TEST | 78 | 1 | 72 | 72 | 0 | True | True |
| TEST | 79 | 1 | 101 | 101 | 0 | True | True |
| TEST | 80 | 1 | 133 | 133 | 0 | True | True |
| TEST | 81 | 1 | 213 | 213 | 0 | True | True |
| TEST | 82 | 1 | 162 | 162 | 0 | True | True |
| TEST | 83 | 1 | 73 | 73 | 0 | True | True |
| TEST | 84 | 1 | 172 | 172 | 0 | True | True |
| TEST | 85 | 1 | 34 | 34 | 0 | True | True |
| TEST | 86 | 1 | 110 | 110 | 0 | True | True |
| TEST | 87 | 1 | 56 | 56 | 0 | True | True |
| TEST | 88 | 1 | 68 | 68 | 0 | True | True |
| TEST | 89 | 1 | 177 | 177 | 0 | True | True |
| TEST | 90 | 1 | 146 | 146 | 0 | True | True |
| TEST | 91 | 1 | 234 | 234 | 0 | True | True |
| TEST | 92 | 1 | 150 | 150 | 0 | True | True |
| TEST | 93 | 1 | 244 | 244 | 0 | True | True |
| TEST | 94 | 1 | 133 | 133 | 0 | True | True |
| TEST | 95 | 1 | 89 | 89 | 0 | True | True |
| TEST | 96 | 1 | 97 | 97 | 0 | True | True |
| TEST | 97 | 1 | 134 | 134 | 0 | True | True |
| TEST | 98 | 1 | 121 | 121 | 0 | True | True |
| TEST | 99 | 1 | 97 | 97 | 0 | True | True |
| TEST | 100 | 1 | 198 | 198 | 0 | True | True |

## Missingness and parse policy

- Train/Test accepted rows have 26 fields and all parsed values are finite numbers; per-column missing count among valid records is 0.
- Empty or whitespace-only physical lines are counted as blank lines. Short whitespace rows contribute a minimum missing-slot deficit, but token positions cannot be inferred. Invalid numeric tokens and non-finite values are separate parse errors. No missing values are replaced with zero.

| Split | Source column | Valid numeric observations | Missing among valid rows |
|---|---|---:|---:|
| TRAIN | unit_id | 20631 | 0 |
| TRAIN | cycle | 20631 | 0 |
| TRAIN | op_setting_1 | 20631 | 0 |
| TRAIN | op_setting_2 | 20631 | 0 |
| TRAIN | op_setting_3 | 20631 | 0 |
| TRAIN | sensor_1 | 20631 | 0 |
| TRAIN | sensor_2 | 20631 | 0 |
| TRAIN | sensor_3 | 20631 | 0 |
| TRAIN | sensor_4 | 20631 | 0 |
| TRAIN | sensor_5 | 20631 | 0 |
| TRAIN | sensor_6 | 20631 | 0 |
| TRAIN | sensor_7 | 20631 | 0 |
| TRAIN | sensor_8 | 20631 | 0 |
| TRAIN | sensor_9 | 20631 | 0 |
| TRAIN | sensor_10 | 20631 | 0 |
| TRAIN | sensor_11 | 20631 | 0 |
| TRAIN | sensor_12 | 20631 | 0 |
| TRAIN | sensor_13 | 20631 | 0 |
| TRAIN | sensor_14 | 20631 | 0 |
| TRAIN | sensor_15 | 20631 | 0 |
| TRAIN | sensor_16 | 20631 | 0 |
| TRAIN | sensor_17 | 20631 | 0 |
| TRAIN | sensor_18 | 20631 | 0 |
| TRAIN | sensor_19 | 20631 | 0 |
| TRAIN | sensor_20 | 20631 | 0 |
| TRAIN | sensor_21 | 20631 | 0 |
| TEST | unit_id | 13096 | 0 |
| TEST | cycle | 13096 | 0 |
| TEST | op_setting_1 | 13096 | 0 |
| TEST | op_setting_2 | 13096 | 0 |
| TEST | op_setting_3 | 13096 | 0 |
| TEST | sensor_1 | 13096 | 0 |
| TEST | sensor_2 | 13096 | 0 |
| TEST | sensor_3 | 13096 | 0 |
| TEST | sensor_4 | 13096 | 0 |
| TEST | sensor_5 | 13096 | 0 |
| TEST | sensor_6 | 13096 | 0 |
| TEST | sensor_7 | 13096 | 0 |
| TEST | sensor_8 | 13096 | 0 |
| TEST | sensor_9 | 13096 | 0 |
| TEST | sensor_10 | 13096 | 0 |
| TEST | sensor_11 | 13096 | 0 |
| TEST | sensor_12 | 13096 | 0 |
| TEST | sensor_13 | 13096 | 0 |
| TEST | sensor_14 | 13096 | 0 |
| TEST | sensor_15 | 13096 | 0 |
| TEST | sensor_16 | 13096 | 0 |
| TEST | sensor_17 | 13096 | 0 |
| TEST | sensor_18 | 13096 | 0 |
| TEST | sensor_19 | 13096 | 0 |
| TEST | sensor_20 | 13096 | 0 |
| TEST | sensor_21 | 13096 | 0 |

## Sensor flags and settings

Low-variance rule: sample CV = sample SD / abs(mean), threshold CV < 0.01. If mean is zero or sample SD is undefined, CV is NA and the column is not flagged by this rule. Constant is separately min=max. These flags are descriptive only.

| Split | Constant sensor columns | Low-variance sensor columns |
|---|---|---|
| TRAIN | sensor_1,sensor_5,sensor_10,sensor_16,sensor_18,sensor_19 | sensor_1,sensor_2,sensor_3,sensor_4,sensor_5,sensor_6,sensor_7,sensor_8,sensor_9,sensor_10,sensor_11,sensor_12,sensor_13,sensor_14,sensor_15,sensor_16,sensor_17,sensor_18,sensor_19,sensor_20,sensor_21 |
| TEST | sensor_1,sensor_5,sensor_10,sensor_16,sensor_18,sensor_19 | sensor_1,sensor_2,sensor_3,sensor_4,sensor_5,sensor_6,sensor_7,sensor_8,sensor_9,sensor_10,sensor_11,sensor_12,sensor_13,sensor_14,sensor_15,sensor_16,sensor_17,sensor_18,sensor_19,sensor_20,sensor_21 |

| Split | Setting | Min | Max | Mean | Sample SD | Cycle-mean range | SD of cycle means |
|---|---|---:|---:|---:|---:|---:|---:|
| TRAIN | op_setting_1 | -0.0086999999999999994 | 0.0086999999999999994 | -8.8701468663661465E-06 | 0.002187313449015146 | -0.0030999999999999999..0.0040000000000000001 | 0.00069075032004394746 |
| TRAIN | op_setting_2 | -0.00059999999999999995 | 0.00059999999999999995 | 2.3508312733265476E-06 | 0.00029306212456614496 | -0.00035..0.00050000000000000001 | 0.00010218016051993254 |
| TRAIN | op_setting_3 | 100 | 100 | 100 | 0 | 100..100 | 0 |
| TEST | op_setting_1 | -0.0082000000000000007 | 0.0077999999999999996 | -1.117898594990837E-05 | 0.0022026850808076134 | -0.0054999999999999997..0.0044999999999999997 | 0.0011257218757052005 |
| TEST | op_setting_2 | -0.00059999999999999995 | 0.00069999999999999999 | 4.2379352474037876E-06 | 0.00029403056709582909 | -0.00050000000000000001..0.00050000000000000001 | 0.00013825716799007259 |
| TEST | op_setting_3 | 100 | 100 | 100 | 0 | 100..100 | 0 |

## Train/Test differences and classifications

- ERROR: no source hash, schema, numeric, duplicate Unit-Cycle, full-row duplicate, or cycle-order errors were observed in the verified inputs.
- EXPECTED_CHARACTERISTIC: Train contains full run-to-failure sequences; Test contains truncated observed sequences with separate source RUL rows. Train/Test records remain isolated by split key.
- WARNING: operating-setting physical units and sensor physical meanings/units are unverified; observed ranges are not treated as engineering limits.
- WARNING: constant and low-variance sensors are not evidence of sensor or engine failure.
- Per-unit cycle counts differ across units; exact first/last/count/gap coverage is listed above; no interpolation is applied.