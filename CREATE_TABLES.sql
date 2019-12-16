 USE AdventureServices;

 --------------------------------- Schema Primary  ------------------------------------------
 CREATE TABLE dbo.ErrorLog (
    ErrorID int NULL,
    Message varchar(255),
    [User] nvarchar(40) NULL,
    [Time] datetime NULL
) ON [PRIMARY]

CREATE TABLE sch_Admin.Monitor(
	TableName nvarchar(55) NULL,
	ColumnName nvarchar(55) NULL,
	TypeName varchar(55) NULL,
	MaxLength int NULL,
	Scale int NULL,
	IndexName varchar(55) NULL,
	Is_Identity bit NULL,
	Is_PrimaryKey bit NULL,	
	FKName varchar(55) NULL,
	Refers varchar(55) NULL,
	RefersColName varchar(55) NULL
)	ON FG_Admin

CREATE TABLE sch_Admin.MonitorSpaceUsage (
    TableName sysname,
    NumRows int,
    ReservedSpace NVARCHAR(55),
    DataSpace NVARCHAR(55),
    IndexSize NVARCHAR(55),
    UnusedSpace NVARCHAR(55),
) ON FG_Admin
--------------------------------- Schema Primary  -------------------------------------------

--------------------------------- Schema User  ----------------------------------------------
CREATE TABLE sch_User.Questions(
	QuestionKey INT IDENTITY(1,1) PRIMARY KEY,
	Question NVARCHAR(55) NOT NULL
) ON FG_User

CREATE TABLE sch_User.[User](
	UserKey INT IDENTITY(1,1) PRIMARY KEY,
	FirstName NVARCHAR(25) NOT NULL,
	LastName NVARCHAR(25) NOT NULL,
	EmailAddress NVARCHAR(55) NOT NULL,
	Password NVARCHAR(55) NOT NULL,
) ON FG_User

CREATE TABLE sch_User.AnsweredQuestions(
	AnsweredQuestionsKey INT IDENTITY(1,1) PRIMARY KEY,
	UserKey INT NOT NULL,
	QuestionKey INT NOT NULL,
	Answer NVARCHAR(55),

	FOREIGN KEY (UserKey) REFERENCES sch_User.[User](UserKey) ON DELETE CASCADE,
	FOREIGN KEY (QuestionKey) REFERENCES sch_User.Questions(QuestionKey) ON DELETE CASCADE
) ON FG_User

CREATE TABLE sch_User.sentEmails(
	sentEmailsKey INT IDENTITY(1,1) PRIMARY KEY,
	[Subject] NVARCHAR(55) NOT NULL,
	UserKey INT NOT NULL,

	FOREIGN KEY (UserKey) REFERENCES sch_User.[User](UserKey) ON DELETE CASCADE
) ON FG_User
--------------------------------- Schema User  --------------------------------------------

------------------------------------ Schema Product ---------------------------------------

CREATE TABLE sch_Product.ProductCategory(
    ProductCategoryKey INT IDENTITY(1,1) PRIMARY KEY,
    EnglishProductCategoryName NVARCHAR(55) NOT NULL,
    FrenchProductCategoryName NVARCHAR(55) NOT NULL,
    SpanishProductCategoryName NVARCHAR(55) NOT NULL
)ON FG_Product

CREATE TABLE sch_Product.ProductSubCategory(
    ProductSubCategoryKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductCategoryKey INT NOT NULL,
    EnglishProductSubCategoryName NVARCHAR(55) NOT NULL,
    FrenchProductSubCategoryName NVARCHAR(55) NOT NULL,
    SpanishProductSubCategoryName NVARCHAR(55) NOT NULL,

    FOREIGN KEY (ProductCategoryKey) REFERENCES sch_Product.ProductCategory(ProductCategoryKey) ON DELETE CASCADE
) ON FG_Product

CREATE TABLE sch_Product.Description(
    DescriptionKey INT IDENTITY(1,1) PRIMARY KEY,
    EnglishDescription NVARCHAR(1024) NOT NULL,
    FrenchDescription NVARCHAR(1024) NOT NULL
) ON FG_Product

CREATE TABLE sch_Product.Model(
    ModelKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductModelName NVARCHAR(55) NOT NULL
)  ON FG_Product

CREATE TABLE sch_Product.WeightUnitMeasureCode(
    WeightUnitMeasureCodeKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductWeightUnitMeasureCode NVARCHAR(55)
)  ON FG_Product

CREATE TABLE sch_Product.SizeUnitMeasure(
    SizeUnitMeasureKey INT IDENTITY(1,1) PRIMARY KEY ,
    SizeUnitMeasure NVARCHAR(55) NOT NULL
) ON FG_Product

CREATE TABLE sch_Product.ProductName(
    ProductNameKey INT IDENTITY(1,1) PRIMARY KEY ,
    EnglishProductName NVARCHAR(55) NOT NULL,
    SpanishProductName NVARCHAR(55) NULL,
    FrenchProductName NVARCHAR(55) NULL
)  ON FG_Product

CREATE TABLE sch_Product.Class(
    ClassKey  INT IDENTITY(1,1) PRIMARY KEY ,
    ClassName NVARCHAR(55) NOT NULL
) ON FG_Product

CREATE TABLE sch_Product.Style(
	StyleKey  INT IDENTITY(1,1) PRIMARY KEY,
	StyleName NVARCHAR(55) NOT NULL
) ON FG_Product

CREATE TABLE sch_Product.Color(
    ColorKey INT IDENTITY(1,1) PRIMARY KEY,
	Color NVARCHAR(55) NOT NULL
) ON FG_Product

CREATE TABLE sch_Product.ProductLine(
    ProductLineKey INT IDENTITY(1,1) PRIMARY KEY ,
    ProductLine NVARCHAR(55) NOT NULL
) ON FG_Product

CREATE TABLE sch_Product.Product(
    ProductKey INT IDENTITY(210,1) PRIMARY KEY,
    ProductSubCategoryKey INT NOT NULL,
    WeightUnitMeasureCodeKey INT NULL,
	SizeUnitMeasureKey INT NULL,
    ProductNameKey INT NOT NULL,
	ColorKey INT NOT NULL,
    StyleKey INT NULL,
    ClassKey INT NULL,
    DescriptionKey INT NOT NULL,
    ProductLineKey INT NULL,
	ModelKey INT NOT NULL,
    
	StandardCost NVARCHAR(25) NOT NULL,
	FinishedGoodsFlag bit NOT NULL,
	ListPrice NVARCHAR(64) NULL,
    Size NVARCHAR(55) NULL,
    SizeRange NVARCHAR(55) NOT NULL,
    Weight NVARCHAR(25) NULL,
    DaysToManufacture INT NOT NULL,
    DealerPrice nvarchar(64) NULL,
    Status NVARCHAR(25) NULL,

    FOREIGN KEY (ProductSubCategoryKey) REFERENCES sch_Product.ProductSubCategory(ProductSubCategoryKey) ON DELETE CASCADE,
    FOREIGN KEY (WeightUnitMeasureCodeKey) REFERENCES sch_Product.WeightUnitMeasureCode(WeightUnitMeasureCodeKey) ON DELETE CASCADE,
    FOREIGN KEY (SizeUnitMeasureKey) REFERENCES sch_Product.SizeUnitMeasure(SizeUnitMeasureKey) ON DELETE CASCADE,
    FOREIGN KEY (ProductNameKey) REFERENCES sch_Product.ProductName(ProductNameKey) ON DELETE CASCADE,
    FOREIGN KEY (ColorKey) REFERENCES sch_Product.Color(ColorKey) ON DELETE CASCADE,
    FOREIGN KEY (StyleKey) REFERENCES sch_Product.Style(StyleKey) ON DELETE CASCADE,
    FOREIGN KEY (ClassKey) REFERENCES sch_Product.Class(ClassKey) ON DELETE CASCADE,
    FOREIGN KEY (DescriptionKey) REFERENCES sch_Product.Description(DescriptionKey) ON DELETE CASCADE,
    FOREIGN KEY (ProductLineKey) REFERENCES sch_Product.ProductLine(ProductLineKey) ON DELETE CASCADE,
	FOREIGN KEY (ModelKey) REFERENCES sch_Product.Model(ModelKey) ON DELETE CASCADE
) ON FG_Product
----------------------------------------------------------- Schema Product  ----------------------------------------

------------------------------------------------- Schema Location --------------------------------------------------
CREATE TABLE sch_Location.SalesTerritoryCountry(
    SalesTerritoryCountryKey INT PRIMARY KEY IDENTITY(1,1),
    SalesTerritoryCountryName NVARCHAR(55) NOT NULL
) ON FG_Location

CREATE TABLE sch_Location.SalesTerritoryGroup(
    SalesTerritoryGroupKey INT PRIMARY KEY IDENTITY(1,1),
    SalesTerritoryGroupName NVARCHAR(55) NOT NULL
) ON FG_Location

CREATE TABLE sch_Location.SalesTerritory(
    SalesTerritoryKey INT PRIMARY KEY IDENTITY(1,1),
    SalesTerritoryCountryKey INT NOT NULL,
    SalesTerritoryGroupKey INT NOT NULL,
    SalesTerritoryRegion NVARCHAR(55),

    FOREIGN KEY (SalesTerritoryCountryKey) REFERENCES sch_Location.SalesTerritoryCountry(SalesTerritoryCountryKey) ON DELETE CASCADE,
    FOREIGN KEY (SalesTerritoryGroupKey) REFERENCES sch_Location.SalesTerritoryGroup(SalesTerritoryGroupKey) ON DELETE CASCADE,
) ON FG_Location

CREATE TABLE sch_Location.StateProvice(
    StateProviceKey INT PRIMARY KEY IDENTITY(1,1),
    StateProviceCode NVARCHAR(55) NOT NULL,
	StateProviceName NVARCHAR(25) NOT NULL

) ON FG_Location

CREATE TABLE sch_Location.CountryRegion(
    CountryRegionKey INT PRIMARY KEY IDENTITY(1,1),
    CountryRegionCode NVARCHAR(25) NOT NULL,
    CountryRegionName NVARCHAR(25) NOT NULL  
) ON FG_Location


CREATE TABLE sch_Location.City(
    CityKey INT PRIMARY KEY IDENTITY(1,1),
    CountryRegionKey INT NOT NULL,
    StateProviceKey INT NOT NULL,
    City NVARCHAR(55) NOT NULL,

    FOREIGN KEY (CountryRegionKey) REFERENCES sch_Location.CountryRegion(CountryRegionKey)  ON DELETE CASCADE,
    FOREIGN KEY (StateProviceKey) REFERENCES sch_Location.StateProvice(StateProviceKey)  ON DELETE CASCADE
)ON FG_Location

CREATE TABLE sch_Location.AddressLine(
	AddressLineKey INT PRIMARY KEY IDENTITY(1,1),
	AddressLine1 NVARCHAR(55) NOT NULL,
    AddressLine2 NVARCHAR(55) NULL,
) ON FG_Location

CREATE TABLE sch_Location.Address(
    AddressKey INT PRIMARY KEY IDENTITY(1,1),
	AddressLineKey INT NOT NULL,
	CityKey INT NOT NULL,
    PostalCode NVARCHAR(55) NOT NULL,

	FOREIGN KEY (AddressLineKey) REFERENCES sch_Location.AddressLine(AddressLineKey) ON DELETE CASCADE,
	FOREIGN KEY (CityKey) REFERENCES sch_Location.City(CityKey) ON DELETE CASCADE
) ON FG_Location
------------------------------------------------- Schema Location -------------------------------------------------

----------------------------------------------------------- Schema Customer ---------------------------------------
CREATE TABLE sch_Customer.Title(
    TitleKey INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(55) NULL
) ON FG_Customer

CREATE TABLE sch_Customer.Education(
    EducationKey INT PRIMARY KEY IDENTITY(1,1),
    Education NVARCHAR(55) NOT NULL
) ON FG_Customer

CREATE TABLE sch_Customer.Occupation(
    OccupationKey INT PRIMARY KEY IDENTITY(1,1),
    Occupation NVARCHAR(55) NOT NULL
) ON FG_Customer

CREATE TABLE sch_Customer.Customer(
    CustomerKey INT PRIMARY KEY IDENTITY(11000,1),
    TitleKey INT NULL,
    MaritalStatus CHAR NOT NULL,
    GenderKey CHAR NOT NULL,
    EducationKey INT NOT NULL,
    OccupationKey INT NOT NULL,
    AddressKey INT NOT NULL,
	SalesTerritoryKey INT NOT NULL,
    FirstName NVARCHAR(55) NOT NULL,
    MiddleName NVARCHAR(55) NULL,
    LastName NVARCHAR(55) NOT NULL,
    BirthDate DATE NOT NULL,
    EmailAddress NVARCHAR(55) NOT NULL,
    TotalChildren INT NOT NULL,
	NameStyle NVARCHAR(55) NOT NULL,
	YearlyIncome INT NOT NULL,
	CommuteDistance NVARCHAR(55) NOT NULL,
    NumberChildrenAloneAtHome INT NOT NULL,
    HouseOwnerFlag INT NOT NULL,
    NumberCarsOwned INT NOT NULL,
    Phone NVARCHAR(65) NOT NULL ,
    DateFirstPurchase DATE NOT NULL,
    
    
    FOREIGN KEY (TitleKey) REFERENCES sch_Customer.Title(TitleKey) ON DELETE CASCADE,
    FOREIGN KEY (EducationKey) REFERENCES sch_Customer.Education(EducationKey) ON DELETE CASCADE,
    FOREIGN KEY (OccupationKey) REFERENCES sch_Customer.Occupation(OccupationKey) ON DELETE CASCADE,
    FOREIGN KEY (AddressKey) REFERENCES sch_Location.Address(AddressKey) ON DELETE CASCADE,
	FOREIGN KEY (SalesTerritoryKey) REFERENCES sch_Location.SalesTerritory(SalesTerritoryKey) ON DELETE CASCADE
) ON FG_Customer
----------------------------------------------------------- Schema Customer ---------------------------------------

---------------------------------------------------- Schema Sales -------------------------------------------------
CREATE TABLE sch_Sales.Currency(
    CurrencyKey INT IDENTITY(1,1) PRIMARY KEY , 
    CurrencyAlternateKey NVARCHAR(25)  NOT NULL,
    CurrencyName NVARCHAR(55) NOT NULL
) ON FG_Sales

CREATE TABLE sch_Sales.SalesOrder(
	SalesOrderKey INT PRIMARY KEY IDENTITY(1,1),
	SalesOrderNumber NVARCHAR(55) NOT NULL,
	SalesOrderLineNumber INT NOT NULL,
)ON FG_Sales

CREATE TABLE sch_Sales.Sales(
    SalesKey INT PRIMARY KEY IDENTITY(1,1),
	CustomerKey INT,
    CurrencyKey INT NOT NULL,
    SalesTerritoryKey INT NOT NULL,
	SalesOrderKey INT NOT NULL,
	OrderDate DATETIME NOT NULL,
	DueDate DATETIME NOT NULL,
	ShipDate Datetime NOT NULL,
	SalesAmount FLOAT

	

	FOREIGN KEY (CurrencyKey) REFERENCES sch_Sales.Currency(CurrencyKey),
	FOREIGN KEY (CustomerKey) REFERENCES sch_Customer.Customer(CustomerKey),
    FOREIGN KEY (SalesTerritoryKey) REFERENCES sch_Location.SalesTerritory(SalesTerritoryKey),
	FOREIGN KEY (SalesOrderKey) REFERENCES sch_Sales.SalesOrder(SalesOrderKey)
)ON FG_Sales

CREATE TABLE sch_Sales.SalesDetail(
	SalesDetailKey INT IDENTITY(1,1) PRIMARY KEY,
	SalesKey INT,
	ProductKey INT NOT NULL,
	OrderQuantity INT NOT NULL,
	UnitPrice FLOAT NOT NULL

	 FOREIGN KEY (ProductKey) REFERENCES sch_Product.Product(ProductKey) ON DELETE CASCADE,
	 FOREIGN KEY (SalesKey) REFERENCES sch_Sales.Sales(SalesKey) ON DELETE CASCADE
) ON FG_Sales

CREATE TABLE sch_Sales.Promotion(
	Promotion INT IDENTITY(1,1) PRIMARY KEY,
	SalesDetailKey INT NOT NULL,
	Price FLOAT NOT NULL,
	DateBegin DATETIME NOT NULL,
	DateEnd DATETIME NOT NULL,

	FOREIGN KEY (SalesDetailKey) REFERENCES sch_Sales.SalesDetail(SalesDetailKey) ON DELETE CASCADE
) ON FG_Sales



---------------------------------------------------- Schema Sales -------------------------------------------------