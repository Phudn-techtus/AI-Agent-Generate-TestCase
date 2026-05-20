# 🇯🇵 Dữ Liệu Test Mẫu Cho Thị Trường Nhật Bản (Japan Test Data Samples)

Tài liệu này cung cấp các mẫu dữ liệu chuẩn để sử dụng khi tạo Test Case cho các dự án tại thị trường Nhật Bản, đảm bảo tính thực tế, tuân thủ văn hóa và kỹ thuật.

## 1. Tên Người (Japanese Names)
Khi test, cần kiểm tra các trường hợp nhập tên bằng Kanji, Hiragana, Katakana và Romaji.

| Loại | Kanji (Tên chính thức) | Furigana / Kana (Phiên âm) | Romaji (Ký tự Latinh) | Ghi chú |
|---|---|---|---|---|
| Phổ biến (Nam) | 田中 太郎 | たなか たろう (Tanaka Tarou) | Tanaka Taro | Độ dài chuẩn |
| Phổ biến (Nữ) | 佐藤 花子 | さとう はなこ (Satou Hanako) | Sato Hanako | Độ dài chuẩn |
| Tên rất ngắn | 林 一 | はやし はじめ (Hayashi Hajime) | Hayashi Hajime | Edge case (1 ký tự họ, 1 ký tự tên) |
| Tên rất dài | 長谷川 健太郎 | はせがわ けんたろう | Hasegawa Kentaro | Edge case giới hạn ký tự |
| Katakana (Người nước ngoài) | ジョン・スミス | ジョン・スミス | John Smith | Chứa dấu chấm giữa (・) |

**Lưu ý kỹ thuật:** Tên người Nhật thường được chia thành `Họ (Last Name/Myoji)` và `Tên (First Name/Namae)`. Trong các form, thường yêu cầu nhập 2 lần: 1 lần Kanji và 1 lần Furigana (Katakana/Hiragana).

## 2. Địa Chỉ & Mã Bưu Điện (Addresses & Postal Codes)
Hệ thống địa chỉ Nhật Bản thường bắt đầu bằng Mã bưu điện, sau đó tự động điền Tỉnh và Thành phố.

| Trường | Ví dụ 1 (Tokyo) | Ví dụ 2 (Hokkaido) | Ghi chú |
|---|---|---|---|
| Postal Code (Mã bưu điện) | 150-0043 hoặc 1500043 | 060-0001 | Định dạng chuẩn `XXX-XXXX` hoặc `XXXXXXX` |
| Prefecture (Tỉnh/Thành phố) | 東京都 (Tokyo-to) | 北海道 (Hokkaido) | Có 47 tỉnh thành (To, Do, Fu, Ken) |
| City/Ward (Quận/Huyện) | 渋谷区 (Shibuya-ku) | 札幌市中央区 (Sapporo-shi Chuo-ku) |  |
| Town/Street (Phường/Đường) | 道玄坂 1-2-3 | 北1条西 1丁目 | Có thể chứa số Half-width hoặc Full-width |
| Building (Tòa nhà) | 渋谷タワー 101号室 | 札幌ビル 2F | Tùy chọn, thường hay gây lỗi giới hạn ký tự |

## 3. Số Điện Thoại (Phone Numbers)

| Loại số | Định dạng | Ví dụ | Ghi chú |
|---|---|---|---|
| Di động (Mobile) | 090-XXXX-XXXX, 080-, 070- | 090-1234-5678 | Phổ biến nhất cho SMS OTP |
| Cố định (Landline) | 03-XXXX-XXXX (Tokyo) | 03-1234-5678 | Mã vùng thay đổi theo khu vực (03 cho Tokyo, 06 cho Osaka) |
| IP Phone / Toll-free | 050-XXXX-XXXX, 0120- | 050-1234-5678, 0120-123-456 | |
| Định dạng nhập | | `09012345678` hoặc `090-1234-5678` | Test case nên validate cả số có dấu gạch ngang và không có |

## 4. Định Dạng Ngày Tháng (Date Formats)
Nhật Bản sử dụng cả năm Tây lịch (Gregorian) và năm Niên hiệu (Japanese Era).

| Hệ thống | Định dạng | Ví dụ | Ghi chú |
|---|---|---|---|
| Tây lịch (YMD) | YYYY/MM/DD | 2026/04/29 hoặc 2026年04月29日 | Rất phổ biến trong IT. Chú ý thứ tự là Năm/Tháng/Ngày. |
| Niên hiệu (Reiwa) | Reiwa YY年 MM月 DD日 | 令和8年4月29日 | Reiwa 1 bắt đầu từ 2019. 2026 = Reiwa 8. Thường dùng trong form nhà nước/tài chính. |
| Heisei (Niên hiệu cũ) | Heisei YY年 | 平成30年 (2018) | Cần test tính năng chọn/chuyển đổi niên hiệu sinh nhật. |

## 5. Email & Tên Miền (Emails & Domains)
Người Nhật thường sử dụng email từ các nhà mạng bên cạnh Gmail/Yahoo.

- **Email công ty phổ biến:** `tanaka.taro@company.co.jp`, `info@startup.jp`
- **Carrier Emails (Email nhà mạng):** `user123@docomo.ne.jp`, `example@ezweb.ne.jp`, `test@softbank.ne.jp`
- **Ghi chú Test:** Carrier emails thường có bộ lọc rác (spam filter) rất khắt khe, có thể block email hệ thống nếu không được cấu hình domain whitelist. Đảm bảo có Test Case về việc không nhận được email.

## 6. Tiền Tệ (Currency - JPY)
- Không có số thập phân (No decimals): `1,000 JPY` (Sai: `1000.00 JPY`)
- Ký hiệu: `¥` hoặc `円` (Ví dụ: `¥1,000` hoặc `1,000円`)
- Phân cách hàng nghìn (Comma separator): Bắt buộc trong hiển thị (`1,000,000円`)

## 7. Ghi Chú Về Bảng Mã (Character Encoding)
- **UTF-8:** Chuẩn hiện tại.
- **Shift-JIS / EUC-JP:** Có thể gặp ở các hệ thống tài chính/ngân hàng cũ (FISC compliance).
- **Zenkaku (Full-width) vs Hankaku (Half-width):**
  - Full-width số: `１２３４５` (Thường bị lỗi validation nếu database chỉ nhận số Half-width)
  - Half-width số: `12345`
  - Katakana Full-width: `アイウエオ` (Chuẩn cho tên)
  - Katakana Half-width: `ｱｲｳｴｵ` (Cũ, nhưng thi thi thoảng ngân hàng vẫn yêu cầu)
  - **Test Case quan trọng:** Hệ thống có tự động convert từ Full-width sang Half-width (và ngược lại) khi lưu xuống database không?
