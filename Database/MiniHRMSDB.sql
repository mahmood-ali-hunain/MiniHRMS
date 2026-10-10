-- Create the database if it does not exist.
IF DB_ID('MiniHRMSDB') IS NULL
    CREATE DATABASE MiniHRMSDB;
GO

USE MiniHRMSDB;
GO

-- Create the employee table if it does not exist.
IF OBJECT_ID('dbo.Employees', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Employees
    (
        EmployeeID   INT IDENTITY(1,1) PRIMARY KEY,
        FullName     NVARCHAR(100)  NOT NULL,
        Email        NVARCHAR(150)  NOT NULL UNIQUE,
        Department   NVARCHAR(50)   NOT NULL,
        Designation  NVARCHAR(100)  NOT NULL,
        Salary       DECIMAL(10,2)  NOT NULL,
        JoiningDate  DATE           NOT NULL
    );
END
GO

-- Return all employees, newest first.
CREATE OR ALTER PROCEDURE dbo.sp_GetAllEmployees
AS
BEGIN
    SET NOCOUNT ON;

    SELECT EmployeeID, FullName, Email, Department, Designation, Salary, JoiningDate
    FROM dbo.Employees
    ORDER BY EmployeeID DESC;
END
GO

-- Return one employee by ID.
CREATE OR ALTER PROCEDURE dbo.sp_GetEmployeeById
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT EmployeeID, FullName, Email, Department, Designation, Salary, JoiningDate
    FROM dbo.Employees
    WHERE EmployeeID = @EmployeeID;
END
GO

-- Add an employee.
CREATE OR ALTER PROCEDURE dbo.sp_InsertEmployee
    @FullName    NVARCHAR(100),
    @Email       NVARCHAR(150),
    @Department  NVARCHAR(50),
    @Designation NVARCHAR(100),
    @Salary      DECIMAL(10,2),
    @JoiningDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Employees (FullName, Email, Department, Designation, Salary, JoiningDate)
    VALUES (@FullName, @Email, @Department, @Designation, @Salary, @JoiningDate);
END
GO

-- Update an employee.
CREATE OR ALTER PROCEDURE dbo.sp_UpdateEmployee
    @EmployeeID  INT,
    @FullName    NVARCHAR(100),
    @Email       NVARCHAR(150),
    @Department  NVARCHAR(50),
    @Designation NVARCHAR(100),
    @Salary      DECIMAL(10,2),
    @JoiningDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Employees
    SET FullName    = @FullName,
        Email       = @Email,
        Department  = @Department,
        Designation = @Designation,
        Salary      = @Salary,
        JoiningDate = @JoiningDate
    WHERE EmployeeID = @EmployeeID;
END
GO

-- Delete an employee.
CREATE OR ALTER PROCEDURE dbo.sp_DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.Employees
    WHERE EmployeeID = @EmployeeID;
END
GO

-- Add sample employees when the table is empty.
IF NOT EXISTS (SELECT 1 FROM dbo.Employees)
BEGIN
    EXEC dbo.sp_InsertEmployee 'Hunain Ghauri', 'hunain.ghauri@example.com', 'HR',      'HR Executive',       85000, '2024-02-01';
    EXEC dbo.sp_InsertEmployee 'Bilal Ahmed', 'bilal.ahmed@example.com', 'IT',      'Software Developer', 120000, '2023-08-15';
    EXEC dbo.sp_InsertEmployee 'Sara Malik',  'sara.malik@example.com',  'Finance', 'Accountant',         95000, '2024-05-20';
END
GO
