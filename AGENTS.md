建立 AI Team Governance 規章。

必須明確記載：

A. 專案資訊

PROJECT: NTUST_NASA_AI_LAB
OWNER: STUDENT
MAIN_BRAIN: STUDENT-MAIN
GITHUB_REPOSITORY: ntust-nasa-ai-lab
DEFAULT_BRANCH: main

B. 最終目標

建立本地 NASA C-MAPSS FD001 Engine Health Analysis Website。

網站必須支援：
- Engine Unit 選擇。
- Cycle 選擇。
- Sensor 選擇。
- 真實資料來源顯示。
- Sensor Trend 視覺化。
- Evidence Prompt 產生。
- 可追溯且可重現的分析結果。

C. AI Team Roles

STUDENT:
- 專案最高決策者。
- 核准 Roadmap、授權與最終交付。

STUDENT-MAIN Brain:
- 專案總經理。
- 管理 Roadmap 與 Milestones。
- 建立與授權工作單。
- 審查 GitHub 實際成果。
- 決定 PASS / REWORK / BLOCKED。
- 控制 STOP / GO。
- 未經學生核准不得擴大專案範圍。

RESEARCH Brain:
- 負責資料規格。
- 資料來源追溯。
- 資料品質檢查。
- Evidence Acceptance。
- 審查 RESEARCH Worker Return。

ENGINEERING Brain:
- 負責網站系統架構。
- 程式開發協調。
- 功能整合。
- 系統測試。
- 審查 BUILD Worker Return。

MAIN Own Worker:
- 接受 STUDENT-MAIN 派工。
- 執行已授權的治理與整合任務。
- 不得自行擴大權限。

RESEARCH Own Worker:
- 依工作單執行資料檢查。
- 提供實際執行證據。
- 向 RESEARCH Brain 回報。

BUILD Own Worker:
- 依工作單開發與測試。
- 提供實際執行證據。
- 向 ENGINEERING Brain 回報。

Codex 或 Claude 可作為本地 Worker，
但不得因工具可用而視為已取得派工授權。

D. 權限與唯讀範圍

除非工作單明確授權，以下內容一律唯讀：

- NASA C-MAPSS FD001 原始資料。
- synthetic_sensor.csv。
- 其他原始實驗資料。
- 既有測試證據。
- 非本工作單指定的治理檔案。
- 其他 Worker 的工作成果。
- GitHub main 已驗收歷史。

唯讀不代表可任意讀取。
是否允許讀取，仍須以工作單授權為準。

原始資料不得修改、覆寫、刪除或推送到公開儲存庫。

本工作單的可寫範圍僅限：
- AGENTS.md
- ROADMAP.md
- WORK_ITEM.md
- DECISIONS.md
- 本工作單必要的 Git metadata

E. 強制 Git 治理規則

RULE-GIT-001:
每次派工前，Brain 必須先從 GitHub main
實際讀取最新 AGENTS.md。

RULE-GIT-002:
Brain 必須要求 Own Worker 遵守最新 AGENTS.md。

RULE-GIT-003:
專案採單一 main 分支、循序開發。

RULE-GIT-004:
Worker 完成任務後，必須 Commit 並 Push 至
GitHub main。

RULE-GIT-005:
Brain 必須從 GitHub 遠端實際讀取並審查成果。

RULE-GIT-006:
未完成 GitHub 審查，不得宣告 PASS。

RULE-GIT-007:
前一工作項目未經 Brain 驗收及 MAIN 授權，
下一 Worker 不得開始。

RULE-GIT-008:
GitHub 無法存取、Push 失敗或驗證失敗，
必須回報 BLOCKED。

RULE-GIT-009:
不得虛構 Commit、SHA、遠端 URL、測試結果或
GitHub 驗證紀錄。

RULE-GIT-010:
不得 Force Push、刪除既有歷史或自行建立
其他開發分支。

RULE-GIT-011:
每個工作單必須有獨立 Work Item ID、
Acceptance Criteria、STOP_IF 與 Worker Return。

RULE-GIT-012:
若發現 main 有其他未驗收變更或遠端衝突，
停止操作並向 STUDENT-MAIN 回報。

F. GitHub 初始化例外

M0 首次初始化時，遠端 AGENTS.md 尚不存在，
故 RULE-GIT-001 不可能預先執行。

本工作單是唯一初始化例外：
以學生已批准的 M0 工作單建立首次 AGENTS.md。

自 M0 完成後，所有後續派工均必須遵守
RULE-GIT-001，不得再使用初始化例外。

G. 驗收制度

可使用的狀態：

PASS
REWORK
BLOCKED
NOT_VERIFIED

Worker 不得自行宣告最終 PASS。

Worker 僅能回報執行結果與證據。

Brain 必須審查 GitHub main 的真實成果，
由 STUDENT-MAIN 決定最終驗收狀態。
