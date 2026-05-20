#!/bin/bash

echo "🧹 Bắt đầu dọn dẹp rác hệ thống Agent..."

# Xóa toàn bộ rác nháp và lịch sử trong não bộ (brain)
rm -rf ~/.gemini/antigravity/brain/* 2>/dev/null

# Xóa toàn bộ lịch sử tin nhắn UI (conversations & implicit metadata)
rm -rf ~/.gemini/antigravity/conversations/* 2>/dev/null
rm -rf ~/.gemini/antigravity/implicit/* 2>/dev/null

# Xóa thư mục hiển thị HTML tĩnh
rm -rf ~/.gemini/antigravity/html_artifacts/* 2>/dev/null

echo "✅ Đã dọn dẹp xong toàn bộ lịch sử và file nháp! Trí nhớ cốt lõi (Knowledge) vẫn được bảo toàn an toàn."
