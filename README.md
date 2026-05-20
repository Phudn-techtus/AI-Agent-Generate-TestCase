# 🤖 AI Test Case Generation Pipeline

> **Một AI, năm vai — từ Requirement thô đến Test Case chuẩn sẵn sàng import Google Sheet.**

Hệ thống pipeline 6 Phase chuyên biệt để tự động hóa toàn bộ vòng đời phân tích yêu cầu và sinh Test Case. Kiến trúc **Template-Driven**, **Context-Aware**, **Domain-Agnostic** — áp dụng cho bất kỳ dự án nào chỉ bằng cách thay `project_context.md`.

---

## 🏗️ Cấu Trúc Dự Án

```
Agent_TestCase_V2/
│
├── project/                          # 👤 User Workspace (thay đổi theo từng run)
│   ├── input/                        # Drop requirement files (.md) vào đây
│   │   └── {feature_name}/
│   │       ├── {feature}.md          # File requirement gốc
│   │       └── {feature}_Ingester.md # Output Phase 0
│   └── output/                       # Test Cases đã export
│       └── {feature_name}/
│           └── {feature}_{YYYYMMDD}.tsv
│
├── .agent/                           # 🤖 AI Agent Framework (ít khi thay đổi)
│   ├── rules/
│   │   └── global_rule.md            # WHAT — Tiêu chuẩn chất lượng + Default Persona
│   ├── skills/
│   │   ├── GUARDRAIL_SKILL.md        # HOW/WHEN — Gates, PAUSE, Correction Protocol
│   │   ├── Phase 0 - ingester/       # Brainstorm/Clarify + Làm sạch Requirement
│   │   │   ├── SKILL.md
│   │   │   ├── template.md           # Mẫu output _Ingester.md
│   │   │   └── reference.md          # Tiêu chuẩn "input đạt chuẩn" (bypass check)
│   │   ├── Phase 1 - analyzer/       # Phân tích, sinh AC/EC Matrix + UI Whitelist
│   │   │   ├── SKILL.md
│   │   │   └── template.md
│   │   ├── Phase 2 - strategist/     # Phân rã Blueprint & Áp dụng Multiplier
│   │   │   ├── SKILL.md
│   │   │   └── template.md
│   │   ├── Phase 3 - generator/      # Sinh Test Case 8-column từ AC/EC + Blueprint
│   │   │   ├── SKILL.md
│   │   │   └── template.md
│   │   ├── Phase 4 - reviewer/       # Chấm điểm 4 lăng kính (0–100)
│   │   │   ├── SKILL.md
│   │   │   └── template.md
│   │   └── Phase 5 - formatter/      # Export 12-column TSV / Google Sheet
│   │       ├── SKILL.md
│   │       └── template.md
│   ├── workflows/
│   │   └── master_workflow.md        # Phase Orchestrator — luồng điều phối 6 Phase
│   └── context/                      # 📌 Thay đổi theo dự án
│       ├── project_context.md        # Domain knowledge, Critical Rules, Architecture
│       └── test_data_samples.md      # Dữ liệu test mẫu theo thị trường
│
├── scripts/
│   └── clean_agent_cache.sh          # Dọn cache AI (giữ Knowledge, xóa artifacts)
└── README.md
```

---

## 🚀 The 6-Phase Pipeline

> 💡 **Core Principle:** Output của mỗi Phase chính là Input bắt buộc của Phase tiếp theo.
> *Ví dụ: Output của Phase 0 (`_Ingester.md`) là Source of Truth đầu vào cho Phase 1.*

```
[REQUIREMENT FILE]  →  project/input/{feature}/
        ↓
[Phase 0] Ingester — Brainstorm/Clarify (nếu thiếu thông tin) + Làm sạch & chuẩn hóa data thô
        ↓ (Output: Requirement - Source of Truth) ⏸ PAUSE → Chờ "Duyệt"
[Phase 1] Analyzer — AC/EC Matrix + UI Whitelist + Business Rules (RULE-ID)
        ↓ (Output: Master Context) ⏸ PAUSE → Chờ "Duyệt"
[Phase 2] Strategist — Định hình Blueprint Structuring + Mandatory Rules (Role/Link)
        ↓ (Output: Blueprint Structuring) ⏸ PAUSE → Chờ "Duyệt"
[Phase 3] Generator — Test Cases 8-column (Happy Path / BVA / EP / Negative / Edge)
        ↓ (Output: Master Module) ⏸ PAUSE → Chờ "Duyệt"
[Phase 4] Reviewer — Quality Score (0–100) theo 4 lăng kính + Feedback Report
        ↓ (Output: Trace-Gap-Analyze Review) ⏸ PAUSE → Chờ "Duyệt" (hoặc "Duyệt sửa" → vòng lại Phase 3)
[Phase 5] Formatter — Export 12-column TSV sẵn sàng import Google Sheet
        ↓ (Output: 12-column TSV file)
✅  project/output/{feature}/{feature}_{YYYYMMDD}.tsv
```

**Cách kích hoạt:** Nói với AI — *"Đọc file project/input/FeatureName.md"*

---

## 🛡️ Kiến Trúc Guardrail (2-layer)

Hệ thống bảo vệ chất lượng hoạt động theo nguyên tắc tách biệt trách nhiệm:

| File | Vai trò | Nội dung |
|:---|:---:|:---|
| `global_rule.md` | **WHAT** | Default Persona, tiêu chuẩn chất lượng, danh sách vi phạm |
| `GUARDRAIL_SKILL.md` | **HOW/WHEN** | Input Gates (G1), Anti-Hallucination (G2), PAUSE Protocol (G3), Output Safety (G4), Correction Loop (G5) |

**Cơ chế thực thi nổi bật:**
- **"Prove You Read It":** Context Confirmation ngầm ở Phase 1 & 2 — AI phải chứng minh đã xử lý đúng context, không chỉ đọc lướt.
- **Human-in-the-Loop:** AI bắt buộc DỪNG sau mỗi Phase, chỉ tiếp tục khi User gõ "Duyệt".
- **Correction Loop:** Tối đa 2 vòng sửa. Vòng 2 vẫn fail → 🚨 HUMAN REVIEW REQUIRED.
- **Zero Hallucination:** Chỉ dùng UI element/API có trong Whitelist từ Phase 1. Vi phạm → REJECT ngay.

---

## 💡 Hướng Dẫn Sử Dụng

### 📥 Kéo (Pull) Repo Về Dự Án Bằng GitHub CLI

Để tải hoặc cập nhật repository này về máy thông qua công cụ dòng lệnh GitHub CLI (`gh`), bạn sử dụng các lệnh sau:

```bash
# 1. Nếu đây là lần đầu, kéo (clone) dự án về máy:
gh repo clone <tên-org>/<tên-repo>

# 2. Nếu thư mục đã tồn tại và bạn muốn đồng bộ (pull) phiên bản mới nhất:
gh repo sync
```

### Chạy pipeline

1. Đặt file requirement vào `project/input/` (VD: `project/input/FeatureLogin/FeatureLogin.md`)
2. Nói với AI: **"Đọc file project/input/FeatureLogin/FeatureLogin.md"**
3. AI chạy qua từng Phase, dừng lại ở mỗi checkpoint chờ bạn **"Duyệt"**
4. Kết quả lưu tại `project/output/{Tên_Feature}/`

### Adapt cho dự án mới

| Muốn thay đổi | Chỉ cần sửa | Không cần động |
|:---|:---|:---|
| Đổi dự án / domain | `.agent/context/project_context.md` | Skills, Workflow, Rules |
| Đổi thị trường (US, EU, JP) | `.agent/context/test_data_samples.md` | Skills, Workflow |
| Thêm feature mới | Drop file vào `project/input/` | Toàn bộ pipeline |

---

## 🧹 Dọn Cache AI (Khuyến nghị hàng tuần)

Script `scripts/clean_agent_cache.sh` tự động xóa rác (artifacts, log phiên làm việc) nhưng **giữ nguyên Knowledge Items** — trí nhớ cốt lõi của AI.

> ✅ An toàn 100%: Mọi luật dự án nằm trong `project_context.md`, AI đọc lại mỗi Phase. Xóa lịch sử chat không làm mất context.

**Cài đặt chạy tự động hàng tuần (Cron — Chủ Nhật 00:00):**

```bash
# Bước 1: Mở crontab
crontab -e

# Bước 2: Thêm dòng sau (nhấn i để edit trong Vim)
0 0 * * 0 /Users/macbook_273/Agent_TestCase_V2/scripts/clean_agent_cache.sh >> /tmp/agent_cleanup_log.txt 2>&1

# Bước 3: Lưu (:wq + Enter)
```

> ⚠️ **MacOS:** Cần cấp Full Disk Access cho `/usr/sbin/cron` tại `System Settings → Privacy & Security → Full Disk Access`.

---

## 🧩 Nguyên Tắc Thiết Kế Cốt Lõi

| Nguyên tắc | Mô tả |
|:---|:---|
| **No Hallucination** | Agent chỉ viết những gì có căn cứ từ Requirement + Context |
| **Single Source of Truth** | `project_context.md` là nơi duy nhất chứa domain rules |
| **Domain-Agnostic Skills** | SKILL.md không chứa logic domain-specific — dùng lại mọi dự án |
| **Flat Skill Structure** | Mỗi Phase folder: `SKILL.md` + `template.md` (+ `reference.md` nếu cần). Không dùng subfolder |
| **Verification-Driven** | Expected Results phải đo lường được (Observable & Verifiable) |
| **Separation of Concerns** | `global_rule.md` = WHAT · `GUARDRAIL_SKILL.md` = HOW/WHEN |

---

## 🗺️ Architecture Notes & Future Roadmap

### Mapping sang Claude Code Architecture (tham khảo)

Hệ thống hiện tại đã **tự nhiên converge** về kiến trúc 5-layer của Claude Code:

| Claude Code Layer | Tương đương trong hệ thống này |
|:---|:---|
| **L1 — CLAUDE.md** (Memory, always loaded) | `global_rule.md` + `project_context.md` |
| **L2 — Skills** (On-demand knowledge) | `.agent/skills/Phase X/SKILL.md` + `template.md` |
| **L3 — Hooks** (Deterministic guardrail) | ⚠️ **Chưa có** — xem note bên dưới |
| **L4 — Subagents** (Delegation) | 6-Phase pipeline (1 AI, 6 vai tuần tự) |
| **L5 — Plugins** (Distribution) | `.agent/` folder có thể copy sang project khác |

### ⚠️ Gap: Hard Guardrail (Hooks)

`GUARDRAIL_SKILL.md` hiện tại là **soft guardrail** — AI-interpreted, AI có thể không tuân thủ hoàn toàn.

Claude Code Hooks là **hard guardrail** — deterministic script, không qua AI:
- `PreToolUse` / `PostToolUse` / `SessionStart` / `Stop` lifecycle events
- Có thể: lint sau khi ghi file, chặn lệnh nguy hiểm, verify output tồn tại

**Khi nào nên implement:**
- Nếu chuyển sang Claude Code platform → có thể dùng native Hooks ngay
- Nếu volume output lớn / team dùng chung → thêm `scripts/validate/` (check_output.sh, check_columns.sh) để verify Phase 4 TSV deterministically
- Hiện tại: User review manual là đủ, không cần tốn token thêm
