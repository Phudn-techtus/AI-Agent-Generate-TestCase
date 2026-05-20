---
type: template
phase: 1
skill: requirement-analyzer
title: AC/EC Output Format
purpose: Mẫu chuẩn để Analyzer render ra AC/EC Matrix. Bao gồm ID naming convention, cấu trúc bảng theo Screen→Function→Category, và ví dụ minh hoạ. Phase 3 Generator đọc output dựa trên format này.
output_path: (inline trong chat, không lưu file riêng)
consumed_by: [Phase 2 - strategist, Phase 3 - generator]
---

# 📋 Định dạng Đầu ra AC/EC — Đầu ra của Analyzer Giai đoạn 1

> **Mục đích:** Analyzer Giai đoạn 1 tạo ra Tiêu chí Chấp nhận (AC) & Trường hợp Ngoại lệ (EC) hoàn chỉnh để làm nền tảng cho việc sinh Test Case.
> **Định dạng mới:** Tổ chức theo Màn hình (Screen) → Bảng danh sách AC/EC rõ ràng.
> **Trạng thái:** Mẫu tiêu chuẩn bắt buộc áp dụng.

---

## 🔑 Giải thích Định dạng Mã ID (ID Naming Convention)

Mỗi Tiêu chí Chấp nhận (AC) hoặc Trường hợp Ngoại lệ (EC) PHẢI có một ID duy nhất được định nghĩa theo cú pháp:
`[LOẠI]-[MÃ_TÍNH_NĂNG]-[DANH_MỤC]-[STT]`

**Ví dụ phân tích mã: `EC-MB-LOG-01`**
- **LOẠI:** 
  - `AC` (Acceptance Criteria): Tiêu chí chấp nhận cho luồng thành công (Happy Path) hoặc luồng hoạt động bình thường.
  - `EC` (Exception Criteria): Tiêu chí cho luồng ngoại lệ, báo lỗi, hoặc các case biên (Edge/Negative Path).
- **MÃ_TÍNH_NĂNG:** Cụm 2-3 chữ cái viết tắt của tính năng (VD: `MB` = Mynavi Baito, `DM` = Discovery Mode, `LOG` = Login).
- **DANH_MỤC (Category):** Phân loại logic của tiêu chí:
  - `UI`: Giao diện người dùng / Hiển thị.
  - `FUNC`: Chức năng / Validate dữ liệu.
  - `SEC`: Bảo mật / Phân quyền.
  - `TRG`: Điều kiện kích hoạt (Trigger).
  - `API`: Tích hợp API (Request/Response).
  - `LOG`: Cơ chế ghi Log, Retry, Xử lý lỗi hệ thống.
- **STT:** Số thứ tự tăng dần (01, 02, 03...).

---

## 📝 VÍ DỤ MINH HỌA: Tính năng Đăng ký Chế độ Khám phá (Discovery Mode)

### 🖥️ MÀN HÌNH: Trang Đăng ký Chế độ Khám phá

#### 🔄 CHỨC NĂNG 1: Hiển thị Biểu mẫu và Nhập dữ liệu (UI & Validation)

| ID | Tiêu đề | Danh mục | Mô tả & Dữ liệu kiểm thử |
| :--- | :--- | :--- | :--- |
| **AC-DM-UI-01** | Hiển thị tất cả các trường | Giao diện (UI) | **Mô tả:** Biểu mẫu phải hiển thị đủ các trường bắt buộc (CID, Tên Hợp đồng, URL, Nút chuyển đổi).<br>**Phạm vi:** Trình duyệt Chrome (Mac), Edge (Win), Mobile Safari. |
| **EC-DM-UI-01** | Responsive trên các màn hình | UI - Ngoại lệ | **Mô tả:** Các phần tử không bị cắt xén, vỡ layout.<br>**Dữ liệu:** Viewport 1920x1080, 1366x768, 375x812. |
| **AC-DM-FUNC-01** | Chấp nhận CID hợp lệ | Xác thực (Valid) | **Mô tả:** Chấp nhận nhập CID đúng chuẩn chữ và số, độ dài 6-20 ký tự.<br>**Dữ liệu:** `12345678`, `ABC123456`. |
| **AC-DM-FUNC-02** | Từ chối CID không hợp lệ | Xác thực (Invalid) | **Mô tả:** Báo lỗi nếu CID sai định dạng.<br>**Lỗi dự kiến:** "CID phải có từ 6-20 ký tự chữ và số".<br>**Dữ liệu:** `123` (quá ngắn), `CID@#` (chứa ký tự đặc biệt). |
| **EC-DM-FUNC-01** | Xử lý giá trị biên (BVA) CID | Xác thực - Biên | **Mô tả:** Kiểm tra độ dài biên của CID.<br>**Dữ liệu:** Tối thiểu (`123456`), Tối đa (`12345678901234567890`), Dưới min (`12345`), Trên max (`...21chars`). |

#### 🔐 CHỨC NĂNG 2: Cài đặt Hết hạn & Phân quyền (Security & Business Logic)

| ID | Tiêu đề | Danh mục | Mô tả & Dữ liệu kiểm thử |
| :--- | :--- | :--- | :--- |
| **AC-DM-SEC-01** | Thời gian hết hạn hợp lệ | Bảo mật / Logic | **Mô tả:** Hệ thống không cho phép nhập thời gian hết hạn trong quá khứ.<br>**Dữ liệu:** Hợp lệ (1 giờ tới), Không hợp lệ (Hôm qua) -> Báo lỗi. |
| **EC-DM-SEC-01** | Xác thực thời gian biên | Bảo mật - Ngoại lệ | **Mô tả:** Kiểm tra tại thời điểm hiện tại + 1 phút (tối thiểu) và thời gian max (30 ngày). |
| **AC-DM-SEC-02** | Giới hạn quyền Quản trị viên | Phân quyền (Auth) | **Mô tả:** User không phải Admin không thể xem hoặc gửi biểu mẫu.<br>**Dự kiến:** Trả về HTTP 403 Forbidden. |

---

### 📊 SƠ ĐỒ TRUY XUẤT NGUỒN GỐC (TRACEABILITY MAPPING)

```text
Trang Đăng ký Chế độ Khám phá
├── Hiển thị Biểu mẫu Đăng ký (UI)
│   ├── AC-DM-UI-01: Biểu mẫu hiển thị tất cả các trường
│   └── EC-DM-UI-01: Vị trí biểu mẫu trên các màn hình khác nhau
│
├── Nhập CID & Validate
│   ├── AC-DM-FUNC-01: Chấp nhận CID hợp lệ
│   ├── AC-DM-FUNC-02: Từ chối CID không hợp lệ
│   └── EC-DM-FUNC-01: Giá trị biên (độ dài tối thiểu/tối đa)
│
└── Cài đặt & Phân quyền (Bảo mật)
    ├── AC-DM-SEC-01: Không thể ở trong quá khứ
    └── AC-DM-SEC-02: Giới hạn quyền Quản trị viên
```

#### Bảng Thống kê Tiêu chí

| Danh mục | Số lượng AC | Số lượng EC | Tổng cộng |
| :--- | :--- | :--- | :--- |
| Giao diện (UI) | 1 | 1 | 2 |
| Xác thực (Chức năng) | 2 | 1 | 3 |
| Bảo mật | 2 | 1 | 3 |
| **TỔNG CỘNG** | **5** | **3** | **8** |

---

## ✅ DANH SÁCH KIỂM TRA CHO NGƯỜI ĐÁNH GIÁ (Giai đoạn 1 → Giai đoạn 2)

**Trước khi phê duyệt AC/EC, hãy xác minh:**

- [ ] Quy ước đặt tên ID tuân thủ đúng định dạng `[Loại]-[Mã Tính Năng]-[Danh Mục]-[STT]`.
- [ ] AC/EC được tổ chức thành BẢNG (TABLE) theo từng nhóm Chức năng.
- [ ] Mỗi tiêu chí có Mô tả rõ ràng và Dữ liệu kiểm thử cụ thể.
- [ ] Các trường hợp ngoại lệ được xác định và liệt kê bằng mã `EC-*`.
- [ ] Số lượng AC hợp lý cho phạm vi tính năng.
- [ ] Sẵn sàng để Strategist Giai đoạn 2 ánh xạ thành các Test Scenarios.
