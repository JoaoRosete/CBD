use AdventureServices

-- Product MongoDB Insert
SELECT CONCAT('db.Product.insert({_id:',ProductKey,', Nome:"',ep.EnglishProductName,'", Categoria:"',epc.EnglishProductCategoryName,'"})')
FROM sch_Product.Product AS p
INNER JOIN sch_Product.ProductName AS ep ON p.ProductNameKey = ep.ProductNameKey
INNER JOIN sch_Product.ProductSubCategory AS eps ON p.ProductSubCategoryKey = eps.ProductSubCategoryKey
INNER JOIN sch_Product.ProductCategory AS epc ON eps.ProductCategoryKey = epc.ProductCategoryKey
WHERE epc.EnglishProductCategoryName = 'Bikes'

-- Customer MongoDB Insert
select * from sch_Customer.Customer

