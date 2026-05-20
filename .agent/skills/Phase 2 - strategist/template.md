---
type: template
phase: 2
skill: decomposition-strategist
title: Decomposition Blueprint Format
purpose: Mẫu Blueprint Strategist xuất ra sau khi User chọn chiến thuật phân rã. Phase 3 Generator bắt buộc bám sát cấu trúc Item Type và Category trong file này.
output_path: (inline trong chat, không lưu file riêng)
consumed_by: [Phase 3 - generator]
---

# 🧭 Decomposition Blueprint Template

> **Mục đích:** Khung xương chuẩn hóa cấu trúc phân rã Test Case (Item Type và Category).
> **Input từ:** Output của Phase 2 (Strategist) sau khi User chọn Chiến thuật.
> **Tiêu thụ bởi:** Phase 3 (Generator) bắt buộc phải bám sát cấu trúc này.

---

## 1. Metadata
- **Feature Name:** `[Tên tính năng]`
- **Selected Strategy:** `[Chiến thuật đã chọn - VD: Strategy 1 (UI) + 4 (Realtime)]`
- **Mandatory Multipliers:**
  - Role Exhaustion: `[Có/Không - Liệt kê role]`
  - Link Types: `[Có/Không - Normal vs 1:1]`

## 2. Blueprint Structure (Cấu trúc Khung xương)

> **Hướng dẫn cho Phase 3 (Generator):** BẮT BUỘC sử dụng các mục trong cột `Flow Step (Item Type)` và `Category` dưới đây làm xương sống cho AC/EC Matrix và Test Case. Không được tự ý tạo thêm Flow Step ngoài danh sách này. Các Node của AC/EC Matrix từ Phase 1 PHẢI được map vào cấu trúc dọc này.

| Flow Step (Item Type) | Category (Sub-components) | Focus Area (Phạm vi Test chính) |
| :--- | :--- | :--- |
| **1. [Tên Flow Step 1]**<br>*(VD: Main Screen - Triggers)* | - `[Category 1.1]`<br>- `[Category 1.2]` | `[Mô tả những gì cần test ở đây, lưu ý nguyên tắc UI trước Function sau]` |
| **2. [Tên Flow Step 2]**<br>*(VD: Sub-window - Layout)* | - `[Category 2.1]` | `[Mô tả...]` |

---

## 3. Checklist Chuyển Giao (Handover)
- [ ] Blueprint đã phản ánh đúng luồng (flow-based) chưa?
- [ ] Đã tách bạch rõ UI và Function chưa?
- [ ] User đã gõ "Duyệt" để chốt Blueprint này chưa?

**➡️ NẾU USER ĐÃ DUYỆT: Lệnh cho hệ thống kích hoạt Phase 3 (Generator) sử dụng Blueprint này.**
