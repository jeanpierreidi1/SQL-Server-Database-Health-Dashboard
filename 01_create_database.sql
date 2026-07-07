-- Create Database

CREATE DATABASE HealthDashboard_db;
GO
USE HealthDashboard_db;
GO

-- Create tables
CREATE TABLE Customers (
    CustomerID   INT IDENTITY PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email        VARCHAR(100),
    Region       VARCHAR(50),
    CreatedDate  DATETIME DEFAULT GETDATE()
);

CREATE TABLE Orders (
    OrderID      INT IDENTITY PRIMARY KEY,
    CustomerID   INT,
    OrderAmount  DECIMAL(10,2),
    OrderDate    DATETIME DEFAULT GETDATE(),
    Status       VARCHAR(20)
);

-- Insert data
INSERT INTO Customers (CustomerName, Email, Region)
VALUES
    ('Acme Corp',    'acme@corp.com',   'North'),
    ('Beta Ltd',     'beta@ltd.com',    'South'),
    ('Gamma Inc',    'gamma@inc.com',   'East'),
    ('Delta Co',     'delta@co.com',    'West'),
    ('Echo Systems', 'echo@sys.com',    'North'),
	('Acmi Corp',    'acmi@corp.com',   'North'),
    ('Beto Ltd',     'beto@ltd.com',    'South'),
    ('Gammi Inc',    'gammi@inc.com',   'East'),
    ('Delty Co',     'delty@co.com',    'West'),
    ('Eche Systems', 'eche@sys.com',    'North');

INSERT INTO Orders (CustomerID, OrderAmount, OrderDate, Status)
VALUES
    (1, 1500.00, GETDATE(), 'Completed'),
    (2, 2200.50, GETDATE(), 'Pending'),
    (3, 875.00,  GETDATE(), 'Completed'),
    (4, 3100.00, GETDATE(), 'Cancelled'),
    (5, 990.00,  GETDATE(), 'Completed'),
	(6, 1200.00, GETDATE(), 'Completed'),
    (7, 2100.50, GETDATE(), 'Pending'),
    (8, 815.00,  GETDATE(), 'Completed'),
    (9, 1700.00, GETDATE(), 'Cancelled'),
    (10, 390.00,  GETDATE(), 'Completed');
GO