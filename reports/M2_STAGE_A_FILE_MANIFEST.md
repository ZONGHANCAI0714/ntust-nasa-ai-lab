# M2 Stage A File Manifest

Source policy: trusted local files only. The absolute local user portion is redacted as `<LOCAL_PROJECT_ROOT>` in this report. No source data was modified, copied, normalized, or exported.

| File | Actual local path (redacted root) | Size bytes | SHA-256 before | Encoding / detection | Physical lines | Nonblank records | Blank lines | Delimiter | Parsed records | Parse errors |
|---|---|---:|---|---|---:|---:|---:|---|---:|---:|
| train_FD001.txt | <LOCAL_PROJECT_ROOT>\train_FD001.txt | 3515356 | 963B5E22825B34D8B21C69E1AEB4AF3E647050EB672EE8834BA4B5D91D2DE0F8 | ASCII (strict UTF-8 validation; no BOM) | 20631 | 20631 | 0 | whitespace (\s+) | 20631 | 0 |
| test_FD001.txt | <LOCAL_PROJECT_ROOT>\test_FD001.txt | 2228855 | 3CDA7109CE17BAFB5443F2AC926CFCF88154B941B8C4CF95EB55D1DDD6F52851 | ASCII (strict UTF-8 validation; no BOM) | 13096 | 13096 | 0 | whitespace (\s+) | 13096 | 0 |
| RUL_FD001.txt | <LOCAL_PROJECT_ROOT>\RUL_FD001.txt | 429 | A19C8EC94931949D0485BDC35118206E9C81C4547B422EFB9CF86F4CEDDBCECA | ASCII (strict UTF-8 validation; no BOM) | 100 | 100 | 0 | whitespace (\s+) | 100 | 0 |

Encoding detection: inspect BOM bytes first (UTF-8/16/32); without a BOM, use a strict UTF-8 decoder. No-BOM files containing only ASCII characters are labeled ASCII-compatible UTF-8. Decode errors are fatal and recorded by the script.

Blank lines are physical lines containing only whitespace and are not parsed records. Nonblank record counts include malformed nonblank lines. Train/Test field delimiter is one-or-more whitespace characters; RUL is expected to have one numeric field per nonblank record.

### Parse errors

#### TRAIN
- None.
#### TEST
- None.
#### RUL
- None.