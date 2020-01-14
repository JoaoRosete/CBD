use AdventureServices

-- Total Monetário de vendas por Ano
CREATE VIEW [sch_Sales].v_SalesYear
AS
	SELECT YEAR(s.OrderDate) AS YearSales, ROUND(SUM(sd.UnitPrice * sd.OrderQuantity), 2) AS Sales
	FROM [sch_Sales].SalesDetail AS sd
	INNER JOIN [sch_Sales].Sales AS s ON sd.SalesKey = s.SalesKey
	GROUP BY YEAR(s.OrderDate)
GO


-- Total Monetário de Vendas por Ano Antiga DB
 CREATE VIEW v_SalesYearOld
 AS
	SELECT YEAR(OrderDate) AS YearSales, ROUND(SUM(convert(float, replace(UnitPrice, ',','.')) * convert(float, replace(OrderQuantity, ',','.'))), 2) AS Sales
	FROM AdventureServicesOLD.dbo.Sales 
	GROUP BY YEAR(OrderDate)
GO
	
-- Total Monetário de vendas de Sales Territory Country por Ano
CREATE VIEW [sch_Sales].v_SalesYear_SalesTerritoryCountry
AS
	SELECT YEAR(sd.OrderDate) AS YearSales, stc.SalesTerritoryCountryName AS CountryName,  ROUND(SUM(s.UnitPrice * s.OrderQuantity), 2) AS Sales
	FROM [sch_Sales].Sales AS sd
	INNER JOIN [sch_Sales].SalesDetail AS s ON sd.SalesKey = s.SalesKey
	INNER JOIN [sch_Location].SalesTerritory  AS st ON st.SalesTerritoryKey = sd.SalesTerritoryKey
	INNER JOIN [sch_Location].SalesTerritoryCountry  AS stc ON st.SalesTerritoryCountryKey = stc.SalesTerritoryCountryKey
	GROUP BY YEAR(sd.OrderDate), stc.SalesTerritoryCountryName
GO

-- Total Monetário de vendas de Sales Territory Country por Ano da AntigaDB
CREATE VIEW v_SalesYear_SalesTerritoryCountryOld
AS
	SELECT YEAR(OrderDate) AS YearSales, SalesTerritoryCountry AS CountryName,  ROUND(SUM(convert(float, replace(UnitPrice, ',','.')) * convert(float, replace(OrderQuantity, ',','.'))), 2) AS Sales
	FROM AdventureServicesOLD.dbo.Sales 
	GROUP BY YEAR(OrderDate), SalesTerritoryCountry
GO


-- Total Monetário de vendas por Product SubCategory por Ano
CREATE VIEW [sch_Sales].v_SalesYear_ProductSubCategory
AS
	SELECT result.YearSales, result.EnglishProductSubCategoryName, ROUND(SUM(result.Sales), 2) AS Sales
	FROM(
		SELECT DISTINCT YEAR(s.OrderDate) AS YearSales, pd.EnglishProductSubCategoryName,  sd.UnitPrice * sd.OrderQuantity AS Sales
		FROM [sch_Sales].Sales AS s
		INNER JOIN [sch_Sales].SalesDetail AS sd ON sd.SalesKey = s.SalesKey
		INNER JOIN [sch_Product].Product AS p ON p.ProductKey = sd.ProductKey
		INNER JOIN [sch_Product].ProductSubCategory AS pd ON p.ProductSubCategoryKey = pd.ProductSubCategoryKey
	) AS result
	GROUP BY result.YearSales, result.EnglishProductSubCategoryName
GO

-- Total Monetário de vendas por Product SubCategory por Ano OLD
CREATE VIEW v_SalesYear_ProductSubCategoryOld
AS
	SELECT YEAR(s.OrderDate) AS YearSales, pd.EnglishProductSubCategoryName, ROUND(SUM(convert(float, replace(s.UnitPrice, ',','.')) * convert(float, replace(s.OrderQuantity, ',','.'))),2) AS Sales
	FROM AdventureServicesOLD.dbo.Sales AS s
	INNER JOIN AdventureServicesOLD.dbo.Products AS p ON p.ProductKey = s.ProductKey
	INNER JOIN AdventureServicesOLD.dbo.ProductSubCategory AS pd ON pd.ProductSubcategoryKey = p.ProductSubCategoryKey
	GROUP BY YEAR(s.OrderDate), pd.EnglishProductSubCategoryName
GO

-- Total Monetário de vendas por Product Category por Ano
CREATE VIEW [sch_Sales].v_SalesYear_ProductCategory
AS
	SELECT result.YearSales, result.EnglishProductCategoryName, ROUND(SUM(result.Sales), 2) AS Sales
	FROM(
		SELECT DISTINCT YEAR(s.OrderDate) AS YearSales, pc.EnglishProductCategoryName,  sd.UnitPrice * sd.OrderQuantity AS Sales
		FROM [sch_Sales].SalesDetail AS sd
		INNER JOIN [sch_Sales].Sales AS s ON sd.SalesKey = s.SalesKey
		INNER JOIN [sch_Product].Product AS p ON p.ProductKey = sd.ProductKey
		INNER JOIN [sch_Product].ProductSubCategory AS pd ON p.ProductSubCategoryKey = pd.ProductSubCategoryKey
		INNER JOIN [sch_Product].ProductCategory AS pc ON pc.ProductCategoryKey = pd.ProductCategoryKey

	) AS result
	GROUP BY result.YearSales, result.EnglishProductCategoryName
GO

-- Total Monetário de vendas por Product Category por Ano Old
CREATE VIEW v_SalesYear_ProductCategoryOld
AS
		SELECT YEAR(s.OrderDate) AS YearSales, pc.EnglishProductCategoryName,   ROUND(SUM(convert(float, replace(s.UnitPrice, ',','.')) * convert(float, replace(s.OrderQuantity, ',','.'))),2) AS Sales
		FROM AdventureServicesOLD.dbo.Sales AS s
		INNER JOIN AdventureServicesOLD.dbo.Products AS pc ON pc.ProductKey = s.ProductKey
		GROUP BY YEAR(s.OrderDate), pc.EnglishProductCategoryName
GO

-- Números de Clientes por Sales Territory Country
CREATE VIEW [sch_Sales].v_Customers_SalesTerritoryCountry
AS
	SELECT stc.SalesTerritoryCountryName as CountryName, COUNT(*) as CustomerCountry 
	FROM [sch_Customer].Customer c
	INNER JOIN [sch_Location].SalesTerritory AS st ON c.SalesTerritoryKey = st.SalesTerritoryKey
	INNER JOIN [sch_Location].SalesTerritoryCountry stc ON stc.SalesTerritoryCountryKey = st.SalesTerritoryCountryKey
	GROUP BY stc.SalesTerritoryCountryName
GO

-- Números de Clientes por Sales Territory Country Old
CREATE VIEW v_Customers_SalesTerritoryCountryOld
AS
	SELECT st.SalesTerritoryCountry as CountryName, COUNT(*) as CustomerCountry 
	FROM AdventureServicesOLD.dbo.Customer c
	INNER JOIN AdventureServicesOLD.dbo.SalesTerritory AS st ON c.SalesTerritoryKey = st.SalesTerritoryKey
	GROUP BY st.SalesTerritoryCountry
GO

-- Número de Compras Por Cliente 
CREATE VIEW [sch_Customer].v_ProductsPerCustomer
AS
	SELECT c.CustomerKey as Customer, count(*) AS  Products
	FROM [sch_Product].Product AS p
	INNER JOIN [sch_Sales].SalesDetail AS sh ON p.ProductKey = sh.ProductKey
	INNER JOIN [sch_Sales].Sales AS s ON s.SalesKey = sh.SalesKey
	INNER JOIN [sch_Customer].Customer AS c ON c.CustomerKey = s.CustomerKey
	GROUP BY c.CustomerKey
GO

-- Questões e Respostas de Cada User
CREATE VIEW [sch_User].v_QuestionPerUser
AS
	SELECT DISTINCT u.UserKey AS [User], u.FirstName AS Nome, q.Question AS Question, aq.Answer AS Resposta
	FROM [sch_User].AnsweredQuestions AS aq
	INNER JOIN [sch_User].[User] AS u ON u.UserKey = aq.UserKey
	INNER JOIN [sch_User].Questions AS q ON q.QuestionKey = aq.QuestionKey
GO


-- Número de Clientes Por Cidade
CREATE VIEW [sch_Customer].v_NumberOfCustomersPerCity
AS
	SELECT Cc.City, COUNT(*) CustomerPCountry 
	FROM [sch_Customer].Customer AS c
	LEFT JOIN [sch_Location].[Address] AS a ON  a.AddressKey = c.AddressKey
	LEFT JOIN [sch_Location].City AS Cc ON Cc.CityKey = a.CityKey
	GROUP BY Cc.City
GO

-- Categoria e SubCategoria de um Producto
CREATE VIEW [sch_Product].v_CategorySubCategoryOfProduct
AS
	SELECT pn.EnglishProductName, psc.EnglishProductSubCategoryName, pc.EnglishProductCategoryName
	FROM [sch_Product].Product AS c
	INNER JOIN [sch_Product].ProductName AS pn ON pn.ProductNameKey = c.ProductNameKey	
	INNER JOIN [sch_Product].ProductSubCategory AS psc ON psc.ProductSubCategoryKey = c.ProductSubCategoryKey
	INNER JOIN [sch_Product].ProductCategory AS pc ON psc.ProductCategoryKey = pc.ProductCategoryKey
GO

-------------------- Fase 2

-- Volume de vendas por Produto 
CREATE VIEW [sch_Product].v_Volume_Sales_Per_Product
AS
	SELECT pn.EnglishProductName AS 'Product Name', (count(pn.EnglishProductName) * s.SalesAmount) AS 'Volume'
	FROM [sch_Sales].Sales AS s
	INNER JOIN [sch_Sales].SalesDetail AS sd ON sd.SalesKey = s.SalesKey
	INNER JOIN [sch_Product].Product AS p ON sd.ProductKey = p.ProductKey
	INNER JOIN [sch_Product].ProductName AS pn ON pn.ProductNameKey = p.ProductNameKey
	GROUP BY pn.EnglishProductName, s.SalesAmount
GO

-- Calcular o valor total de vendas anual por Região Geográfica
CREATE VIEW [sch_Sales].v_TotalValue_Anual_Per_Country
AS 
	SELECT result.YearSales AS YearSales , result.SalesTerritoryCountryName, ROUND(SUM(result.Sales), 2) AS Sales
	FROM(
		SELECT DISTINCT YEAR(s.OrderDate) AS YearSales , stc.SalesTerritoryCountryName , (count(p.ProductKey) * s.SalesAmount) AS 'Sales'
		FROM [sch_Sales].SalesDetail AS sd
		INNER JOIN [sch_Sales].Sales AS s ON sd.SalesKey = s.SalesKey
		INNER JOIN [sch_Product].Product AS p ON sd.ProductKey = p.ProductKey
		INNER JOIN [sch_Location].SalesTerritory AS st ON s.SalesTerritoryKey = st.SalesTerritoryKey
		INNER JOIN [sch_Location].SalesTerritoryCountry AS stc ON st.SalesTerritoryCountryKey = stc.SalesTerritoryCountryKey
		GROUP BY YEAR(s.OrderDate), stc.SalesTerritoryCountryName, s.SalesAmount
	) AS result
	GROUP BY result.YearSales, result.SalesTerritoryCountryName
GO

-- Obter para cada ano a Região Geográfica com o maior valor total de vendas
CREATE VIEW [sch_Sales].v_MaxTotalValue_Per_Country
AS
	SELECT YEAR(s.OrderDate) AS YearSales , stc.SalesTerritoryCountryName, ROUND((count(p.ProductKey) * s.SalesAmount),2 ) AS Sales
		FROM [sch_Sales].SalesDetail AS sd
		INNER JOIN [sch_Sales].Sales AS s ON sd.SalesKey = s.SalesKey
		INNER JOIN [sch_Product].Product AS p ON sd.ProductKey = p.ProductKey
		INNER JOIN [sch_Location].SalesTerritory AS st ON s.SalesTerritoryKey = st.SalesTerritoryKey
		INNER JOIN [sch_Location].SalesTerritoryCountry AS stc ON st.SalesTerritoryCountryKey = stc.SalesTerritoryCountryKey
		WHERE  s.SalesAmount in (SELECT MAX(SalesAmount) FROM sch_sales.Sales as s INNER JOIN [sch_Location].SalesTerritory AS st ON s.SalesTerritoryKey = st.SalesTerritoryKey
		INNER JOIN [sch_Location].SalesTerritoryCountry AS stc ON st.SalesTerritoryCountryKey = stc.SalesTerritoryCountryKey 
		group by stc.SalesTerritoryCountryName)
		GROUP BY YEAR(s.OrderDate), stc.SalesTerritoryCountryName, s.SalesAmount
GO


-- Prazo médio entre data de encomenda e envio por Região Geográfica
CREATE VIEW [sch_Sales].v_AllPackages_In_TheLast2Years
AS
	SELECT  c.SalesTerritoryCountryName, CAST(AVG(CAST(DATEDIFF(DAY, s.OrderDate, s.ShipDate) AS DECIMAL(18,2))) AS DECIMAL(18,2)) AS 'Average'
	FROM sch_Sales.Sales AS s
	INNER JOIN [sch_Location].SalesTerritory AS st ON s.SalesTerritoryKey = st.SalesTerritoryKey
	INNER JOIN [sch_Location].SalesTerritoryCountry AS c ON st.SalesTerritoryCountryKey = c.SalesTerritoryCountryKey
	GROUP BY c.SalesTerritoryCountryName
GO











