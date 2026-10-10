# MiniHRMS

MiniHRMS is a simple ASP.NET Web Forms application for managing employee records.

## Open in Visual Studio
The project targets .NET Framework 4.8 and uses the ASP.NET Web Application project type. Install Visual Studio's **ASP.NET and web development** workload and the **.NET Framework 4.8 targeting pack**.

## Run locally
1. Clone or download this repository.
2. Open `MiniHRMS.sln` in Visual Studio.
3. Run `Database/MiniHRMSDB.sql` against your SQL Server instance using SQL Server Management Studio or Azure Data Studio.
4. Update the `MiniHRMSConnection` connection string in `Web.config` to point to that SQL Server instance.
5. Set `MiniHRMS` as the startup project if Visual Studio has not done so, then run with IIS Express.

The default connection string expects SQL Server Express at `localhost\SQLEXPRESS` and uses Windows authentication. Change the server name if your instance is different. The SQL script creates sample employees when the employee table is empty.

## Features
- Add a new employee
- Edit an existing employee
- Delete an employee
- View all employees in a GridView
- Store employee data in SQL Server using stored procedures

## Project Structure

MiniHRMS/
├── MiniHRMS.sln
├── MiniHRMS.csproj
├── Database/
│   └── MiniHRMSDB.sql
├── Default.aspx
├── Default.aspx.cs
├── Default.aspx.designer.cs
├── Web.config
├── Properties/
│   └── AssemblyInfo.cs
├── .gitignore
└── README.md

## Database Setup
The script creates the `MiniHRMSDB` database, employee table, stored procedures, and sample records when needed. Run it with an account that has permission to create databases. It uses `CREATE OR ALTER PROCEDURE`, supported by SQL Server 2016 SP1 and later.

## Configuration
The app uses the connection string named `MiniHRMSConnection` in `Web.config`:

```xml
<connectionStrings>
  <add name="MiniHRMSConnection"
       connectionString="Server=localhost\SQLEXPRESS;Database=MiniHRMSDB;Trusted_Connection=True;TrustServerCertificate=True;"
       providerName="System.Data.SqlClient" />
</connectionStrings>
```

Update the server name if your local SQL Server instance is different.

## Technologies
- ASP.NET Web Forms
- C#
- SQL Server
- ADO.NET
