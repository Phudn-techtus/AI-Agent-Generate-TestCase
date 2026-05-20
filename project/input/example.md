# Yêu Cầu Tính Năng (Requirement): Đăng Nhập Hệ Thống

## 1. Mô tả (Description)
Người dùng (Admin/User) có thể đăng nhập vào hệ thống quản lý thông qua Email và Mật khẩu.

## 2. Giao diện (UI Elements)
- `[Input]` Email
- `[Input]` Password
- `[Button]` Đăng Nhập
- `[Link]` Quên mật khẩu

## 3. Luồng nghiệp vụ (Business Flow)
1. Người dùng nhập Email và Password hợp lệ.
2. Click nút "Đăng Nhập".
3. Hệ thống kiểm tra. Nếu đúng, chuyển hướng (redirect) vào trang `/dashboard`.
4. Nếu sai, hiển thị Toast message màu đỏ: "Email hoặc mật khẩu không chính xác".

## 4. Ràng buộc (Validation Rules)
- Email: Bắt buộc nhập, phải đúng định dạng email chuẩn.
- Password: Bắt buộc nhập, từ 8-20 ký tự, bao gồm ít nhất 1 chữ cái và 1 chữ số.
