# M1 Dataset Profile

## Dataset identity

- Work item: `M1-RB-001`
- Phase A directive: `MAIN-RB-011`
- Dataset type: Synthetic
- Input: `synthetic_sensor.csv`
- File size: 234 bytes
- Encoding: Strict UTF-8 decode succeeded; no BOM (`UTF-8-VALID`)
- SHA-256: `CD536B46EB628909FDC986BBAD956C24A2E50AFB287968998374BEFC62204377`

## Parsing and row count

The CSV was parsed as comma-delimited data with quoted fields supported by `.NET` `Microsoft.VisualBasic.FileIO.TextFieldParser`. The first parsed record was treated as the header; no heuristic header detection was used. All six data records had the same four-field width as the header.

- Rows, excluding header: **6** (matches expected 6)
- Columns: **4**
- Header: `timestamp`, `load_pct`, `coolant_out_c`, `oil_pressure_bar`

## Column schema and missing values

Types were inferred from non-missing values: a column is Numeric when every non-missing value parses as a finite number using invariant culture; otherwise it is String, Mixed, or AllMissing according to the observed values.

| Column | Inferred type | Missing | Non-missing |
|---|---|---:|---:|
| `timestamp` | String | 0 | 6 |
| `load_pct` | Numeric | 0 | 6 |
| `coolant_out_c` | Numeric | 0 | 6 |
| `oil_pressure_bar` | Numeric | 1 | 5 |

Missing means an empty field or a value containing only whitespace. Total missing values: **1**. Missing values were excluded from numeric parsing and statistics.

## Duplicate check

Compared every field as an exact string value. Data-row indexes are 1-based and exclude the header. One duplicate was found: DataRow 6 duplicates the first occurrence at DataRow 5.

## Basic statistics

Standard deviation is the sample standard deviation (denominator `n - 1`). Numeric values use invariant-culture parsing; missing values are excluded.

| Column | Count | Min | Max | Mean | Sample standard deviation |
|---|---:|---:|---:|---:|---:|
| `load_pct` | 6 | 50 | 70 | 63.3333333333333 | 10.3279555898864 |
| `coolant_out_c` | 6 | 78 | 84 | 81.6666666666667 | 2.58198889747161 |
| `oil_pressure_bar` | 5 | 3.8 | 4 | 3.9 | 0.1 |

## Data quality findings and limits

- The expected six data rows were present.
- One exact duplicate pair exists at DataRows 5 and 6.
- `oil_pressure_bar` has one missing value; other columns have none.
- The observed columns were consistently typed under the stated inference rule.
- `timestamp` was retained as a string; no date/time semantic validation was performed.
- This is a synthetic dataset, not NASA C-MAPSS FD001 data. No model training or RUL analysis was performed.
- Input SHA-256 before and after analysis matched, confirming the input was unchanged during Phase A.
