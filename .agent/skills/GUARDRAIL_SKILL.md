---
name: guardrail-enforcer
description: Cơ chế thực thi Guardrail tập trung (HOW/WHEN to enforce). Định nghĩa tất cả Input Gates, PAUSE Protocol, Output Release Checks, và Correction Loop step-by-step. **KHÔNG định nghĩa tiêu chuẩn chất lượng** — phần đó thuộc `global_rule.md`. BẮT BUỘC ĐỌC sau global_rule.md, trước khi thực thi bất kỳ Phase nào.
version: "1.1"
phase: cross-phase
persona: System Enforcer
type: guardrail
triggered_by: [Orchestrator — đọc ngay sau global_rule.md, trước mọi Phase]
applies_to: [Phase 0, Phase 1, Phase 2, Phase 3, Phase 4, Phase 5]
---

# 🛡️ Skill: Guardrail Enforcer — v1.1

> **Vai trò của file này:** Định nghĩa **HOW/WHEN** — cơ chế thực thi, điều kiện dừng, kiểm tra đầu vào/đầu ra, và xử lý vi phạm.
> **Không chứa** định nghĩa tiêu chuẩn chất lượng — phần đó thuộc `.agent/rules/global_rule.md`.

| File | Vai trò | Đọc khi nào |
|:---|:---|:---|
| `global_rule.md` | **WHAT** — Tiêu chuẩn chất lượng, nguyên tắc, danh sách vi phạm | Trước GUARDRAIL |
| `GUARDRAIL_SKILL.md` | **HOW/WHEN** — Gates, PAUSE, Output Checks, Correction Loop | Sau global_rule.md |

---

## 1. 🚦 Tổng quan — 5 Nhóm Guardrail

| Nhóm | Tên | Áp dụng tại |
|:---:|:---|:---|
| G1 | **Input Validation Gates** | Phase 0, 1 |
| G2 | **Anti-Hallucination Protocol** | Phase 1, 3, 4 |
| G3 | **Human-in-the-Loop Gates (PAUSE)** | Mọi Phase |
| G4 | **Output Safety Rules** | Mọi Phase |
| G5 | **Correction & Escalation Protocol** | Phase 4, và bất kỳ Phase nào bị lỗi |

---

## 2. G1 — Input Validation Gates

### G1.1 — Minimum Information Threshold (Phase 1)

> **Áp dụng:** Phase 1 — Requirement Analyzer

**Rule:** Nếu input từ Phase 0 (hoặc trực tiếp từ User) có **ít hơn 3 thông tin nghiệp vụ cụ thể**, Phase 1 phải:

1. ✅ **DỪNG NGAY** — Không sinh AC/EC Matrix.
2. ✅ **Chỉ** xuất danh sách Clarification Questions.
3. ✅ Chờ User trả lời đủ trước khi tiếp tục.

**Vi phạm:** Sinh AC/EC khi input chưa đủ → **REJECT toàn bộ output**.

---

### G1.2 — Context Confirmation (Phase 1, 3)

> **Áp dụng:** Phase 1 và Phase 3 — trước khi bắt đầu bất kỳ thao tác phân tích/sinh TC nào.

> 💡 **"Prove You Read It" — Tại sao bước này tồn tại:**
> LLM có xu hướng "lướt qua" context khi bị overload thông tin. Rule được viết đúng nhưng AI không chứng minh đã áp dụng chúng. Context Confirmation buộc AI thực sự xử lý context trước khi sinh output — không phải chỉ đọc lướt.

**Thứ tự đọc bắt buộc (thực hiện ngầm):**

1. `.agent/rules/global_rule.md` — Default Persona + Quality Standards
2. `.agent/skills/GUARDRAIL_SKILL.md` ← **file này**
3. `.agent/context/project_context.md` — **ĐỌC `⚠️ CRITICAL ALERT` TRƯỚC**
4. `.agent/context/test_data_samples.md` *(nếu tồn tại)*
5. Input/Output của Phase trước

**System Constraint Check (Dynamic CoT - CHỈ IN RA KHI TÍNH NĂNG PHỨC TẠP):**
> Agent tự đánh giá độ phức tạp của Requirement. CHỈ sinh token suy luận (Forced Chain-of-Thought bọc trong HTML `<details>`) nếu tính năng thuộc dạng "Phức tạp" (có nhiều liên kết chéo với tính năng khác, luồng rẽ nhánh sâu, hoặc tích hợp hệ thống ngoài). Đối với các tính năng đơn giản (dù vẫn bắt buộc rà soát ngầm các rule cơ bản của dự án), bỏ qua thẻ details để tiết kiệm token và tránh nhiễu thông tin.

```html
<details>
<summary>⚙️ System Constraint Check (Tính năng Phức tạp - Click để mở rộng)</summary>

- **Phân tích Liên kết chéo:** Tính năng đụng chạm tới module nào?
- **Gỡ rối Logic:** Có vướng Rule nào trong `project_context.md` cần làm rõ?
- **Edge cases:** Nút thắt nguy hiểm nhất?
</details>
```

✅ Context rõ → Dựa vào độ phức tạp để quyết định in hay ngầm, rồi làm tiếp | ❓ Context mơ hồ → Dừng, xuất Clarification.

---

### G1.3 — Cross-Check Trước Khi Hỏi (Phase 1)

> **Áp dụng:** Phase 1 — Trước khi in bất kỳ Clarification Question nào.

**Rule:** BẮT BUỘC đối chiếu với `global_rule.md` và `project_context.md` trước khi in câu hỏi. **Tuyệt đối KHÔNG hỏi** những vấn đề đã được quy định rõ trong Context Rules. Chỉ hỏi khi có lỗ hổng thực sự.

**Định dạng bắt buộc cho Clarification Questions:**

| No. | Vấn đề / Lỗ hổng phát hiện | Câu hỏi làm rõ | Các Lựa chọn (Option) / Gợi ý |
|:---:|:---|:---|:---|
| **1** | [Mô tả lỗ hổng] | [Câu hỏi cụ thể] | **[A]** Option A<br>**[B]** Option B |

---

## 3. G2 — Anti-Hallucination Enforcement

> **Nguyên tắc (WHAT)** được định nghĩa tại `global_rule.md` Section 3.1 — “Không được phép tự sáng tạo UI/API ngoài Requirement.”
> File này chỉ định nghĩa **cơ chế thực thi (HOW/WHEN)**: kiểm tra như thế nào, Phase nào kiểm tra, xử lý ra sao khi vi phạm.

### G2.1 — Whitelist Enforcement

**Rule:** Chỉ các UI Elements / API Endpoints được **Phase 1 liệt kê trong Allowed UI Elements Whitelist** mới được phép sử dụng trong Phase 2 và 3.

- **Phase 1:** Xây Whitelist chính xác từ Requirement. Không suy diễn thêm.
- **Phase 3:** Tuyệt đối KHÔNG dùng bất kỳ element nào ngoài Whitelist — kể cả khi nghe có vẻ hợp lý.
- **Phase 4:** Bất kỳ element ngoài Whitelist → **Reject ngay lập tức (không thương tiếc)**.

**Penalty:** Vi phạm = REJECT + ghi lý do cụ thể trong Feedback Report.

---

### G2.2 — Self-Review Ngầm Bắt Buộc (Phase 1, 3)

> **TUYỆT ĐỐI KHÔNG IN RA CHAT.** Thực hiện hoàn toàn trong Internal Thought.

**Phase 1 (trước khi in Clarification hoặc AC/EC Matrix):**
1. Cross-check toàn bộ Global Rules và Project Context (đặc biệt Critical Alerts).
2. Đối chiếu Pre-conditions vật lý (VD: Attendee không thể vào phòng nếu không có Host).
3. Đối chiếu Role Exhaustion: Đã vét cạn đủ Role (Host, Attendee, Monitoring) chưa?
4. Tự sửa lỗi ngầm nếu phát hiện câu hỏi/kết quả sai trước khi in ra.

**Phase 3 (trước khi in bảng Test Cases chính thức):**
1. Đối chiếu Pre-conditions: Có TC nào vi phạm giới hạn vật lý không?
2. Kiểm tra Deduplication: Đã áp dụng rút gọn TC cho các config giống nhau chưa?
3. Tự sửa lỗi ngầm: Gạch bỏ TC vi phạm và sửa ngay trên bản draft trong đầu.

---

### G2.3 — Zero Assumptions Rule

**Rule:** Nếu Requirement thiếu thông tin → **hỏi lại (Clarification)**, tuyệt đối không đoán mò và tự điền logic.

**Penalty:** Assumption ngầm quan trọng = REJECT + Đề nghị Clarification.

---

### G2.4 — Scope Lock (Phase 3)

**Rule:** Phase 3 chỉ sinh TC cho những gì đã có trong AC/EC Phase 1 và theo đúng Blueprint từ Phase 2. **Tuyệt đối KHÔNG tự thêm scope** — nếu muốn mở rộng → phải flag cho Phase 4 Reviewer.

---

## 4. G3 — Human-in-the-Loop Gates (PAUSE Protocol)

> **Áp dụng:** Mọi Phase

### G3.1 — Mandatory PAUSE sau mỗi Phase

**Rule:** Mọi Phase **BẮT BUỘC DỪNG LẠI** sau khi hoàn thành output. Chỉ chuyển sang Phase kế tiếp khi User gõ **"Duyệt"**.

| Phase kết thúc | Điều kiện PAUSE |
|:---|:---|
| Phase 0 | Dừng sau khi tạo file `_Ingester.md`. Chờ "Duyệt". |
| Phase 1 | **Trường hợp 1:** Có Clarification → DỪNG ngay, chờ User trả lời. **Trường hợp 2:** Không có câu hỏi → Sinh AC/EC, chờ "Duyệt". |
| Phase 2 | Dừng sau khi xuất Blueprint. Chờ "Duyệt". |
| Phase 3 | Dừng sau khi hiển thị toàn bộ Markdown Table TC. Chờ "Duyệt". |
| Phase 4 | APPROVED: Dừng chờ "Duyệt" sang Phase 5. REJECTED: Dừng hiển thị Feedback Report, chờ "Duyệt sửa". |
| Phase 5 | Dừng sau khi lưu file. Workflow kết thúc. |

**Vi phạm:** Tự ý chuyển Phase mà không có "Duyệt" của User = **Vi phạm Quy trình Nghiêm trọng**.

---

### G3.2 — Checklist Trước PAUSE (Pre-Duyệt Checklist)

Mỗi Phase phải tự kiểm tra trước khi PAUSE. Danh sách chi tiết nằm trong SKILL.md của từng Phase, nhưng phải đảm bảo đủ **3 điều kiện tối thiểu**:

1. ✅ Output đã được tạo theo đúng Template của Phase?
2. ✅ File vật lý (nếu có) đã được tạo tại đúng path?
3. ✅ Không còn câu hỏi/lỗi nào chưa được xử lý?

---

## 5. G4 — Output Safety Rules

> **Áp dụng:** Mọi Phase

### G4.1 — File Path Safety

**Rule:** Output file vật lý **BẮT BUỘC** phải được lưu đúng path quy định. **Tuyệt đối KHÔNG** lưu vào thư mục tạm, artifacts, hay chỉ print ra chat mà không tạo file.

| Phase | Path bắt buộc |
|:---|:---|
| Phase 0 | `project/input/{folder_name}/{input_filename}_Ingester.md` |
| Phase 5 | `project/output/{folder_name}/{input_filename}_{YYYYMMDD}.tsv` |

---

### G4.2 — Scope Boundary (Không vượt phạm vi Phase)

Mỗi Phase chỉ được làm đúng nhiệm vụ của mình:

| Phase | Được phép | Bị cấm |
|:---|:---|:---|
| Phase 0 | Làm sạch & format data | Phân tích, đặt câu hỏi, viết TC |
| Phase 1 | Phân tích, sinh AC/EC | Viết Test Case |
| Phase 2 | Chọn Chiến thuật, xuất Blueprint | Viết Test Case |
| Phase 3 | Sinh Test Case từ AC/EC và Blueprint | Phân tích thêm requirement, tự thêm scope |
| Phase 4 | Chấm điểm, xuất Feedback | Tự sửa TC (dù chỉ 1 từ) |
| Phase 5 | Format & lưu file | Sửa logic/chính tả TC |

---

### G4.3 — Anti-Qualitative Language

**Rule:** Cấm hoàn toàn các từ ngữ định tính trong Expected Result và Test Steps:

❌ Cấm: `nhanh chóng`, `hợp lý`, `bình thường`, `có vẻ đúng`, `hiển thị đúng`, `Hệ thống báo lỗi`, `Hoạt động bình thường`, `Đăng nhập thành công`.

✅ Bắt buộc: Giá trị cụ thể và đo lường được — VD: `HTTP 200`, `URL chuyển sang /dashboard`, `Toast màu đỏ hiển thị text: 'Số điện thoại không hợp lệ'`.

**Penalty:** 1 từ định tính trong Expected Result = REJECT (Phase 4 Lăng kính 2).

---

### G4.4 — Anti-Junk Test Data

**Rule:** Cấm dùng dữ liệu test rác. Mọi Data Test phải có ý nghĩa nghiệp vụ thực tế.

❌ Cấm: `test123`, `asdfgh`, `aaa`, `user1`, `data`, `value`.

✅ Bắt buộc: Lấy từ `context/test_data_samples.md` hoặc domain-appropriate data (VD: `CID=6000`, `email=user@example.com`).

**Penalty:** Test Data rác = REJECT (Phase 4 Lăng kính 2).

---

### G4.5 — Atomic AC/TC Rule (Phase 1, 3)

**Rule:** 
- **Tại Phase 1:** MỘT AC/EC = MỘT hành vi (behavior) duy nhất. Không gộp nhiều rule/trigger/behavior vào chung 1 AC/EC. Phải map 100% các behavior từ file reference (nếu có) thành các dòng riêng biệt.
- **Tại Phase 3:** MỘT Test Case = MỘT kịch bản duy nhất. Không được gộp test đúng và test sai vào cùng 1 TC.

**Penalty:** Non-atomic = REJECT (Phase 4 Lăng kính 2) hoặc User sẽ Reject output của Phase 1.

---

### G4.6 — English Translation Mandatory (Phase 5)

**Rule:** Phase 5 BẮT BUỘC dịch 100% nội dung TC (Object, Data Test, Expected Result, Note) sang Tiếng Anh chuyên ngành kiểm thử trước khi xuất file.

**Penalty:** Còn nội dung Tiếng Việt trong file output = Output không đạt.

---

### G4.7 — Object Column Format Strictness (Phase 3, 5)

**Rule:** Cột `Object` của Test Case BẮT BUỘC phải tự chứa Expected Result bên trong nó, và tuân theo mẫu chuẩn mực BDD-style (khi nào/thì làm sao).
- **Cú pháp bắt buộc:**
  `Verify that [behavior/feature] correctly when [condition/action]`
  `-> [Expected Result]`
- **Ví dụ:**
  `Verify that PiP open correctly when Start Share Screen (or User click on Share Screen Btn) -> The Pip window Imediately appears in the bottem right corner of the screen`
- **Lý do:** Đảm bảo khả năng đọc lướt (skimming) cực nhanh cho Tester và giữ cấu trúc văn phạm đồng nhất. Người đọc chỉ cần nhìn cột Object là biết cả Test Scenario lẫn Expected Result.
- Áp dụng cho cả bản nháp Markdown (Phase 3) và bản xuất file cuối cùng (Phase 5).

**Penalty:** Cột Object bị thiếu dấu `->` hoặc thiếu vế Expected Result = REJECT (Phase 4 Lăng kính 2).

---

## 6. G5 — Correction & Escalation Protocol

> **Áp dụng chính:** Phase 4. Áp dụng bổ sung cho mọi Phase khi phát hiện lỗi.

### G5.1 — Correction Loop (Phase 4 → Phase 3)

**Khi Phase 4 REJECT:**

```
Phase 4 REJECT
  → Xuất Feedback Report (ghi rõ Vòng 1/2 hoặc 2/2)
  → DỪNG, chờ User "Duyệt sửa"
  → Phase 3 chỉ sửa TC được flag lỗi (không động vào TC đã PASS)
  → Phase 4 review lại (đây là Vòng 2)
  → Nếu Vòng 2 vẫn fail → 🚨 HUMAN REVIEW REQUIRED
```

**Quy tắc cứng:**
- Tối đa **2 vòng** Correction Loop tự động.
- Phase 4 **tuyệt đối không tự sửa** TC — dù chỉ 1 từ.
- Feedback Report **phải ghi rõ** Vòng (1/2) hay (2/2).
- Feedback Report **phải liệt kê rõ** TC nào FAIL để Phase 3 không sửa TC đã PASS.

---

### G5.2 — Escalation Protocol (Khi mọi vòng đều thất bại)

**Khi nào escalate:**
- Phase 4 Vòng 2 vẫn REJECT.
- Bất kỳ Phase nào stuck (không có đủ thông tin để tiếp tục, Clarification không được trả lời).

**Hành động:**
1. In ra: `🚨 HUMAN REVIEW REQUIRED — [Lý do cụ thể]`
2. Tóm tắt trạng thái hiện tại (đã làm gì, vướng ở đâu).
3. **DỪNG HẲN** — Không tự ý làm thêm bất cứ điều gì.

---

### G5.3 — Traceability Mandatory (Phase 3, 4)

**Rule:** Mọi Test Case phải có tham chiếu ngược về AC/EC ID (cột Note). Không một TC nào được "mồ côi" — không map được về Rule nào.

**Phase 4 kiểm tra:** TC không có RULE-ID hợp lệ = Fail Lăng kính 3.

---

### G5.4 — Zero-Loss Modification Rule (Mọi Phase)

**Rule:** Khi nhận Feedback yêu cầu sửa đổi một nội dung từ User hoặc Reviewer, Agent BẮT BUỘC phải đối chiếu lại với file Context/Input gốc. TUYỆT ĐỐI KHÔNG ĐƯỢC vì tập trung sửa một ý mà tự ý xóa bỏ, ghi đè, hoặc làm rơi vãi các hành vi (behavior), tính năng, hoặc trigger khác đã được định nghĩa.
**Penalty:** Làm mất thông tin nghiệp vụ = Vi phạm Quy trình Nghiêm trọng.

---

## 7. 📊 Enforcement Quick-Reference

> **Định nghĩa vi phạm đầy đủ** → `global_rule.md` Section 5. Bảng dưới cung cấp **G-code và hành động thực thi** để tra cứu nhanh.

| Hành vi Vi phạm | G-code | Hành động thực thi |
|:---|:---:|:---|
| Sinh AC/EC khi input < 3 thông tin | G1.1 | Dừng, chỉ xuất Clarification Questions |
| Bỏ qua Context Confirmation | G1.2 | Flag vi phạm quy trình |
| Dùng UI element ngoài Allowed Whitelist | G2.1 | REJECT ngay lập tức |
| Assumption ngầm khi thiếu thông tin | G2.3 | Dừng, xuất Clarification, REJECT nếu đã sinh output |
| Thêm scope ngoài AC/EC Phase 1 | G2.4 | Flag cho Reviewer, không viết TC đó |
| Tự ý chuyển Phase không có "Duyệt" | G3.1 | Vi phạm Quy trình Nghiêm trọng |
| Lưu file sai path / chỉ print ra chat | G4.1 | Output không đạt |
| Phase vượt phạm vi nhiệm vụ | G4.2 | Vi phạm Quy trình |
| Từ ngữ định tính trong Expected Result | G4.3 | REJECT (Phase 4 Lăng kính 2) |
| Test Data rác (test123, aaa,...) | G4.4 | REJECT (Phase 4 Lăng kính 2) |
| Gộp nhiều kịch bản/behavior vào chung 1 AC/TC | G4.5 | REJECT (Phase 4) hoặc Reject Phase 1 |
| Phase 4 tự sửa TC không qua "Duyệt sửa" | G5.1 | Vi phạm Quy trình Nghiêm trọng |
| TC không có RULE-ID (orphan) | G5.3 | Fail Lăng kính 3 |
| Sửa lỗi làm mất/xóa nhầm data nghiệp vụ khác | G5.4 | Vi phạm Quy trình Nghiêm trọng |
| Vượt 2 vòng Correction không escalate | G5.2 | Escalate 🚨 HUMAN REVIEW REQUIRED |

---

## 8. 📚 References

- **Global Rules (Quality Standards):** `.agent/rules/global_rule.md`
- **Master Workflow (Phase Flow):** `.agent/workflows/master_workflow.md`
- **Project Context (Domain Rules):** `.agent/context/project_context.md`
- **Phase SKILL.md files:** `.agent/skills/Phase [N] - [name]/SKILL.md`
