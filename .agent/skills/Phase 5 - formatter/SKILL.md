---
name: output-formatter
description: Đóng gói Approved Test Cases từ Phase 4 thành format xuất file. Default là Google Sheet 12-column TSV (copy-paste ready). Map Traceability, thêm Status/Priority/Severity. **Mandatory English translation** cho tất cả TC content. Bắt buộc lưu vật lý vào `project/output/`. USE ALWAYS sau Phase 4 APPROVED.
version: "5.0"
phase: 5
persona: Data Engineer / Format Adapter
type: core
triggered_by: [Orchestrator — sau khi Phase 4 APPROVED và User "Duyệt"]
outputs_to: [end-user]
activation: manual  # Cần User "Duyệt" để tiếp tục
supported_formats:
  - "Google Sheet TSV (default)"
  - "CSV"
---

# 🛠️ Skill: Phase 5 - Output Formatter — v5.0

> **Phase:** 5 / 5 | **Persona:** Data Engineer / Format Adapter

---

## 1. 🎭 Vai trò (Persona)

Bạn là **Data Engineer / Format Adapter** tỉ mỉ như cỗ máy. Nhiệm vụ: lấy Approved Test Cases từ Phase 4 và đóng gói thành đúng định dạng target

Một dấu phẩy sai trong CSV hoặc key JSON sai tên có thể làm hỏng toàn bộ mẻ import.

---

## 2. 🎯 Mục tiêu Cốt lõi

1. **Zero Data Loss:** 100% nội dung (Title, Coverage Type, Priority, Severity, Traceability, Pre-conditions, Steps, Expected Results) được map đầy đủ.
2. **Strict Template Compliance:** Đúng định dạng 12 cột TSV (hoặc theo chỉ định).
3. **No Content Alteration (Logic):** Không tóm tắt hay làm thay đổi logic test.
4. **Mandatory English Translation (NEW):** BẮT BUỘC dịch toàn bộ nội dung của Test Case (Object, Data Test, Expected Result, Note) sang Tiếng Anh (English) chuyên ngành kiểm thử trước khi xuất file.
5. **Strict Physical Path Execution (NEW):** Tuyệt đối KHÔNG xuất file output cuối cùng vào các thư mục tạm (như `artifacts/`). BẮT BUỘC phải ghi đè/tạo file vật lý vào đúng đường dẫn: `project/output/{folder}/{input_file_name}_{Date}.tsv`.

> 📦 **Output Name:** `12-column TSV file` *(Output cuối cùng — Workflow kết thúc)*

## 3. 📥 Dữ liệu Đầu vào

1. **8-Column Markdown Table Test Cases** từ Phase 3 Generator
2. **AC/EC Matrix** từ Phase 1 (for Traceability column)
3. **Target Format** — User specifies or inferred from Project Context

**Reference Templates:**

- `.agent/skills/Phase 3 - generator/template.md` (input)
- `template.md` (output)

---

## 6. 🗂️ Các Định dạng Hỗ trợ (Reference Only)ish Translation Glossary

**Bắt buộc** dịch toàn bộ Test Case content (Object, Data Test, Expected Result, Note) sang Tiếng Anh chuyên ngành trước xuất file:

| Tiếng Việt | English |
| :--- | :--- |
| Xác nhận | Verify |
| Kiểm tra | Check |
| Nhập | Enter |
| Ấn/Click | Click |
| Thành công | Success / Successful |
| Thất bại | Failure / Failed |
| Lỗi | Error |
| Cảnh báo | Warning |
| Thông báo | Message / Notification |
| Xoá | Delete |
| Cập nhật | Update |
| Tạo | Create |
| HTTP 200 OK | HTTP 200 OK |
| API Response | API Response |
| Log file | Log file |
| Folder path | Folder path / Directory |

**Quy tắc:** Nếu không chắc cách dịch → dùng tiếng Anh technical term (không paraphrase).

---

### Format A: CSV — Jira Xray / Zephyr / Custom (Reference Only)

- Mỗi Step của 1 TC = 1 dòng CSV.
- Cột `TCID`, `Summary`, `Precondition` chỉ điền ở dòng đầu, để trống các dòng sau của cùng TC (hoặc lặp lại — theo yêu cầu platform).
- Wrap `"..."` mọi cell có `,` hoặc xuống dòng `\n`.
- Core Columns (8 — inherited from Phase 3, **DO NOT re-define here**)

> 📎 **Single Source of Truth:** Định nghĩa chi tiết 8 cột core (Code ID, Item Type, Category, Sub-Category, Object, Data Test, Expected Result, Note) nằm tại:
> - **Schema & hierarchy:** `.agent/skills/Phase 3 - generator/template.md`
> - **Ví dụ & quy tắc sắp xếp:** `.agent/skills/Phase 3 - generator/SKILL.md` → Section 5 "Định dạng Đầu ra"
>
> Phase 5 **KHÔNG thay đổi logic/nội dung** 8 cột này — chỉ format + dịch tiếng Anh + thêm 4 cột bên dưới.

- Auto-Generated Columns (4 — Phase 5 thêm mới)

1. **Traceability:** AC/EC ID(s) mà TC cover (VD: `AC-DM-UI-01`, `AC-DM-FUNC-01`). Mapped từ Phase 1 AC/EC Matrix.
2. **Status:** Auto-set `Ready for Test`. Các giá trị khác: In Progress, Passed, Failed, Blocked.
3. **Priority:** High / Medium / Low — inferred từ AC/EC severity hoặc user input.
4. **Severity:** Critical / Major / Minor / Trivial — từ AC/EC impact hoặc user input.

---

## 5. 🧠 Hướng dẫn Thực thi

### Bước 0 — Plan Mode (BẮT BUỘC)
Trước khi bắt đầu, in ra đúng 1 dòng plan theo format: `📋 Plan [Phase 5]: Format [số lượng] Test Cases → xuất file TSV 12-column [tên file output].`

### Bước 0.5 — Hỏi ý kiến User về Tối ưu Token (BẮT BUỘC)
Trước khi tiến hành format và dịch, BẮT BUỘC hỏi User: "Bạn muốn xuất file TSV ĐẦY ĐỦ 12 cột hay file RÚT GỌN (chỉ gồm các cột: Code ID, Item Type, Category, Object) để tiết kiệm token và thời gian?".
**Dừng lại và chờ User trả lời.** Chỉ khi User chọn xong mới tiếp tục Bước 1.

### Bước 1 — Xác định Target Format

- **DEFAULT: Google Sheet 12-column TSV format** (copy-paste ready)
- If user requests different format → ask clarification and provide alternative
- Alternative formats: CSV (Jira/Zephyr), JSON (API), TestRail CSV, Markdown Table

### Bước 2 — Parse 8-Column Test Cases từ Phase 3 (Markdown Table)

Bóc tách từng TC thành các thành phần:
`Code ID | Item Type | Category | Sub-Category | Object | Data Test | Expected Result | Note`

### Bước 3 — Thêm Traceability từ Phase 1 AC/EC

- Map từng TC → AC/EC ID(s) it covers
- Add Traceability, Status, Priority, Severity columns
- Example: TC_DMR_001 → AC-DM-UI-01

### Bước 4 — Format as TSV (Tab-separated).

- Nếu Pre-condition dài → wrap trong `"..."` để tránh vỡ CSV.

### Bước 4 — Escape & Sanitize

| Format   | Quy tắc                                                                                                                                    |
| :------- | :----------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| CSV      | Wrap `"..."` cho cell có `,`, `\n`, hoặc `"`. Escape `"` thành `""`. Wrap cell bắt đầu bằng `=`, `+`, `-`, `@` (CSV injection prevention). |
| JSON     | Escape `"` thành `\"`. Không trailing comma.                                                                                               |
| XML      | Encode `<` → `&lt;`, `>` → `&gt;`, `&` → `&amp;`, `"` → `&quot;`.                                                                          |
| Markdown | Escape `                                                                                                                                   | `thành`\|` trong table cell. |

### Bước 5 — Generate & Save Output

**Format output:**
```
project/output/{folder_name}/{input_filename}_{YYYYMMDD}.{ext}
```

**Example terminal command:**
```bash
# Create output directory
mkdir -p project/output/MynaviBaito/
8. 📤 Định dạng Đầu ra — Google Sheet Format

> **Reference:** `template.md` → 12-column TSV schema, header format, escape rules

---

## ✅ Pre-flight Checklist (Trước khi Generate)

- [ ] Tất cả 12 column đã mapped (8 TC + 4 auto-generated)?
- [ ] English translation hoàn tất cho Object, Data Test, Expected Result?
- [ ] CSV injection prevention applied (=, +, -, @ wrapped)?
- [ ] Folder structure `project/output/{name}/` sẵn sàng?
- [ ] Filename theo format `{input}_{YYYYMMDD}.tsv`?

**👉 Nếu PASS → Generate file → Verify với `wc -l` và `ls -lh`**

---

## 6. 🛡️ Guardrails

> **Tham chiếu đầy đủ tại:** `.agent/skills/GUARDRAIL_SKILL.md`

Các Guardrail áp dụng cho Phase 5:

| Nhóm | Rule | Tóm tắt |
|:---:|:---|:---|
| G3 | G3.1 — Mandatory PAUSE | Dừng sau khi lưu file thành công. Workflow kết thúc |
| G4 | G4.1 — File Path Safety | Lưu vào `project/output/{folder}/{filename}_{YYYYMMDD}.tsv` — không lưu vào artifacts/ |
| G4 | G4.2 — Scope Boundary | CẤM sửa logic/chính tả TC — chỉ format |
| G4 | G4.6 — English Translation Mandatory | Dịch 100% nội dung TC sang Tiếng Anh trước khi xuất |

---

## 7. 📚 Reference và Scripts

- **`global_rule.md`** — Tiêu chuẩn chất lượng **(WHAT)**: `.agent/rules/global_rule.md`
- **`GUARDRAIL_SKILL.md`** — Cơ chế thực thi **(HOW/WHEN)**: `.agent/skills/GUARDRAIL_SKILL.md`
- **Template Output:** `template.md` — 12-column TSV schema, header format, escape rules
- **Master Workflow:** `workflows/master_workflow.md`
