USE [master]
GO
/****** Object:  Database [CoffeeManagement]    Script Date: 1/5/2025 9:52:44 AM ******/
CREATE DATABASE [CoffeeManagement]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CoffeeManagement', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\CoffeeManagement.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CoffeeManagement_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\CoffeeManagement_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [CoffeeManagement] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CoffeeManagement].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CoffeeManagement] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ARITHABORT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [CoffeeManagement] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CoffeeManagement] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CoffeeManagement] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CoffeeManagement] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CoffeeManagement] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CoffeeManagement] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CoffeeManagement] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CoffeeManagement] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CoffeeManagement] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CoffeeManagement] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CoffeeManagement] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CoffeeManagement] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CoffeeManagement] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CoffeeManagement] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CoffeeManagement] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CoffeeManagement] SET  MULTI_USER 
GO
ALTER DATABASE [CoffeeManagement] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CoffeeManagement] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CoffeeManagement] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CoffeeManagement] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CoffeeManagement] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CoffeeManagement] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [CoffeeManagement] SET QUERY_STORE = ON
GO
ALTER DATABASE [CoffeeManagement] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [CoffeeManagement]
GO
/****** Object:  UserDefinedFunction [dbo].[F_VietnameseWithoutAccents]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[F_VietnameseWithoutAccents](@str NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF (@str IS NULL OR @str = '')  RETURN ''

    DECLARE @signChars NCHAR(256)
    DECLARE @unsignChars NCHAR (256)

    SET @signChars = N'áàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ' + NCHAR(272) + NCHAR(208)
    SET @unsignChars = N'aaaaaaaaaaaaaaaaadeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyAAAAAAAAAAAAAAAAADEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYDD'

    DECLARE @count INT = 1
    DECLARE @count1 INT

    WHILE (@count <= LEN(@str))
    BEGIN  
        SET @count1 = 1
        WHILE (@count1 <= LEN(@signChars) + 1)
        BEGIN
            IF UNICODE(SUBSTRING(@signChars, @count1, 1)) = UNICODE(SUBSTRING(@str, @count, 1))
            BEGIN          
                IF @count = 1
                    SET @str = SUBSTRING(@unsignChars, @count1, 1) + SUBSTRING(@str, @count + 1, LEN(@str) - 1)      
                ELSE
                    SET @str = SUBSTRING(@str, 1, @count - 1) + SUBSTRING(@unsignChars, @count1, 1) + SUBSTRING(@str, @count + 1, LEN(@str) - @count)
                BREAK
            END
            SET @count1 = @count1 + 1
        END
        SET @count = @count + 1
    END
    RETURN @str
END

GO
/****** Object:  Table [dbo].[Account]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[Username] [nvarchar](50) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Access] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[IdBill] [int] IDENTITY(1,1) NOT NULL,
	[DateCheckInBill] [datetime] NOT NULL,
	[DateCheckOutBill] [datetime] NULL,
	[StatusBill] [bit] NOT NULL,
	[Discount] [int] NOT NULL,
	[TotalPrice] [float] NOT NULL,
	[IdTable] [int] NOT NULL,
 CONSTRAINT [PK__Bill__24A2D64D8CB9ECB2] PRIMARY KEY CLUSTERED 
(
	[IdBill] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillInfo]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfo](
	[IdBillInfo] [int] IDENTITY(1,1) NOT NULL,
	[IdBill] [int] NOT NULL,
	[IdDrink] [int] NOT NULL,
	[Amount] [int] NOT NULL,
	[Note] [nvarchar](150) NULL,
 CONSTRAINT [PK__BillInfo__0041B4F73598744D] PRIMARY KEY CLUSTERED 
(
	[IdBillInfo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[IdCategory] [int] IDENTITY(1,1) NOT NULL,
	[NameCategory] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCategory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Drink]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drink](
	[IdDrink] [int] IDENTITY(1,1) NOT NULL,
	[NameDrink] [nvarchar](100) NOT NULL,
	[PriceDrink] [float] NOT NULL,
	[IdCategory] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdDrink] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TableFood]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableFood](
	[IdTable] [int] IDENTITY(1,1) NOT NULL,
	[NameTable] [nvarchar](100) NOT NULL,
	[StatusTable] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdTable] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Account] ([Username], [DisplayName], [Password], [Access]) VALUES (N'NV1', N'Nguyễn Văn A', N'1', N'Staff')
INSERT [dbo].[Account] ([Username], [DisplayName], [Password], [Access]) VALUES (N'thienhuy', N'Thiên Huy', N'1', N'Admin')
GO
SET IDENTITY_INSERT [dbo].[Bill] ON 

INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (1, CAST(N'2021-07-26T00:00:00.000' AS DateTime), CAST(N'2024-12-15T00:00:00.000' AS DateTime), 1, 20, 49600, 1)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (2, CAST(N'2021-07-26T00:00:00.000' AS DateTime), CAST(N'2021-07-26T00:00:00.000' AS DateTime), 1, 0, 56000, 2)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (3, CAST(N'2021-07-27T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 10, 38700, 3)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (4, CAST(N'2021-07-26T00:00:00.000' AS DateTime), CAST(N'2021-07-26T00:00:00.000' AS DateTime), 1, 0, 133000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (5, CAST(N'2021-07-28T00:00:00.000' AS DateTime), CAST(N'2024-12-16T00:00:00.000' AS DateTime), 1, 0, 70000, 5)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (6, CAST(N'2024-12-15T00:00:00.000' AS DateTime), CAST(N'2024-12-16T00:00:00.000' AS DateTime), 1, 0, 55000, 1)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (7, CAST(N'2024-12-15T00:00:00.000' AS DateTime), NULL, 0, 0, 0, 2)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (8, CAST(N'2024-12-15T00:00:00.000' AS DateTime), CAST(N'2024-12-16T00:00:00.000' AS DateTime), 1, 0, 85000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (9, CAST(N'2024-12-16T00:00:00.000' AS DateTime), CAST(N'2024-12-16T00:00:00.000' AS DateTime), 1, 0, 20000, 7)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (10, CAST(N'2024-12-16T00:00:00.000' AS DateTime), CAST(N'2024-12-16T00:00:00.000' AS DateTime), 1, 0, 12000, 1)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (11, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 58000, 1)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (12, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 10, 70200, 1)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (13, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 5, 47500, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (14, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 5, 64600, 3)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (15, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 5, 59850, 6)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (16, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 65000, 8)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (17, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 25000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (18, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 25000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (19, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 25000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (20, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 68000, 8)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (21, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 1, 42570, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (22, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 37000, 12)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (23, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 50000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (24, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 43000, 11)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (25, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 68000, 7)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (26, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 30000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (27, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 25000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (28, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 52000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (29, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 52000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (30, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 40000, 6)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (31, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 40000, 7)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (32, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 43000, 8)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (33, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 50000, 8)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (34, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 43000, 9)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (35, CAST(N'2024-12-25T00:00:00.000' AS DateTime), CAST(N'2024-12-25T00:00:00.000' AS DateTime), 1, 0, 55000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (36, CAST(N'2024-12-26T00:00:00.000' AS DateTime), CAST(N'2024-12-26T00:00:00.000' AS DateTime), 1, 0, 60000, 6)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (37, CAST(N'2024-12-26T00:00:00.000' AS DateTime), CAST(N'2024-12-26T00:00:00.000' AS DateTime), 1, 0, 82000, 5)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (38, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 54900, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (39, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 5, 40850, 8)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (40, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 49500, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (41, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 54000, 6)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (42, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 49500, 7)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (43, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 70200, 7)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (44, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 40500, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (45, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 51300, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (46, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 5, 69350, 5)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (47, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 63000, 6)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (48, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 63000, 6)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (49, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 63000, 6)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (50, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 0, 105000, 6)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (51, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 54000, 7)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (52, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 10, 63000, 12)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (53, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-28T00:00:00.000' AS DateTime), 1, 5, 77900, 7)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (54, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2024-12-30T11:11:57.883' AS DateTime), 1, 10, 81000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (55, CAST(N'2024-12-28T00:00:00.000' AS DateTime), CAST(N'2025-01-05T08:28:34.250' AS DateTime), 1, 0, 25000, 7)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (56, CAST(N'2024-12-28T20:23:57.540' AS DateTime), CAST(N'2024-12-28T20:24:19.293' AS DateTime), 1, 0, 18000, 6)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (57, CAST(N'2024-12-28T20:25:10.073' AS DateTime), CAST(N'2024-12-28T20:25:25.107' AS DateTime), 1, 5, 50350, 1)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (58, CAST(N'2024-12-28T20:26:04.687' AS DateTime), CAST(N'2024-12-28T20:26:21.610' AS DateTime), 1, 10, 45000, 1)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (59, CAST(N'2024-12-30T11:11:15.510' AS DateTime), CAST(N'2024-12-30T11:49:06.370' AS DateTime), 1, 0, 25000, 3)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (60, CAST(N'2024-12-30T11:42:40.633' AS DateTime), CAST(N'2024-12-30T11:45:45.010' AS DateTime), 1, 0, 25000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (61, CAST(N'2025-01-05T08:28:58.823' AS DateTime), CAST(N'2025-01-05T08:30:23.203' AS DateTime), 1, 0, 55000, 3)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (62, CAST(N'2025-01-05T08:31:57.900' AS DateTime), CAST(N'2025-01-05T08:38:55.720' AS DateTime), 1, 0, 35000, 4)
INSERT [dbo].[Bill] ([IdBill], [DateCheckInBill], [DateCheckOutBill], [StatusBill], [Discount], [TotalPrice], [IdTable]) VALUES (63, CAST(N'2025-01-05T09:34:54.957' AS DateTime), CAST(N'2025-01-05T09:42:53.917' AS DateTime), 1, 0, 25000, 1)
SET IDENTITY_INSERT [dbo].[Bill] OFF
GO
SET IDENTITY_INSERT [dbo].[BillInfo] ON 

INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (1, 1, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (2, 1, 3, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (3, 1, 8, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (4, 2, 12, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (5, 2, 1, 2, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (6, 9, 14, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (7, 4, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (8, 4, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (9, 4, 6, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (10, 4, 8, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (11, 4, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (12, 5, 10, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (13, 5, 9, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (14, 5, 7, 2, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (15, 8, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (16, 8, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (17, 8, 8, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (18, 6, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (19, 6, 4, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (20, 3, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (21, 3, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (22, 10, 3, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (23, 11, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (24, 11, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (25, 11, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (26, 12, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (27, 12, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (28, 12, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (29, 13, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (30, 13, 10, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (31, 13, 19, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (32, 14, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (33, 14, 12, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (34, 14, 16, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (35, 15, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (36, 15, 6, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (37, 15, 7, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (38, 16, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (39, 16, 15, 2, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (40, 17, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (41, 18, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (42, 19, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (43, 20, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (44, 20, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (45, 20, 12, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (46, 20, 19, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (47, 21, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (48, 21, 8, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (49, 22, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (50, 22, 13, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (51, 23, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (52, 23, 16, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (53, 24, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (54, 24, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (55, 25, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (56, 25, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (57, 25, 8, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (58, 26, 4, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (59, 27, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (60, 28, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (61, 28, 3, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (62, 28, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (63, 29, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (64, 29, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (65, 29, 13, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (66, 30, 19, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (67, 30, 6, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (68, 31, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (69, 31, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (70, 32, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (71, 32, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (72, 33, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (73, 33, 8, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (74, 34, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (75, 34, 20, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (76, 35, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (77, 35, 3, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (78, 35, 12, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (79, 36, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (80, 36, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (81, 36, 14, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (82, 37, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (83, 37, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (84, 37, 13, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (85, 37, 4, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (86, 38, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (87, 38, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (88, 38, 12, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (89, 39, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (90, 39, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (91, 40, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (92, 40, 12, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (93, 40, 13, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (94, 41, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (95, 41, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (96, 41, 18, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (97, 42, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (98, 42, 13, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (99, 42, 8, 1, NULL)
GO
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (100, 43, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (101, 43, 12, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (102, 43, 4, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (103, 43, 7, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (104, 44, 8, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (105, 44, 18, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (106, 44, 19, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (107, 45, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (108, 45, 18, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (109, 45, 19, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (110, 45, 13, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (111, 46, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (112, 46, 2, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (113, 46, 4, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (114, 47, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (115, 47, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (116, 47, 14, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (117, 47, 18, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (118, 48, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (119, 48, 18, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (120, 48, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (121, 49, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (122, 49, 18, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (123, 49, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (124, 50, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (125, 50, 18, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (130, 50, 5, 2, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (131, 51, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (132, 51, 18, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (133, 51, 8, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (134, 52, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (135, 52, 18, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (136, 52, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (137, 53, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (138, 53, 10, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (139, 53, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (146, 56, 12, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (147, 57, 12, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (148, 57, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (149, 58, 11, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (150, 58, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (151, 54, 5, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (152, 54, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (154, 54, 4, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (155, 60, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (156, 59, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (157, 55, 1, 1, NULL)
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (158, 61, 1, 1, N'ít đá')
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (159, 61, 11, 2, N'1 ly không đường')
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (160, 62, 14, 1, N'1 ly không đường')
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (161, 62, 7, 1, N'không đường')
INSERT [dbo].[BillInfo] ([IdBillInfo], [IdBill], [IdDrink], [Amount], [Note]) VALUES (162, 63, 1, 1, N'')
SET IDENTITY_INSERT [dbo].[BillInfo] OFF
GO
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([IdCategory], [NameCategory]) VALUES (1, N'Cà phê máy')
INSERT [dbo].[Category] ([IdCategory], [NameCategory]) VALUES (2, N'Nước ép')
INSERT [dbo].[Category] ([IdCategory], [NameCategory]) VALUES (3, N'Sinh tố hoa quả')
INSERT [dbo].[Category] ([IdCategory], [NameCategory]) VALUES (4, N'Cà phê')
INSERT [dbo].[Category] ([IdCategory], [NameCategory]) VALUES (5, N'Sữa chua')
INSERT [dbo].[Category] ([IdCategory], [NameCategory]) VALUES (6, N'Trà sữa')
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
SET IDENTITY_INSERT [dbo].[Drink] ON 

INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (1, N'Cappuccino', 25000, 1)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (2, N'Espresso', 18000, 1)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (3, N'Americano', 12000, 1)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (4, N'Nước ép táo', 30000, 2)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (5, N'Nước ép dâu', 35000, 2)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (6, N'Nước ép lựu', 30000, 2)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (7, N'Nước ép cam', 15000, 2)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (8, N'Sinh tố bơ', 25000, 3)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (9, N'Sinh tố dừa', 18000, 3)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (10, N'Sinh tố xoài', 22000, 3)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (11, N'Cà phê đen', 15000, 4)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (12, N'Cà phê sữa', 18000, 4)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (13, N'Cà phê sữa tươi', 12000, 4)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (14, N'Sữa chua cà phê', 20000, 5)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (15, N'Sữa chua cacao', 20000, 5)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (16, N'Sữa chua cam', 25000, 5)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (17, N'Sữa chua dâu', 25000, 5)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (18, N'Trà sữa truyền thống', 10000, 6)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (19, N'Trà sữa matcha', 10000, 6)
INSERT [dbo].[Drink] ([IdDrink], [NameDrink], [PriceDrink], [IdCategory]) VALUES (20, N'Trà sữa đào', 18000, 6)
SET IDENTITY_INSERT [dbo].[Drink] OFF
GO
SET IDENTITY_INSERT [dbo].[TableFood] ON 

INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (1, N'Bàn 0', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (2, N'Bàn 1', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (3, N'Bàn 2', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (4, N'Bàn 3', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (5, N'Bàn 4', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (6, N'Bàn 5', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (7, N'Bàn 6', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (8, N'Bàn 7', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (9, N'Bàn 8', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (10, N'Bàn 9', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (11, N'Bàn 10', N'Trống')
INSERT [dbo].[TableFood] ([IdTable], [NameTable], [StatusTable]) VALUES (12, N'Bàn 11', N'Trống')
SET IDENTITY_INSERT [dbo].[TableFood] OFF
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT (N'Nhân viên') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((0)) FOR [Password]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT (N'Staff') FOR [Access]
GO
ALTER TABLE [dbo].[Bill] ADD  CONSTRAINT [DF__Bill__DateCheckI__47DBAE45]  DEFAULT (getdate()) FOR [DateCheckInBill]
GO
ALTER TABLE [dbo].[Bill] ADD  CONSTRAINT [DF__Bill__StatusBill__48CFD27E]  DEFAULT ((0)) FOR [StatusBill]
GO
ALTER TABLE [dbo].[Bill] ADD  CONSTRAINT [DF__Bill__Discount__49C3F6B7]  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[Bill] ADD  CONSTRAINT [DF__Bill__TotalPrice__4AB81AF0]  DEFAULT ((0)) FOR [TotalPrice]
GO
ALTER TABLE [dbo].[BillInfo] ADD  CONSTRAINT [DF__BillInfo__Amount__4E88ABD4]  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[Category] ADD  DEFAULT (N'Chưa đặt tên') FOR [NameCategory]
GO
ALTER TABLE [dbo].[Drink] ADD  DEFAULT (N'Chưa đặt tên') FOR [NameDrink]
GO
ALTER TABLE [dbo].[Drink] ADD  DEFAULT ((0)) FOR [PriceDrink]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Bàn chưa có tên') FOR [NameTable]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Trống') FOR [StatusTable]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [FK__Bill__IdTable__4BAC3F29] FOREIGN KEY([IdTable])
REFERENCES [dbo].[TableFood] ([IdTable])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [FK__Bill__IdTable__4BAC3F29]
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD  CONSTRAINT [FK__BillInfo__Amount__4F7CD00D] FOREIGN KEY([IdBill])
REFERENCES [dbo].[Bill] ([IdBill])
GO
ALTER TABLE [dbo].[BillInfo] CHECK CONSTRAINT [FK__BillInfo__Amount__4F7CD00D]
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD  CONSTRAINT [FK__BillInfo__IdDrin__5070F446] FOREIGN KEY([IdDrink])
REFERENCES [dbo].[Drink] ([IdDrink])
GO
ALTER TABLE [dbo].[BillInfo] CHECK CONSTRAINT [FK__BillInfo__IdDrin__5070F446]
GO
ALTER TABLE [dbo].[Drink]  WITH CHECK ADD FOREIGN KEY([IdCategory])
REFERENCES [dbo].[Category] ([IdCategory])
GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteAccount]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_DeleteAccount]
@username NVARCHAR(50)
AS
BEGIN
	DELETE Account
	WHERE Username = @username
END

GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteCategory]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_DeleteCategory]
@idCategory INT
AS
BEGIN
	DELETE Drink
	WHERE IdCategory = @idCategory

	DELETE Category
	WHERE IdCategory = @idCategory
END

GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteDrink]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_DeleteDrink]
@idDrink INT
AS
BEGIN
	DELETE Drink
	WHERE IdDrink = @idDrink
END

GO
/****** Object:  StoredProcedure [dbo].[SP_DeleteTable]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_DeleteTable]
@idTable INT
AS
BEGIN
	DELETE TableFood
	WHERE IdTable = @idTable
END

GO
/****** Object:  StoredProcedure [dbo].[SP_EditAccount]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_EditAccount]
@username NVARCHAR(50),
@displayName NVARCHAR(100),
@access NVARCHAR(100)
AS
BEGIN
	UPDATE Account
	SET DisplayName = @displayName, Access = @access
	WHERE Username = @username
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAccount]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_GetAccount]
AS
BEGIN
	SELECT Username AS [Tên tài khoản], DisplayName AS [Tên hiển thị], Access AS [Quyền truy cập]
	FROM Account
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetAccountByUsername]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_GetAccountByUsername]
@username NVARCHAR(50)
AS
BEGIN
	SELECT Username, DisplayName, Password, Access
	FROM Account
	WHERE Username = @username
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetBillByDateAndPage]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_GetBillByDateAndPage]
@checkIn DATE, 
@checkOut DATE, 
@page INT
AS 
BEGIN
	DECLARE @pageRows INT = 10
	DECLARE @selectRows INT = @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows;
	
	WITH BillShow 
	AS 
	(
		SELECT Bill.IdBill AS [ID], NameTable AS [Tên bàn], DateCheckInBill AS [Ngày vào], DateCheckOutBill AS [Ngày ra], Discount AS [Giảm giá], TotalPrice AS [Tổng tiền]
		FROM Bill, TableFood
		WHERE DateCheckInBill >= @checkIn AND DateCheckInBill <= @checkOut 
		AND StatusBill = 1 AND Bill.IdTable = TableFood.IdTable
	)
	
	SELECT TOP (@selectRows) * 
	FROM BillShow 
	WHERE ID NOT IN 
	(
		SELECT TOP (@exceptRows) ID 
		FROM BillShow
	)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetBillDetailsByIdBill]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetBillDetailsByIdBill]
    @idBill INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        D.NameDrink,
        D.PriceDrink,
        BI.Amount,
        (D.PriceDrink * BI.Amount) AS TotalPrice
    FROM 
        BillInfo BI
    INNER JOIN 
        Drink D ON BI.IdDrink = D.IdDrink
    WHERE 
        BI.IdBill = @idBill;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetBillInfoByIdBill]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetBillInfoByIdBill]
    @idBill INT
AS
BEGIN
    SELECT 
        BillInfo.IdDrink, -- Thêm cột IdDrink
        NameDrink AS [Tên món], 
        PriceDrink AS [Giá], 
        Amount AS [Số lượng], 
        PriceDrink * Amount AS [Thành tiền],
		BillInfo.Note AS [Ghi chú]
    FROM 
        Drink, Bill, BillInfo
    WHERE 
        Drink.IdDrink = BillInfo.IdDrink
        AND BillInfo.IdBill = Bill.IdBill
        AND Bill.IdBill = @idBill
        AND Bill.StatusBill = 0
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDrinkByIdCategory]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_GetDrinkByIdCategory]
@idCategory INT
AS
BEGIN
	SELECT *
	FROM Drink
	WHERE Drink.IdCategory = @idCategory
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetListBillByDate]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_GetListBillByDate]
@dateCheckIn DATE,
@dateCheckOut DATE
AS
BEGIN
    SELECT Bill.IdBill AS [ID],  -- Thêm cột ID vào SELECT
           TableFood.NameTable AS [Tên bàn], 
           Bill.DateCheckInBill AS [Ngày vào], 
           Bill.DateCheckOutBill AS [Ngày ra], 
           Bill.Discount AS [Giảm giá], 
           Bill.TotalPrice AS [Tổng tiền]
    FROM Bill
    JOIN TableFood ON Bill.IdTable = TableFood.IdTable
    WHERE Bill.StatusBill = 1
    AND Bill.DateCheckInBill >= @dateCheckIn 
    AND Bill.DateCheckOutBill <= @dateCheckOut
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetMaxIDBill]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_GetMaxIDBill]
AS
BEGIN
	SELECT MAX(IdBill)
	FROM Bill
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetNumBillByDate]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_GetNumBillByDate]
@checkIn DATE, 
@checkOut DATE
AS 
BEGIN
	SELECT COUNT(*)
	FROM Bill, TableFood
	WHERE DateCheckInBill >= @checkIn AND DateCheckInBill <= @checkOut 
	AND StatusBill = 1 
	AND Bill.IdTable = TableFood.IdTable
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GetUncheckBillIDByTableID]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_GetUncheckBillIDByTableID]
@idTable INT
AS
BEGIN
	SELECT *
	FROM Bill
	WHERE IdTable = @idTable
	AND StatusBill = 0
END

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertAccount]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_InsertAccount]
@username NVARCHAR(50),
@displayName NVARCHAR(100),
@access NVARCHAR(100)
AS
BEGIN
	INSERT INTO Account
	VALUES (@username, @displayName, N'cafe31', @access)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertBill]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_InsertBill]
@idTable INT
AS
BEGIN
	INSERT INTO Bill
	VALUES (GETDATE(), NULL, 0, 0, 0, @idTable)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertBillInfo]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_InsertBillInfo]
    @idBill INT,
    @idDrink INT,
    @amount INT,
    @note NVARCHAR(150)
AS
BEGIN
    DECLARE @isExistBillInfo INT = 0
    DECLARE @drinkAmount INT = 1

    -- Kiểm tra nếu tồn tại BillInfo cho IdBill và IdDrink
    SELECT @isExistBillInfo = IdBill, @drinkAmount = Amount
    FROM BillInfo 
    WHERE IdBill = @idBill AND IdDrink = @idDrink

    IF (@isExistBillInfo > 0)
    BEGIN
        -- Tính số lượng mới
        DECLARE @newAmount INT = @drinkAmount + @amount

        IF (@newAmount > 0)
            -- Cập nhật số lượng và ghi chú nếu số lượng mới lớn hơn 0
            UPDATE BillInfo 
            SET Amount = @newAmount, Note = @note 
            WHERE IdBill = @isExistBillInfo AND IdDrink = @idDrink
        ELSE
            -- Xóa nếu số lượng mới <= 0
            DELETE BillInfo 
            WHERE IdBill = @idBill AND IdDrink = @idDrink
    END
    ELSE
    BEGIN
        -- Thêm mới nếu chưa tồn tại
        INSERT INTO BillInfo (IdBill, IdDrink, Amount, Note)
        VALUES (@idBill, @idDrink, @amount, @note)
    END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertCategory]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_InsertCategory]
@nameCategory NVARCHAR(100)
AS
BEGIN
	INSERT INTO Category
	VALUES (@nameCategory)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertDrink]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_InsertDrink]
@nameDrink NVARCHAR(100),
@priceDrink FLOAT,
@idCategory INT
AS
BEGIN
	INSERT INTO Drink 
	VALUES (@nameDrink, @priceDrink, @idCategory)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_InsertTable]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_InsertTable]
@nameTable NVARCHAR(100)
AS
BEGIN
	INSERT INTO TableFood
	VALUES (@nameTable, N'Trống')
END

GO
/****** Object:  StoredProcedure [dbo].[SP_IsAdminLogin]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_IsAdminLogin]
@username NVARCHAR(50),	
@password VARCHAR(50)
AS
BEGIN
	SELECT COUNT(Username)
	FROM Account
	WHERE Username = @username 
	AND Password = @password
	AND Access = N'Admin'
END

GO
/****** Object:  StoredProcedure [dbo].[SP_IsLogin]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored procendure
CREATE PROC [dbo].[SP_IsLogin]
@username NVARCHAR(50),	
@password VARCHAR(50)
AS
BEGIN
	SELECT COUNT(Username)
	FROM Account
	WHERE Username = @username 
	AND Password = @password
END

GO
/****** Object:  StoredProcedure [dbo].[SP_MergeTable]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_MergeTable]
@idTable1 INT, 
@idTable2 INT
AS
BEGIN
	DECLARE @idFirstBill INT
	DECLARE @idSecondBill INT
	
	SELECT @idFirstBill = IdBill FROM Bill WHERE IdTable = @idTable1 AND StatusBill = 0
	SELECT @idSecondBill = IdBill FROM Bill WHERE IdTable = @idTable2 AND StatusBill = 0
	
	IF (@idFirstBill IS NULL)
	BEGIN
		INSERT Bill VALUES (GETDATE(), NULL, 0, 0, 0, @idTable1)
		SELECT @idFirstBill = MAX(IdBill) FROM Bill WHERE IdTable = @idTable1 AND StatusBill = 0
	END
	
	IF (@idSecondBill IS NULL)
	BEGIN
		INSERT Bill VALUES (GETDATE(), NULL, 0, 0, 0, @idTable2)
		SELECT @idSecondBill = MAX(IdBill) FROM Bill WHERE IdTable = @idTable2 AND StatusBill = 0	
	END

	UPDATE BillInfo SET IdBill = @idSecondBill WHERE IdBill = @idFirstBill
	
	DECLARE @isSecondTableEmpty INT = 0
	SELECT @isSecondTableEmpty = COUNT(*) FROM BillInfo WHERE IdBill = @idSecondBill
		
	UPDATE TableFood SET StatusTable = N'Trống' WHERE IdTable = @idTable1

	IF (@isSecondTableEmpty = 0)
		UPDATE TableFood SET StatusTable = N'Trống' WHERE IdTable = @idTable2
	ELSE 
		UPDATE TableFood SET StatusTable = N'Có người' WHERE IdTable = @idTable2
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Payment]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_Payment]
@idBill INT,
@discount INT,
@totalPrice FLOAT
AS
BEGIN
	UPDATE Bill 
	SET DateCheckOutBill = GETDATE(), StatusBill = 1, Discount = @discount, TotalPrice = @totalPrice
	WHERE IdBill = @idBill
END

GO
/****** Object:  StoredProcedure [dbo].[SP_ResetPassword]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_ResetPassword]
@username NVARCHAR(50)
AS
BEGIN
	UPDATE Account
	SET Password = N'1'
	WHERE Username = @username
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SearchAccount]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_SearchAccount]
@keyword NVARCHAR(100)
AS
BEGIN
	SELECT @keyword = dbo.F_VietnameseWithoutAccents(@keyword);
	SET @keyword = CONCAT(N'%', @keyword, N'%')

	SELECT *
	FROM Account
	WHERE dbo.F_VietnameseWithoutAccents(Username) LIKE @keyword
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SearchCategory]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_SearchCategory]
@keyword NVARCHAR(100)
AS
BEGIN
	SELECT @keyword = dbo.F_VietnameseWithoutAccents(@keyword);
	SET @keyword = CONCAT(N'%', @keyword, N'%')

	SELECT *
	FROM Category
	WHERE dbo.F_VietnameseWithoutAccents(NameCategory) LIKE @keyword
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SearchDrink]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_SearchDrink]
@keyword NVARCHAR(100)
AS
BEGIN
	SELECT @keyword = dbo.F_VietnameseWithoutAccents(@keyword);
	SET @keyword = CONCAT(N'%', @keyword, N'%')

	SELECT *
	FROM Drink
	WHERE dbo.F_VietnameseWithoutAccents(NameDrink) LIKE @keyword
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SearchTable]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_SearchTable]
@keyword NVARCHAR(100)
AS
BEGIN
	SELECT @keyword = dbo.F_VietnameseWithoutAccents(@keyword);
	SET @keyword = CONCAT(N'%', @keyword, N'%')

	SELECT *
	FROM TableFood
	WHERE dbo.F_VietnameseWithoutAccents(NameTable) LIKE @keyword
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SwitchTabel]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_SwitchTabel]
@idTable1 INT, 
@idTable2 INT
AS
BEGIN
	DECLARE @idFirstBill INT
	DECLARE @idSecondBill INT
	
	DECLARE @isFirstTableEmpty INT = 1
	DECLARE @isSecondTableEmpty INT = 1
	
	SELECT @idFirstBill = IdBill FROM Bill WHERE IdTable = @idTable1 AND StatusBill = 0
	SELECT @idSecondBill = IdBill FROM Bill WHERE IdTable = @idTable2 AND StatusBill = 0
	
	IF (@idFirstBill IS NULL)
	BEGIN
		INSERT Bill VALUES (GETDATE(), NULL, 0, 0, 0, @idTable1)
		SELECT @idFirstBill = MAX(IdBill) FROM Bill WHERE IdTable = @idTable1 AND StatusBill = 0
	END
	SELECT @isFirstTableEmpty = COUNT(*) FROM BillInfo WHERE IdBill = @idFirstBill
	
	IF (@idSecondBill IS NULL)
	BEGIN
		INSERT Bill VALUES (GETDATE(), NULL, 0, 0, 0, @idTable2)
		SELECT @idSecondBill = MAX(IdBill) FROM Bill WHERE IdTable = @idTable2 AND StatusBill = 0	
	END
	SELECT @isSecondTableEmpty = COUNT(*) FROM BillInfo WHERE IdBill = @idSecondBill

	SELECT IdBillInfo INTO IDBillInfoTable FROM BillInfo WHERE IdBill = @idSecondBill
	
	UPDATE BillInfo SET IdBill = @idSecondBill WHERE IdBill = @idFirstBill
	UPDATE BillInfo SET IdBill = @idFirstBill WHERE IdBillInfo IN (SELECT * FROM IDBillInfoTable)
	
	DROP TABLE IDBillInfoTable
	
	IF (@isFirstTableEmpty = 0)
		UPDATE TableFood SET StatusTable = N'Trống' WHERE IdTable = @idTable2
		
	IF (@isSecondTableEmpty = 0)
		UPDATE TableFood SET StatusTable = N'Trống' WHERE IdTable = @idTable1
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateAccount]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_UpdateAccount]
@userName NVARCHAR(50), 
@displayName NVARCHAR(100), 
@password NVARCHAR(50), 
@newPassword NVARCHAR(50)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	SELECT @isRightPass = COUNT(*) FROM dbo.Account WHERE Username = @userName AND Password = @password
	
	IF (@isRightPass = 1)
	BEGIN
		IF (@newPassword = NULL OR @newPassword = '')
			UPDATE dbo.Account SET DisplayName = @displayName WHERE UserName = @userName
		ELSE
			UPDATE dbo.Account SET DisplayName = @displayName, Password = @newPassword WHERE UserName = @userName
	END
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateCategory]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_UpdateCategory]
@idCategory INT,
@nameCategory NVARCHAR(100)
AS
BEGIN
	UPDATE Category
	SET NameCategory = @nameCategory
	WHERE IdCategory = @idCategory
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateDrink]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_UpdateDrink]
@idDrink INT,
@nameDrink NVARCHAR(100),
@priceDrink FLOAT,
@idCategory INT
AS
BEGIN
	UPDATE Drink
	SET NameDrink = @nameDrink, PriceDrink = @priceDrink, IdCategory = @idCategory
	WHERE IdDrink = @idDrink
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateTable]    Script Date: 1/5/2025 9:52:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_UpdateTable]
@idTable INT,
@nameTable NVARCHAR(100)
AS
BEGIN
	UPDATE TableFood
	SET NameTable = @nameTable
	WHERE IdTable = @idTable
END

GO
USE [master]
GO
ALTER DATABASE [CoffeeManagement] SET  READ_WRITE 
GO
