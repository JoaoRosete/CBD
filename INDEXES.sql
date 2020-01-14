use AdventureServices


-- Prazo médio entre data de encomenda e envio por Região Geográfica(Index)
CREATE NONCLUSTERED INDEX [v_AllPackages_In_TheLast2Years_INDEX] ON [sch_Sales].[Sales] (
	[SalesTerritoryKey] DESC
)
INCLUDE (
	OrderDate,
	ShipDate
)ON FG_Sales

CREATE NONCLUSTERED INDEX [v_AllPackages_In_TheLast2Years_INDEX_SalesTerritoryKey_INDEX] ON [sch_Location].[SalesTerritoryCountry] (
	[SalesTerritoryCountryKey] 
)
INCLUDE (
	SalesTerritoryCountryName
)ON FG_Location

-- Volume de vendas por Produto (Index)
select * from [sch_Product].v_Volume_Sales_Per_Product
CREATE NONCLUSTERED INDEX [v_Volume_Sales_Per_Product_INDEX] ON [sch_Sales].[SalesDetail](
	[ProductKey]
)
INCLUDE(
	[SalesKey]
) ON FG_Sales


-- Calcular o valor total de vendas anual por Região Geográfica(Index)
CREATE NONCLUSTERED INDEX [v_TotalValue_Anual_Per_Country_INDEX] ON [sch_Sales].[Sales](
	[SalesTerritoryKey]
)
INCLUDE(
	[OrderDate],
	[SalesAmount]
) ON FG_Sales











