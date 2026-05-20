---
type: template
phase: 4
skill: qa-reviewer
title: Reviewer Output Format
purpose: Mẫu 3 trường hợp output của Reviewer — APPROVED, REJECTED, và HUMAN REVIEW REQUIRED. Reviewer phải render đúng format tương ứng với kết quả chấm điểm.
output_path: (inline trong chat, không lưu file riêng)
consumed_by: [Phase 5 - formatter (nếu APPROVED), Phase 3 - generator (nếu REJECTED)]
---

### Trường hợp APPROVED:
```markdown
### 🟢 STATUS: APPROVED — Quality Score: [XX]/100

**Tóm tắt:**
- Đã review [X] Test Cases.
- Hallucination: 0 vi phạm ✅
- Executability: 0 từ định tính, 0 Expected Result mơ hồ ✅
- Traceability: 100% TC có RULE-ID ✅
- Coverage: Tất cả [X] Rules Critical/Major đã được cover ✅
- Automation: [X] 🤖 Auto-ready / [Y] 👤 Manual-only — Tất cả tag hợp lý ✅

**→ Đề xuất chuyển Phase 5 (Formatter). Gõ 'Duyệt' để tiếp tục.**
```

### Trường hợp REJECTED:
```markdown
### 🔴 STATUS: REJECTED (Vòng [1/2]) — Quality Score: [XX]/100

**📋 Feedback Report:**

| TC ID | Lăng kính | Lỗi cụ thể | Hành động yêu cầu |
| :--- | :--- | :--- | :--- |
| TC_LOGIN_002 | Hallucination | Step 3: "Click nút 'Quên mật khẩu'" — nút này KHÔNG có trong Allowed UI Whitelist Phase 1. | Xoá step này hoặc thay bằng element có trong Whitelist. |
| TC_LOGIN_005 | Executability | Expected Result: "Hiển thị thông báo thành công" — không kiểm chứng được. | Sửa thành: "Toast màu xanh hiển thị text: 'Lưu thành công!'" |
| TC_API_001 | Coverage | RULE-05 (Rate limit) có Severity Major nhưng không có TC nào cover. | Generator bổ sung TC cho RULE-05. |
| TC_SEC_001 | Automation Tag | Tag 🤖 Auto-ready nhưng Pre-condition "Cần thiết bị iOS thật" không setup được bằng code. | Đổi sang 👤 Manual-only + ghi lý do. |

**TC đã Pass (giữ nguyên, không sửa):** [Danh sách TC ID đã pass]

---
⏸ **Orchestrator: Hiển thị Feedback Report này cho User xem xét. Chờ User gõ "Duyệt sửa" trước khi kích hoạt Generator viết lại.**
```

### Trường hợp HUMAN REVIEW REQUIRED:
```markdown
### 🚨 HUMAN REVIEW REQUIRED — Quality Score: [XX]/100

Đã qua 2 vòng tự sửa nhưng các vấn đề sau vẫn tồn đọng:

| TC ID | Vấn đề tồn đọng | Đề xuất |
| :--- | :--- | :--- |
| [TC ID] | [Mô tả vấn đề] | [Đề xuất hướng xử lý] |

**Nguyên nhân có thể:**
- Requirement Phase 1 còn mơ hồ ở một số điểm.
- Có mâu thuẫn giữa Business Rules chưa được làm rõ.
- Scope quá rộng so với thông tin hiện có.

**Đề xuất cho User:** Xem lại Requirement và Normalized Context Phase 1, bổ sung thông tin còn thiếu, sau đó quyết định: (1) Sửa lại Phase 1, (2) Chấp nhận TC hiện tại và xuất thủ công, hoặc (3) Loại bỏ TC có vấn đề.
```
