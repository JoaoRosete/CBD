use AdventureServices

-- Prazo médio entre data de encomenda e envio por Região Geográfica(Index)
DROP INDEX [v_AllPackages_In_TheLast2Years_INDEX] ON [sch_Sales].[Sales]
CREATE NONCLUSTERED INDEX [v_AllPackages_In_TheLast2Years_INDEX] ON [sch_Sales].[Sales] (
	[SalesTerritoryKey] DESC
)
INCLUDE (
	OrderDate,
	ShipDate
)ON FG_Sales

DROP INDEX [v_AllPackages_In_TheLast2Years_INDEX_SalesTerritoryKey_INDEX] ON [sch_Location].[SalesTerritoryCountry]
CREATE NONCLUSTERED INDEX [v_AllPackages_In_TheLast2Years_INDEX_SalesTerritoryKey_INDEX] ON [sch_Location].[SalesTerritoryCountry] (
	[SalesTerritoryCountryKey] 
)
INCLUDE (
	SalesTerritoryCountryName
)ON FG_Location

-- Volume de vendas por Produto (Index)
DROP INDEX [v_Volume_Sales_Per_Product_INDEX] ON [sch_Sales].[SalesDetail]
CREATE NONCLUSTERED INDEX [v_Volume_Sales_Per_Product_INDEX] ON [sch_Sales].[SalesDetail](
	[ProductKey]
)
INCLUDE(
	[SalesKey]
) ON FG_Sales


-- Calcular o valor total de vendas anual por Região Geográfica(Index)
DROP INDEX [v_TotalValue_Anual_Per_Country_INDEX] ON [sch_Sales].[Sales]
CREATE NONCLUSTERED INDEX [v_TotalValue_Anual_Per_Country_INDEX] ON [sch_Sales].[Sales](
	[SalesTerritoryKey]
)
INCLUDE(
	[OrderDate],
	[SalesAmount]
) ON FG_Sales


SET STATISTICS IO ON 
SELECT * FROM [sch_Product].v_Volume_Sales_Per_Product -- Done
SELECT * FROM [sch_Sales].v_TotalValue_Anual_Per_Country -- Done
SELECT * FROM  [sch_Sales].v_MaxTotalValue_Per_Country -- Done
SELECT * FROM [sch_Sales].v_AllPackages_In_TheLast2Years -- Done











