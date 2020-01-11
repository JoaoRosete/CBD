use AdventureServices

	ALTER TABLE [sch_User].[User] ADD EmailEncrypt VARBINARY(256);
	ALTER TABLE [sch_User].[User] ADD PasswordEncrypt VARBINARY(256);

	INSERT INTO sch_User.[User](FirstName,LastName,EmailAddress, Password) values ('Joao', 'Rosete', 'rosete@gmail.com', 'rosete')
	INSERT INTO sch_User.[User](FirstName,LastName,EmailAddress, Password) values ('Bruno', 'Paixao', 'Paixao@gmail.com', 'paixao')

	INSERT INTO sch_User.Questions(Question) values ('Cao ou Gato?')
	INSERT INTO sch_User.Questions(Question) values ('Agua ou Sumo?')
	INSERT INTO sch_User.Questions(Question) values ('Verde Ou Vermelho?')
	
	INSERT INTO sch_User.AnsweredQuestions(QuestionKey,UserKey,Answer) values (1,1,'Cao')
	INSERT INTO sch_User.AnsweredQuestions(QuestionKey,UserKey,Answer) values (2,1,'Agua')
	INSERT INTO sch_User.AnsweredQuestions(QuestionKey,UserKey,Answer) values (3,1,'Vermelho')

	INSERT INTO sch_User.AnsweredQuestions(QuestionKey,UserKey,Answer) values (1,2,'Gato')
	INSERT INTO sch_User.AnsweredQuestions(QuestionKey,UserKey,Answer) values (2,2,'Sumo')
	INSERT INTO sch_User.AnsweredQuestions(QuestionKey,UserKey,Answer) values (3,2,'Vermelho')

-- Table Education
	INSERT INTO [AdventureServices].[sch_Customer].Education (Education)
	SELECT Distinct Education FROM AdventureServicesOLD.dbo.Customer

--- Table Occupation 
	INSERT INTO [AdventureServices].[sch_Customer].Occupation (Occupation)
	SELECT Distinct Occupation FROM AdventureServicesOLD.dbo.Customer

-- Table Title
	INSERT INTO [AdventureServices].[sch_Customer].Title (Title)
	SELECT Distinct Title FROM AdventureServicesOLD.dbo.Customer

-- Table AddressLine
	INSERT INTO [AdventureServices].[sch_Location].AddressLine (AddressLine1, AddressLine2)
	SELECT Distinct AddressLine1, AddressLine2 FROM AdventureServicesOLD.dbo.Customer

-->  Table CountryRegion
	INSERT INTO [AdventureServices].[sch_Location].CountryRegion(CountryRegionCode, CountryRegionName)
	SELECT Distinct CountryRegionCode, CountryRegionName FROM AdventureServicesOLD.dbo.Customer

-->  Table StateProvince
	INSERT INTO [AdventureServices].[sch_Location].StateProvice(StateProviceName, StateProviceCode)
	SELECT   Distinct StateProvinceName, StateProvinceCode FROM AdventureServicesOLD.dbo.Customer

--> Table City
	SET IDENTITY_INSERT [AdventureServices].[sch_Location].City OFF
	INSERT INTO[AdventureServices].[sch_Location].City (City, CountryRegionKey, StateProviceKey)
	SELECT	Distinct oldT.City, newC.CountryRegionKey, newS.StateProviceKey 
	FROM AdventureServicesOLD.dbo.Customer AS oldT
	LEFT JOIN AdventureServices.[sch_Location].CountryRegion AS newC ON newC.CountryRegionName = oldT.CountryRegionName 
	LEFT JOIN AdventureServices.[sch_Location].StateProvice AS newS ON newS.StateProviceName = oldT.StateProvinceName
	ORDER BY oldT.City

--> Table Address
	INSERT INTO [AdventureServices].[sch_Location].Address(AddressLineKey, CityKey, PostalCode)
	SELECT distinct newA.AddressLineKey, newC.CityKey , oldT.PostalCode
	FROM  AdventureServicesOLD.dbo.Customer AS oldT
	INNER JOIN [AdventureServices].[sch_Location].City AS newC ON oldT.City = newC.City 
	INNER JOIN [AdventureServices].[sch_Location].CountryRegion AS newR ON oldT.CountryRegionCode = newR.CountryRegionCode AND oldT.CountryRegionName = newR.CountryRegionName
	INNER JOIN [AdventureServices].[sch_Location].StateProvice AS newS ON oldT.StateProvinceCode = newS.StateProviceCode AND oldT.StateProvinceName = newS.StateProviceName
	INNER JOIN [AdventureServices].[sch_Location].AddressLine AS newA ON oldT.AddressLine1 = newA.AddressLine1 AND oldT.AddressLine2 = newA.AddressLine2

--> Table Currency
	INSERT INTO [AdventureServices].[sch_Sales].Currency(CurrencyAlternateKey, CurrencyName)
	SELECT   Distinct CurrencyAlternateKey, CurrencyName FROM AdventureServicesOLD.dbo.Currency

--> Table SalesTerritoryCountry
	INSERT INTO [AdventureServices].[sch_Location].SalesTerritoryCountry(SalesTerritoryCountryName)
	SELECT  distinct SalesTerritoryCountry FROM AdventureServicesOLD.dbo.SalesTerritory

--> Table SalesTerritoryGroup
	SET IDENTITY_INSERT [AdventureServices].[sch_Location].SalesTerritoryGroup OFF
	INSERT INTO [AdventureServices].[sch_Location].SalesTerritoryGroup(SalesTerritoryGroupName)
	SELECT  distinct SalesTerritoryGroup FROM AdventureServicesOLD.dbo.SalesTerritory

--> Table SalesTerritoryGroup
	INSERT INTO [AdventureServices].[sch_Location].SalesTerritory(SalesTerritoryCountryKey, SalesTerritoryGroupKey, SalesTerritoryRegion)
	SELECT newSC.SalesTerritoryCountryKey, newSG.SalesTerritoryGroupKey, oldT.SalesTerritoryRegion FROM AdventureServicesOLD.dbo.SalesTerritory oldT
	INNER JOIN [AdventureServices].[sch_Location].SalesTerritoryCountry AS newSC ON newSC.SalesTerritoryCountryName = oldT.SalesTerritoryCountry
	INNER JOIN [AdventureServices].[sch_Location].SalesTerritoryGroup AS newSG ON newSG.SalesTerritoryGroupName = oldT.SalesTerritoryGroup

--> Table SalesOrder
	INSERT INTO [AdventureServices].sch_Sales.SalesOrder(SalesOrderNumber, SalesOrderLineNumber)
	SELECT SalesOrderNumber, SalesOrderLineNumber FROM AdventureServicesOLD.dbo.Sales
	order by SalesOrderNumber

--> Table Customer
	INSERT INTO [AdventureServices].[sch_Customer].Customer(
	TitleKey, 
	MaritalStatus,
	GenderKey,
	EducationKey,
	OccupationKey,
	AddressKey,
	SalesTerritoryKey,
	FirstName,
	MiddleName,
	LastName,
	BirthDate,
	EmailAddress,
	TotalChildren,
	NameStyle,
	YearlyIncome,
	CommuteDistance,
	NumberChildrenAloneAtHome,
	HouseOwnerFlag,
	NumberCarsOwned,
	Phone,
	DateFirstPurchase)

	SELECT 
	newT.TitleKey, 
	MaritalStatus,
	Gender,
	newE.EducationKey,
	newO.OccupationKey,
	newAD.AddressKey,
	newST.SalesTerritoryKey,
	FirstName,
	MiddleName,
	LastName,
	BirthDate,
	EmailAddress,
	TotalChildren,
	NameStyle,
	YearlyIncome,
	CommuteDistance,
	NumberChildrenAtHome,
	HouseOwnerFlag,
	NumberCarsOwned,
	Phone,
	DateFirstPurchase
	FROM AdventureServicesOLD.dbo.Customer AS oldT
	LEFT JOIN [AdventureServices].[sch_Customer].Title AS newT ON oldT.Title = newT.Title
	LEFT JOIN [AdventureServices].[sch_Customer].Education AS newE ON oldT.Education = newE.Education
	LEFT JOIN [AdventureServices].[sch_Customer].Occupation AS newO ON oldT.Occupation = newO.Occupation
	LEFT JOIN [AdventureServices].[sch_Location].AddressLine AS newADD ON oldT.AddressLine1 = newADD.AddressLine1
	LEFT JOIN [AdventureServices].[sch_Location].Address AS newAD ON  newADD.AddressLineKey = newAD.AddressKey
	LEFT JOIN [AdventureServices].[sch_Location].SalesTerritory AS newST ON oldT.SalesTerritoryKey = newST.SalesTerritoryKey

	-- Table Color
	INSERT INTO [AdventureServices].[sch_Product].Color(Color)
	SELECT DISTINCT Color
	FROM AdventureServicesOLD.dbo.Products;


	-- ModelName
	INSERT INTO [AdventureServices].[sch_Product].Model(ProductModelName)
	SELECT DISTINCT ModelName
	FROM AdventureServicesOLD.dbo.Products;

	-- ProductName
	INSERT INTO [AdventureServices].[sch_Product].ProductName(EnglishProductName, SpanishProductName, FrenchProductName)
	SELECT distinct EnglishProductName, SpanishProductName, FrenchProductName
	FROM AdventureServicesOLD.dbo.Products;

	-- ProductCategoryName
	INSERT INTO [AdventureServices].[sch_Product].ProductCategory(EnglishProductCategoryName, FrenchProductCategoryName, SpanishProductCategoryName)
	SELECT DISTINCT EnglishProductCategoryName, FrenchProductCategoryName, SpanishProductCategoryName
	FROM AdventureServicesOLD.dbo.Products;

	-- ProductLine
	INSERT INTO [AdventureServices].[sch_Product].ProductLine (ProductLine)
	SELECT DISTINCT ProductLine FROM AdventureServicesOLD.dbo.Products

	-- Description
	INSERT INTO [AdventureServices].[sch_Product].Description (EnglishDescription, FrenchDescription)
	SELECT distinct EnglishDescription, FrenchDescription FROM AdventureServicesOLD.dbo.Products


	-- WeightUnitMeasureCode
	INSERT INTO [AdventureServices].[sch_Product].WeightUnitMeasureCode(ProductWeightUnitMeasureCode)
	SELECT DISTINCT WeightUnitMeasureCode FROM AdventureServicesOLD.dbo.Products

	-- Style
	INSERT INTO [AdventureServices].[sch_Product].Style (StyleName)
	SELECT DISTINCT Style FROM AdventureServicesOLD.dbo.Products

	-- Class
	INSERT INTO [AdventureServices].[sch_Product].Class (ClassName)
	SELECT DISTINCT Class FROM AdventureServicesOLD.dbo.Products

	-- SizeUnitMeasure
	INSERT INTO [AdventureServices].[sch_Product].SizeUnitMeasure(SizeUnitMeasure)
	SELECT DISTINCT SizeUnitMeasureCode FROM AdventureServicesOLD.dbo.Products

	-- SubCategory
	SET IDENTITY_INSERT[AdventureServices].[sch_Product].ProductSubCategory OFF;
	INSERT INTO [AdventureServices].[sch_Product].ProductSubCategory (ProductCategoryKey, EnglishProductSubCategoryName, FrenchProductSubCategoryName, SpanishProductSubCategoryName )
	SELECT DISTINCT newPC.ProductCategoryKey , newSB.EnglishProductSubCategoryName, newSB.FrenchProductSubCategoryName, newSB.SpanishProductSubCategoryName 
	FROM AdventureServicesOLD.dbo.Products AS oldT
	INNER JOIN [AdventureServices].[sch_Product].ProductCategory AS newPc ON oldT.EnglishProductCategoryName = newPc.EnglishProductCategoryName
	INNER JOIN  AdventureServicesOLD.dbo.ProductSubCategory AS newSB ON oldT.ProductSubCategoryKey = newSB.ProductSubcategoryKey

	-- Product
	INSERT INTO [AdventureServices].[sch_Product].Product(
	ProductSubCategoryKey,
	WeightUnitMeasureCodeKey,
	SizeUnitMeasureKey,
	ProductNameKey,
	ColorKey,
	StyleKey,
	ClassKey,
	DescriptionKey,
	ProductLineKey,
	ModelKey,
	StandardCost,
	FinishedGoodsFlag,
	ListPrice,
	Size,
	SizeRange,
	Weight,
	DaysToManufacture,
	DealerPrice,
	Status)

	SELECT 
	newPSC.ProductSubCategoryKey,
	newWU.WeightUnitMeasureCodeKey,
	newSU.SizeUnitMeasureKey,
	newPN.ProductNameKey,
	newC.ColorKey,
	newS.StyleKey,
	newCC.ClassKey,
	newD.DescriptionKey,
	newPL.ProductLineKey,
	newM.ModelKey,
	StandardCost,
	FinishedGoodsFlag,
	ListPrice,
	Size,
	SizeRange,
	ProductWeight,
	DaysToManufacture,
	DealerPrice, 
	ProductStatus
	FROM AdventureServicesOLD.dbo.Products AS oldT
	LEFT JOIN [AdventureServices].[sch_Product].ProductSubCategory AS newPSC ON oldT.ProductSubCategoryKey = newPSC.ProductSubCategoryKey
	LEFT JOIN [AdventureServices].[sch_Product].WeightUnitMeasureCode AS newWU ON oldT.WeightUnitMeasureCode = newWU.ProductWeightUnitMeasureCode
	LEFT JOIN [AdventureServices].[sch_Product].SizeUnitMeasure AS newSU ON oldT.SizeUnitMeasureCode = newSU.SizeUnitMeasure
	LEFT JOIN [AdventureServices].[sch_Product].ProductName AS newPN ON oldT.EnglishProductName = newPN.EnglishProductName
	LEFT JOIN [AdventureServices].[sch_Product].Color AS newC ON oldT.Color = newC.Color
	LEFT JOIN [AdventureServices].[sch_Product].Style AS newS ON oldT.Style = newS.StyleName
	LEFT JOIN [AdventureServices].[sch_Product].Description AS newD ON oldT.EnglishDescription = newD.EnglishDescription
	LEFT JOIN [AdventureServices].[sch_Product].ProductLine AS newPL ON oldT.ProductLine = newPL.ProductLine
	LEFT JOIN [AdventureServices].[sch_Product].Class AS newCC ON oldT.Class = newCC.ClassName
	LEFT JOIN [AdventureServices].[sch_Product].Model AS newM ON oldT.ModelName = newM.ProductModelName

	--> Sales
	INSERT INTO [AdventureServices].[sch_Sales].Sales(
		CustomerKey,
		CurrencyKey,
		SalesTerritoryKey,
		SalesOrderKey,
		OrderDate,
		DueDate,
		ShipDate,
		SalesAmount)

	SELECT 
		newCc.CustomerKey,
		newC.CurrencyKey,
		newST.SalesTerritoryKey,
		newSO.SalesOrderKey,
		oldT.OrderDate,
		oldT.DueDate,
		oldT.ShipDate,
		convert(float, replace(oldT.SalesAmount, ',','.'))SalesAmount
	FROM AdventureServicesOLD.dbo.Sales oldT
	LEFT JOIN [AdventureServices].[sch_Customer].Customer AS newCc ON newCc.CustomerKey = oldT.CustomerKey
	LEFT JOIN [AdventureServices].[sch_Sales].Currency AS newC ON newC.CurrencyKey = oldT.CurrencyKey
	LEFT JOIN [AdventureServices].[sch_Location].SalesTerritoryCountry AS newSTC ON newSTC.SalesTerritoryCountryName = oldT.SalesTerritoryCountry
	LEFT JOIN [AdventureServices].[sch_Location].SalesTerritory AS newST ON newST.SalesTerritoryRegion =  oldT.SalesTerritoryRegion
	LEFT JOIN [AdventureServices].[sch_Sales].SalesOrder AS newSO ON newSO.SalesOrderLineNumber = oldT.SalesOrderLineNumber AND newSO.SalesOrderNumber = oldT.SalesOrderNumber
	order by newCc.CustomerKey


	--> SalesDetail
	INSERT INTO [AdventureServices].[sch_Sales].SalesDetail(ProductKey, SalesKey,OrderQuantity, UnitPrice)
	SELECT DISTINCT newP.ProductKey, newS.SalesKey, oldT.OrderQuantity, convert(float, replace(oldT.UnitPrice, ',','.')) 
	FROM AdventureServicesOLD.dbo.Sales oldT
	LEFT JOIN [AdventureServices].[sch_Product].Product AS newP ON newP.ProductKey = oldT.ProductKey
	LEFT JOIN [AdventureServices].[sch_Customer].Customer AS newC on newC.CustomerKey = oldT.CustomerKey
	LEFT JOIN [AdventureServices].[sch_Sales].SalesOrder AS newSO ON newSO.SalesOrderLineNumber = oldT.SalesOrderLineNumber and newSO.SalesOrderNumber = oldT.SalesOrderNumber
	LEFT JOIN [AdventureServices].[sch_Location].SalesTerritory AS newST ON newST.SalesTerritoryRegion =  oldT.SalesTerritoryRegion
	LEFT JOIN [AdventureServices].[sch_Sales].Sales AS newS on newS.SalesOrderKey = newSO.SalesOrderKey AND newS.CustomerKey = oldT.CustomerKey AND newS.CurrencyKey = oldT.CurrencyKey AND newS.SalesTerritoryKey = newST.SalesTerritoryKey
	ORDER BY  newP.ProductKey
	
	--select count(*) from  AdventureServicesOLD.dbo.Sales WHERE ProductKey = '214'
	

	--SELECT DISTINCT newP.ProductKey, newS.SalesKey, oldT.OrderQuantity, convert(float, replace(oldT.UnitPrice, ',','.')) 
	--FROM AdventureServicesOLD.dbo.Sales oldT
	--LEFT JOIN [AdventureServices].[sch_Product].Product AS newP ON newP.ProductKey = oldT.ProductKey
	--LEFT JOIN [AdventureServices].[sch_Customer].Customer AS newC on newC.CustomerKey = oldT.CustomerKey
	--LEFT JOIN [AdventureServices].[sch_Sales].Sales AS newS on newS.CustomerKey = newC.CustomerKey
	--ORDER BY  newP.ProductKey

