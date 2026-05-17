CREATE DATABASE service_db;
USE service_db;

-- 1. Bảng Bệnh nhân (Patients)
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);

-- 10. Bảng Dịch vụ khám (Services) 
CREATE TABLE Services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL
);

-- 11. Bảng Ví điện tử (Wallets) 
CREATE TABLE Wallets (
    patient_id INT PRIMARY KEY,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Active', -- 'Active', 'Inactive'
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 12. Bảng Lịch sử sử dụng dịch vụ (Service_Usages) 
CREATE TABLE Service_Usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    actual_price DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

-- Chèn Bệnh nhân
INSERT INTO Patients (patient_id, full_name, phone, date_of_birth) VALUES
(1, 'Nguyen Van An', '0901111222', '1990-05-15'),
(2, 'Tran Thi Binh', '0912222333', '1985-08-20'),
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');

INSERT INTO Services (service_id, name, price) VALUES
(1, 'Sieu am o bung', 200000.00),
(2, 'Xet nghiem mau', 150000.00),
(3, 'Chup X-Quang', 250000.00);

-- Chèn Ví điện tử
INSERT INTO Wallets (patient_id, balance, status) VALUES
(1, 500000.00, 'Active'),    -- Test Case 1: Đủ tiền thanh toán
(2, 50000.00, 'Active'),     -- Test Case 3: Cháy ví (Chỉ có 50k, không đủ khám 200k)
(3, 1000000.00, 'Inactive'); -- Test Case 2: Nhiều tiền nhưng thẻ bị khóa
DROP TRIGGER IF EXISTS AutoDeductWallet;
DELIMITER //
CREATE TRIGGER AutoDeductWallet 
BEFORE INSERT ON Service_Usages
FOR EACH ROW
BEGIN 
    DECLARE status_wallets VARCHAR(20);
    DECLARE balance_account DECIMAL(18,2);
    DECLARE service_price DECIMAL(18,2);
    SELECT status INTO status_wallets FROM Wallets WHERE patient_id = NEW.patient_id;
    SELECT balance INTO balance_account FROM Wallets WHERE patient_id = NEW.patient_id;
    SELECT price INTO service_price FROM services WHERE service_id = NEW.service_id;
    
    IF status_wallets = 'Inactive' THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Thất bại: Ví trả trước đang bị khóa';
	ELSEIF balance_account < service_price THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Thất bại: Số dư ví không đủ để thanh toán';
	END IF;
    
    SET NEW.actual_price = service_price;
	UPDATE Wallets
	SET balance = balance - NEW.actual_price
	WHERE NEW.patient_id = patient_id;
END //
DELIMITER ;

INSERT INTO Service_Usages (patient_id, service_id) VALUES (3, 2);
INSERT INTO Service_Usages (patient_id, service_id) VALUES (2, 1);
INSERT INTO Service_Usages (patient_id, service_id) VALUES (1, 3);
SELECT * FROM Service_Usages;
SELECT * FROM Wallets;