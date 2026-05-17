# Nội dung phân tích và giải thích bài tập tổng hợp Session 13

## Phần A:Phân tích kiến trúc TRIGGER

1. Sự kiện: Xác định thời điểm kích hoạt (BEFORE hay AFTER) và sự kiện (INSERT, UPDATE hay DELETE) phù hợp để tính toán dữ liệu trước khi lưu vào database.
   - Theo em phải sử dụng cả 2 thời điểm kích hoạt là before bởi vì nó vừa cần chặn sự kiện khi dữ liệu không hợp lệ after để cập nhật giá trị của bảng khác
   - Sự kiện before insert để thêm dịch vụ và after insert để cập nhật giá trị bảng khác khi mới thêm dữ liệu hợp lệ
2. Biến cục bộ: Gạch đầu dòng các biến (DECLARE) cần dùng trong khối BEGIN...END để hứng dữ liệu tra cứu (Ví dụ: giá dịch vụ, số dư ví, trạng thái ví).
   - DECLARE status_services VARCHAR(20);
   - DECLARE balance_account DECIMAL(18,2);
   - DECLARE service_price DECIMAL(18,2);

```sql
DECLARE status_services VARCHAR(20); -- Sử dụng để hứng trạng thái ví
DECLARE balance_account DECIMAL(18,2); -- Sử dụng để hứng số dư ví
DECLARE service_price DECIMAL(18,2); -- Sử dụng để hứng giá dịch vụ
```
