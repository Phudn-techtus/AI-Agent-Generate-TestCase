---
type: template
phase: 3
skill: qa-generator-strategist
title: Test Case Table Format (8-column)
purpose: Định nghĩa cấu trúc 8-column Markdown Table mà Generator phải render. Bao gồm định nghĩa từng cột, ví dụ row, và output quality checklist.
output_path: (inline trong chat dạng Markdown Table, không lưu file riêng)
consumed_by: [Phase 4 - reviewer, Phase 5 - formatter]
---

### 8 Columns (Mandatory):

```
Code ID | Item Type | Category | Sub-Category | Object | Data Test | Expected Result | Note
```

| Column              | Definition                                                     | Example                                   |
| :------------------ | :------------------------------------------------------------- | :---------------------------------------- |
| **Code ID**         | TC*[MODULE]*[NNN]                                              | DRM-015                                   |
| **Item Type**       | Parent level (Optional, dùng khi cần phân loại rộng)           | 利用者画面URL                             |
| **Category**        | Child level (VD: Các textbox, màn hình con...)                 | 待機画面アクセスハッシュ                  |
| **Sub-Category**    | Sub-child level (VD: Length, BVA, format check...)             | Length                                    |
| **Object**          | Câu hoàn chỉnh "Xác minh rằng..." mô tả rõ nghiệp vụ. YÊU CẦU BẮT BUỘC: Object phải ĐẦY ĐỦ và tự chứa thông tin của Expected Result bên trong nó. Đọc Object là phải biết ngay cấu trúc/kết quả cần verify là gì mà không cần liếc sang cột Expected Result. Cú pháp: `[Hành động cần Verify] -> [Kết quả/Format/Schema chi tiết mong đợi]`. | Xác minh rằng hệ thống báo lỗi khi nhập hash đã tồn tại -> Lỗi hiển thị: Hash đã tồn tại |
| **Data Test**       | Test data values or browser list (optional, ask before adding) | Valid CID: 12345678                       |
| **Expected Result** | Observable, verifiable outcome                                 | Form accepts input, no error displayed    |
| **Note**            | SQL, API paths, reasoning (optional, ask before adding)        | Alphanumeric validation                   |

### Example Markdown Table Format:

| Code ID | Item Type | Category | Sub-Category | Object | Data Test | Expected Result | Note |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| DRM-015 | 利用者画面URL | 待機画面アクセスハッシュ | Length | Xác minh rằng hệ thống chấp nhận form khi nhập access hash đúng độ dài -> Success | Valid length hash: 12345678 | Form accepts input | Length validation |
| DRM-016 | | 待機画面アクセスハッシュ | BVA | Xác minh rằng hệ thống hiển thị lỗi khi nhập hash vượt quá độ dài tối đa -> Lỗi: Maximum length exceeded | Max+1 length hash | Error displayed: Maximum length exceeded | Boundary Value Analysis |
| DRM-017 | | UI | Form Display | Xác minh rằng màn hình hiển thị đầy đủ các trường bắt buộc khi load trang -> Tất cả trường hiển thị | Chrome (Mac), Edge (Windows) | All fields visible | Visual verification |

### Output Quality Checklist:

- ✅ All TCs from Phase 2 Scenarios included
- ✅ Code IDs unique and sequential
- ✅ Item Type (Optional) - Category - Sub-Category hierarchical and consistent (từ to đến nhỏ)
- ✅ Objects clearly describe what's tested (not vague)
- ✅ Expected Results are observable & verifiable (no "works", "ok", "correct")
- ✅ Traceability references to AC/EC (Column 9, added by Phase 5)
- ✅ No empty/null cells in required 8 columns
- ✅ Test Data examples provided for non-UI tests (optional)
- ✅ Note field for API/SQL references (optional)

### Traceability Mapping (for Phase 5):

- Each TC must reference which AC/EC(s) it covers (added during Phase 5 Formatter)
- Example: TC_DMR_001 → AC-DM-UI-01
- This 2-way mapping enables forward (TC→AC/EC) and reverse (AC/EC→TC) traceability
