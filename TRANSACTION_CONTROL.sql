use AdventureServices

-- Adicionar Produto a Encomenda
CREATE PROCEDURE [sch_Sales].addProduct_TO_Order(@SalesKey INT, @ProductKey INT, @OrderQuantity INT, @UnitPrice FLOAT)
AS
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	BEGIN TRAN

	IF(EXISTS(SELECT * FROM AdventureServices.sch_Sales.Sales WHERE SalesKey = @SalesKey))
		BEGIN
			
			IF(EXISTS(SELECT * FROM AdventureServices.sch_Product.Product WHERE ProductKey = @ProductKey))
				BEGIN
					
					IF(@OrderQuantity IS NOT NULL AND @OrderQuantity >= 1 AND @UnitPrice >= 1)
						BEGIN

							INSERT INTO AdventureServices.sch_Sales.SalesDetail(SalesKey, ProductKey, OrderQuantity, UnitPrice)
							VALUES (@SalesKey, @ProductKey, @OrderQuantity, @UnitPrice)

						END
					ELSE
						BEGIN
							RAISERROR('OrderQuantity or UnitPrice wrong format', 16, 1);
						END

				END
			ELSE
				BEGIN
					RAISERROR('Product doesnt Exist', 16,1);
				END

			
		END
	ELSE
		BEGIN
			RAISERROR('Customer doesnt Exist', 16,1)
		END

	COMMIT TRAN
GO


-- Alterar Quantidade de Produto
CREATE PROCEDURE [sch_Sales].alterQuantity(@SalesDetailKey INT, @OrderQuantity INT)
AS
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRAN

	IF (@SalesDetailKey IS NOT NULL AND @OrderQuantity IS NOT NULL)
		BEGIN
			
			IF(EXISTS(SELECT * FROM [sch_Sales].SalesDetail WHERE SalesDetailKey = @SalesDetailKey))
				BEGIN
				
					UPDATE [sch_Sales].SalesDetail
					SET OrderQuantity = @OrderQuantity
					WHERE SalesDetailKey = @SalesDetailKey

				END

			ELSE
				BEGIN
					RAISERROR('SalesDetail doesnt Exist', 16,1)
				END

		END

	ELSE
		BEGIN 
			RAISERROR('The Values are Both Null', 16,1)
		END

	COMMIT TRAN
GO


CREATE PROCEDURE [sch_Product].sp_alterProductStatus(@ProductKey INT, @Status NVARCHAR(55))
AS
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	BEGIN TRAN

	IF(EXISTS(SELECT * FROM [sch_Product].Product WHERE ProductKey = @ProductKey))
		BEGIN
			
			IF @Status IS NOT NULL 
				BEGIN
					UPDATE [sch_Product].Product
					SET Status = @Status
					WHERE ProductKey = @ProductKey
				END
			ELSE
				BEGIN
					RAISERROR('Status is NULL', 16,1)
				END


		END
	ELSE
		BEGIN
			RAISERROR('Product doesnt Exist', 16,1)
		END

	COMMIT TRAN
GO