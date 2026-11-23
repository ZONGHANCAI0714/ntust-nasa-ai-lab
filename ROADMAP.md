建立正式 M0–M5 Roadmap。

每一 Milestone 必須包含：
- Goal
- Inputs
- Deliverables
- Responsible Brain
- Acceptance Criteria
- STOP_IF
- Next Role
- Status

M0: Governance Initialization

Goal:
建立 AI Team Governance 與 GitHub 同步機制。

Inputs:
學生正式批准的治理要求與 Roadmap。

Deliverables:
AGENTS.md
ROADMAP.md
WORK_ITEM.md
DECISIONS.md
GitHub Repository
Initial Commit

Responsible Brain:
STUDENT-MAIN

Acceptance:
四個檔案存在於 GitHub main，
內容符合工作單且可從遠端驗證。

STOP_IF:
檔案缺失、Commit 失敗、Push 失敗、
GitHub 無法驗證、權限不符。

Next Role:
RESEARCH Brain

Status:
PASS

M1: Synthetic CSV First Verified Return

Goal:
使用本地六筆合成 CSV 驗證 Worker 派工、
執行證據與驗收流程。

Inputs:
synthetic_sensor.csv
預期六筆，實際內容尚未驗證。

Deliverables:
Dataset Profile
Row Count
Column Schema
Missing Value Report
Duplicate Check
Sample Statistics
Execution Evidence
Worker Return

Responsible Brain:
RESEARCH Brain

Acceptance:
實際讀取成功，驗證預期筆數，
所有結果具備可重現證據。

STOP_IF:
FILE_NOT_FOUND
READ_ERROR
ROW_COUNT_MISMATCH
INSUFFICIENT_EVIDENCE

Next Role:
STUDENT-MAIN / ENGINEERING Brain

Status:
BLOCKED

M2: FD001 Data Integration

Goal:
接入 NASA C-MAPSS FD001 真實資料。

Inputs:
本地 FD001 原始檔及官方資料說明。

Deliverables:
Dataset Manifest
Data Dictionary
Source Traceability
Validated Data Loader
Engine-Cycle-Sensor Query Interface

Responsible Brain:
RESEARCH Brain
ENGINEERING Brain

Acceptance:
資料來源可追溯，
Engine、Cycle、Sensor 查詢正確，
與原始數值一致。

STOP_IF:
SOURCE_UNKNOWN
COLUMN_MAPPING_ERROR
DATA_MISMATCH
INSUFFICIENT_EVIDENCE

Next Role:
ENGINEERING Brain

Status:
LOCKED

M3: Health Analysis Website MVP

Goal:
建立本地端互動式健康分析網站。

Inputs:
M2 已驗收資料介面。

Deliverables:
Local Website
Engine Selector
Cycle Selector
Sensor Selector
Sensor Trend Chart
Source Information Panel

Responsible Brain:
ENGINEERING Brain

Acceptance:
網站可啟動，
選擇器與圖表正確，
顯示數值可回查原始資料。

STOP_IF:
WEBSITE_START_FAILURE
SELECTOR_MISMATCH
TREND_DATA_MISMATCH
UNVERIFIED_DATA

Next Role:
RESEARCH Brain

Status:
LOCKED

M4: Evidence Prompt Generator

Goal:
產生可追溯的 Evidence Prompt。

Inputs:
M3 網站選擇狀態及真實資料來源。

Deliverables:
Evidence Prompt Generator
Prompt Copy Function
Evidence Metadata
Traceability Validation

Responsible Brain:
RESEARCH Brain
ENGINEERING Brain

Acceptance:
Prompt 包含 Engine、Cycle、Sensor、
實際數值、來源及分析限制，
可回查原始資料。

STOP_IF:
FABRICATED_EVIDENCE
SOURCE_MISSING
PROMPT_DATA_MISMATCH
UNVERIFIED_CONCLUSION

Next Role:
STUDENT-MAIN

Status:
LOCKED

M5: Final Integration and Local Delivery

Goal:
完成整合、驗收及本地交付。

Inputs:
M2–M4 已驗收成果。

Deliverables:
Complete Website
Source Code
Installation Guide
Test Report
Evidence Examples
Known Limitations

Responsible Brain:
STUDENT-MAIN
ENGINEERING Brain

Acceptance:
學生可在本地啟動網站，
選擇 Engine、Cycle、Sensor，
檢查真實來源、趨勢，
並產生可追溯 Evidence Prompt。

STOP_IF:
CORE_FUNCTION_FAILURE
REPRODUCIBILITY_FAILURE
EVIDENCE_MISMATCH
BLOCKING_DEFECT

Next Role:
STUDENT (OWNER)

Status:
LOCKED

強制規則：
M0 未 PASS，不得開始 M1。
M1 未 PASS，不得開始 M2。
其餘里程碑依序執行。
每階段均須 MAIN 授權。
