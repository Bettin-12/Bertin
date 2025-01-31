-- Create Database
CREATE DATABASE HostelManagement;
USE HostelManagement;

-- Create Tables
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY,
    RoomType VARCHAR(50),
    Capacity INT,
    AvailableBeds INT
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address TEXT,
    RoomID INT,
    Status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    StudentID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

CREATE TABLE Campaigns (
    CampaignID INT PRIMARY KEY,
    Title VARCHAR(100),
    Description TEXT,
    StartDate DATE,
    EndDate DATE
);

-- Insert Sample Data
INSERT INTO Rooms VALUES (101, 'Single', 1, 0), (102, 'Double', 2, 1);
INSERT INTO Students VALUES (1, 'John Doe', 'john@example.com', '1234567890', '123 Main St', 101);
INSERT INTO Payments VALUES (1, 1, 5000, '2025-01-11', 'Paid');
INSERT INTO Campaigns VALUES (1, 'Clean Hostel Drive', 'A campaign to clean hostels', '2025-02-01', '2025-02-05');

-- Stored Procedure: Add Student
DELIMITER //
CREATE PROCEDURE AddStudent(IN name VARCHAR(100), IN email VARCHAR(100), IN phone VARCHAR(15), IN address TEXT, IN room_id INT)
BEGIN
    INSERT INTO Students (Name, Email, Phone, Address, RoomID) 
    VALUES (name, email, phone, address, room_id);
END;
//
DELIMITER ;

-- Stored Procedure: Record Payment
DELIMITER //
CREATE PROCEDURE RecordPayment(IN student_id INT, IN amount DECIMAL(10,2), IN payment_date DATE, IN status VARCHAR(50))
BEGIN
    INSERT INTO Payments (StudentID, Amount, PaymentDate, Status)
    VALUES (student_id, amount, payment_date, status);
    
    -- Update Student status to "Paid"
    UPDATE Students SET Status = 'Paid' WHERE StudentID = student_id;
END;
//
DELIMITER ;

-- Stored Procedure: Update Room Availability
DELIMITER //
CREATE PROCEDURE UpdateRoomAvailability(IN room_id INT, IN beds_available INT)
BEGIN
    UPDATE Rooms SET AvailableBeds = beds_available WHERE RoomID = room_id;
END;
//
DELIMITER ;

-- Create MySQL User
CREATE USER 'hostel_admin'@'localhost' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON HostelManagement.* TO 'hostel_admin'@'localhost';
FLUSH PRIVILEGES;

-- CRUD Operations
-- CREATE (Insert via Procedure)
CALL AddStudent('Jane Smith', 'jane@example.com', '0987654321', '456 Elm St', 102);

-- READ (Select)
SELECT * FROM Students;
SELECT * FROM Payments WHERE Status = 'Paid';

-- UPDATE (via Procedure)
CALL UpdateRoomAvailability(101, 1);

-- DELETE
DELETE FROM Students WHERE StudentID = 2;

-- Triggers
DELIMITER //
CREATE TRIGGER after_payment_insert
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    UPDATE Students SET Status = 'Paid' WHERE StudentID = NEW.StudentID;
END;
//
DELIMITER ;