---
type: reference
phase: 0
skill: data-ingester
title: Cleaned Requirement Standard
purpose: Tiêu chuẩn "input đạt chuẩn" để Orchestrator quyết định bypass Phase 0. AI đọc để so sánh input với chuẩn này, KHÔNG dùng để render output.
used_by: [SKILL.md — Bước bypass check]
---

# 📐 Tiêu Chuẩn Đầu Vào "Đạt Chuẩn" (Cleaned Requirement Standard)

Nếu `[REQUIREMENT]` của bạn tuân thủ đúng các tiêu chuẩn dưới đây, **Orchestrator sẽ bỏ qua Phase 0 (Data Ingestion)** và tiến thẳng đến Phase 1 để tiết kiệm thời gian và tài nguyên xử lý.

---

## 1. Các Tiêu Chí "Đạt Chuẩn" (Bỏ qua Phase 0)

1. **Thuần Tuý Nghiệp Vụ (No Noise):** Không chứa các câu giao tiếp dư thừa (vd: "Chào AI, giúp tôi làm cái này", "Dưới đây là tài liệu..."). Không dính metadata copy từ PDF/Word (như `Page 1 of 5`, timestamp, header/footer).
2. **Cấu Trúc Markdown Rõ Ràng (Well-Formatted):**
   - Sử dụng các Header phân cấp (`#`, `##`, `###`) để phân chia các màn hình hoặc chức năng.
   - Sử dụng Bullet points (`-`) hoặc Numbered lists (`1.`, `2.`) cho danh sách tính năng / luồng thao tác.
3. **Bảng Biểu Chuẩn (Markdown Tables):** Nếu có dữ liệu dạng bảng, phải được format bằng Markdown (không dán trực tiếp dữ liệu ngăn cách bằng tab/phẩy từ Excel).
4. **Code / API Spec Rõ Ràng:** Các đoạn code, JSON, API response phải được bọc trong Markdown Code Block (` ```json `).

---

## 2. Mẫu Requirement Đạt Chuẩn (Ví dụ minh họa)

```markdown
## Màn hình Đăng ký Khám bệnh từ xa (WebRTC)

### 1. UI Elements (Giao diện)
- Textbox: "Họ và tên", "Số điện thoại", "Email"
- Dropdown: "Chọn chuyên khoa" (Nội khoa, Ngoại khoa, Da liễu)
- Nút bấm: "Đăng ký khám", "Hủy bỏ"
- Màn hình popup: Yêu cầu cấp quyền Camera & Microphone

### 2. Business Rules (Quy tắc Nghiệp vụ)
- **Họ và tên:** Bắt buộc, độ dài từ 2-50 ký tự. Không chứa ký tự đặc biệt.
- **Số điện thoại:** Bắt buộc, đúng định dạng số điện thoại Nhật Bản (vd: 090-xxxx-xxxx).
- **Email:** Không bắt buộc. Nếu nhập phải đúng định dạng email.
- **Cấp quyền:** Khi click "Đăng ký khám", hệ thống phải gọi hàm xin quyền Camera và Mic. Nếu từ chối, hiển thị lỗi: "Cần cấp quyền thiết bị để tiếp tục".

### 3. API Integration
- Method: `POST /api/v1/telehealth/register`
- Payload: 
```json
{
  "fullName": "Tanaka Taro",
  "phone": "090-1234-5678",
  "department": "Dermatology"
}
```
- Response: HTTP 200 OK nếu thành công, HTTP 400 Bad Request nếu validation fail.
```

> **Lưu ý:** Nếu bạn copy paste hỗn độn từ Jira, Excel, hoặc PDF vào prompt, Phase 0 sẽ tự động kích hoạt để format mọi thứ về dạng chuẩn này trước khi Phase 1 bắt đầu.
