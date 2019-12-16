USE master

CREATE DATABASE AdventureServices
ON PRIMARY
(NAME = AdventureServices_dat,
 FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureServices.mdf',
 SIZE=10MB,
 MAXSIZE=50MB,
 FILEGROWTH=5)
LOG ON
(NAME=AdventureServices_log,
 FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureServices.ldf',
 SIZE = 200MB,
 FILEGROWTH = 5MB);
GO 

USE AdventureServices
GO

ALTER DATABASE AdventureServices
COLLATE SQL_Latin1_General_CP1_CI_AS;  
GO  

ALTER DATABASE AdventureServices
ADD FILEGROUP FG_Admin;

ALTER DATABASE AdventureServices
ADD FILE
(NAME=AdventureServices_Monitor,
 FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sch_Admin.ndf',
 SIZE=11MB,
 MAXSIZE=23MB,
 FILEGROWTH=5)
TO FILEGROUP FG_Admin;
GO

ALTER DATABASE AdventureServices
ADD FILEGROUP FG_Customer;

ALTER DATABASE AdventureServices
ADD FILE
(NAME=AdventureServices_Customer,
 FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sch_Customer.ndf',
 SIZE=10MB,
 MAXSIZE=20MB,
 FILEGROWTH=5)
TO FILEGROUP FG_Customer;
GO

ALTER DATABASE AdventureServices
ADD FILEGROUP FG_Product;

ALTER DATABASE AdventureServices
ADD FILE
(NAME=AdventureServices_Product,
 FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sch_Product.ndf',
 SIZE=5MB,
 MAXSIZE=12MB,
 FILEGROWTH=5)
TO FILEGROUP FG_Product;
GO

ALTER DATABASE AdventureServices
ADD FILEGROUP FG_Sales;

ALTER DATABASE AdventureServices
ADD FILE
(NAME=AdventureServices_Sales,
 FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sch_Sales.ndf',
 SIZE=11MB,
 MAXSIZE=23MB,
 FILEGROWTH=5)
TO FILEGROUP FG_Sales;
GO

ALTER DATABASE AdventureServices
ADD FILEGROUP FG_Location;

ALTER DATABASE AdventureServices
ADD FILE
(NAME=AdventureServices_Location,
 FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sch_Location.ndf',
 SIZE=3MB,
 MAXSIZE=18MB,
 FILEGROWTH=5)
TO FILEGROUP FG_Location;
GO

ALTER DATABASE AdventureServices
ADD FILEGROUP FG_User;

ALTER DATABASE AdventureServices
ADD FILE
(NAME=AdventureServices_User,
 FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sch_User.ndf',
 SIZE=3MB,
 MAXSIZE=18MB,
 FILEGROWTH=5)
TO FILEGROUP FG_User;
GO

CREATE SCHEMA sch_Admin
GO

CREATE SCHEMA sch_Customer
GO

CREATE SCHEMA sch_Product
GO

CREATE SCHEMA sch_Sales
GO

CREATE SCHEMA sch_Location
GO

CREATE SCHEMA sch_User
GO


