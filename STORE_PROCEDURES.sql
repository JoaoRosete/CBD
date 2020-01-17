use AdventureServices


-- Criação da Encomenda
CREATE PROCEDURE [sch_Sales].sp_createOrder(@CustomerKey INT , @CurrencyKey INT, @TerritoryKey INT, @SalesOrderKey INT, @OrderDate DATETIME, @DueDate DATETIME, @ShipDate DATETIME)
AS
	
	DECLARE @amount FLOAT;
	SET @amount = 0.0;


	IF(EXISTS(SELECT * FROM AdventureServices.sch_Customer.Customer WHERE CustomerKey = @CustomerKey))
		BEGIN
			
			IF(EXISTS(SELECT * FROM AdventureServices.sch_Sales.Currency WHERE CurrencyKey = @CurrencyKey))
				BEGIN
							
				IF(EXISTS(SELECT * FROM AdventureServices.sch_Location.SalesTerritory WHERE SalesTerritoryKey = @TerritoryKey))
					BEGIN

						INSERT INTO AdventureServices.sch_Sales.Sales(CustomerKey, CurrencyKey, SalesTerritoryKey, SalesOrderKey, OrderDate, DueDate, ShipDate, SalesAmount) 
						VALUES (@CustomerKey, @CurrencyKey, @TerritoryKey, @SalesOrderKey, @OrderDate, @DueDate, @ShipDate, @amount)

					END
				ELSE
					BEGIN
						RAISERROR('Territory Doesnt Exist doesnt Exist', 16,1)
					END
					
				END
			ELSE
				BEGIN
					RAISERROR('Currency doesnt Exist', 16,1)
				END
		
		END
	ELSE
		BEGIN
			RAISERROR('Customer doesnt Exist', 16,1)
		END

GO

-- Remover Producto da Encomenda
CREATE PROCEDURE  [sch_Sales].removeProduct_FROM_Order(@SalesKey INT, @ProductKey INT)
AS

	IF(EXISTS(SELECT * FROM AdventureServices.[sch_Sales].SalesDetail WHERE SalesKey = @SalesKey AND ProductKey = @ProductKey))
		BEGIN
			
			DELETE FROM AdventureServices.[sch_Sales].SalesDetail WHERE SalesKey = @SalesKey AND ProductKey = @ProductKey
		
		END
	ELSE
		BEGIN 
			RAISERROR('Order doesnt exists with SalesKey, ProductKey', 16,1);
		END

GO


-- Adicionar uma Promotion ao uma Encomenda
CREATE PROCEDURE [sch_Sales].PromotionOrder(@SalesDetailKey INT, @Price FLOAT, @DateBegin DATETIME, @DateEnd DATETIME)
AS

	IF(EXISTS(SELECT * from [sch_Sales].SalesDetail WHERE SalesDetailKey = @SalesDetailKey))
		BEGIN
			
			IF @Price IS NOT NULL AND @DateBegin IS NOT NULL AND @DateEnd IS NOT NULL
				BEGIN
					
					IF(@DateBegin > @DateEnd)
						BEGIN
							INSERT INTO [sch_Sales].Promotion(SalesDetailKey, Price, DateBegin, DateEnd) VALUES (@SalesDetailKey, @Price, @DateBegin, @DateEnd)
						END
					ELSE 
						BEGIN
							RAISERROR('DateBegin > DateEnd needs to be DateEnd > DateBegin', 16,1)
						END

				END
			ELSE
				BEGIN
					RAISERROR('Values are Null', 16,1)
				END

		END

	ELSE
		BEGIN
			RAISERROR('SalesDetail Error', 16,1)
		END
GO


-- Alterar Subcategory de um Product
CREATE PROCEDURE [sch_Product].sp_changeProductSubCategory(@productID int, @newSubCategory nvarchar(25)) AS
BEGIN
    IF(EXISTS ( Select ProductKey FROM [sch_Product].Product WHERE ProductKey = @productID ))
        BEGIN
            IF( @newSubCategory <= (Select MAX(ProductSubCategoryKey) FROM [sch_Product].Product) )
                BEGIN
                    Update [sch_Product].Product
                    set ProductSubCategoryKey = @newSubCategory
                    where ProductKey = @ProductID;
                END
            ELSE
                BEGIN
                    print 'Numero de subcategoria inválido'
                END
        END
    ELSE
        BEGIN
            print 'Produto não existe'
        END
END


CREATE PROCEDURE [sch_Admin].sp_sizeUsage
AS
BEGIN
    IF OBJECT_ID('tempdb..#SpaceUsed') IS NOT NULL
        DROP TABLE #SpaceUsed
    CREATE TABLE #SpaceUsed (
         TableName sysname,
         NumRows BIGINT,
         ReservedSpace NVARCHAR(55),
         DataSpace NVARCHAR(55),
         IndexSize NVARCHAR(55),
         UnusedSpace NVARCHAR(55),
        ) 

    DECLARE @str VARCHAR(500)
    SET @str =  'exec sp_spaceused ''?'''
    INSERT INTO #SpaceUsed 
    EXEC sp_msforeachtable @command1=@str
	TRUNCATE TABLE [sch_Admin].MonitorSpaceUsage
    INSERT INTO [sch_Admin].MonitorSpaceUsage
    SELECT TableName, NumRows, 
        CONVERT(numeric(16,0),REPLACE(ReservedSpace,' KB','')) / 1024 as ReservedSpace_MB,
        CONVERT(numeric(16,0),REPLACE(DataSpace,' KB','')) / 1024 as DataSpace_MB,
        CONVERT(numeric(16,0),REPLACE(IndexSize,' KB','')) / 1024 as IndexSpace_MB,
        CONVERT(numeric(16,0),REPLACE(UnusedSpace,' KB','')) / 1024 as UnusedSpace_MB
    FROM #SpaceUsed
    ORDER BY ReservedSpace_MB desc
END
GO

CREATE PROCEDURE [sch_Admin].sp_updateMonitorData
AS
BEGIN
	TRUNCATE TABLE [sch_Admin].Monitor;

	INSERT INTO sch_Admin.Monitor
	Select * FROM [sch_Admin].v_displayMonitorData		
END

CREATE PROCEDURE sch_Admin.sp_showLatestData
AS
BEGIN
	Select * FROM [sch_Admin].v_displayMonitorData		
END
GO


CREATE PROCEDURE dbo.sp_GeneratorsInsert(@table varchar(255))
AS
BEGIN
	DECLARE @tblSchema 	nvarchar(255)
	DECLARE @tblCursor 	cursor
	
	DECLARE @clmName 	nvarchar(255)
	DECLARE @clmType 	nvarchar(255)
	DECLARE @clmSize 	int
	
	DECLARE @args 		nvarchar(500)
	DECLARE @values 		nvarchar(1000)
	
	DECLARE @spCode	nvarchar(4000)
	
	SET @tblSchema = (SELECT TABLE_SCHEMA FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table)

	IF (@tblSchema IS NULL)
	BEGIN
		DECLARE @error nvarchar(255) = CONCAT('Table ', @table , ' was not found')
		RAISERROR(@error, 16, 1)
		RETURN
	END

	SET @tblCursor = 	CURSOR FOR (
							SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH 
							FROM INFORMATION_SCHEMA.COLUMNS
							WHERE TABLE_NAME = @table
						)	

	OPEN @tblCursor
	FETCH NEXT FROM @tblCursor INTO @clmName, @clmType, @clmSize
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		IF((SELECT COLUMNPROPERTY(OBJECT_ID(CONCAT(@tblSchema, '.', @table)), @clmName,'IsIdentity')) = 0)
		BEGIN
			IF(@clmSize IS NULL)
			  SET @args  =  CONCAT(@args, '@', @clmName, ' ', @clmType, ', ')				 
			ELSE
				BEGIN
					IF(@clmType = 'varbinary')
						SET @args  =  CONCAT(@args, '@', @clmName, ' ', @clmType, '(8000), ')
					ELSE	
						SET @args  =  CONCAT(@args, '@', @clmName, ' ', @clmType, '(', @clmSize, '), ')
				END
			  

			SET @values = CONCAT(@values, '@', @clmName,', ')
		END
		FETCH NEXT FROM @tblCursor INTO @clmName, @clmType, @clmSize	
	END

	CLOSE @tblCursor
	DEALLOCATE @tblCursor

	SET @args 		= SUBSTRING(@args, 0, (LEN(@args)))
	SET @values 		= SUBSTRING(@values, 0, (LEN(@values)))
	SET @table 			= LOWER(@table)
	
	SET @spCode = CONCAT('
		CREATE PROCEDURE ', @tblSchema, '.sp_', @table, '_insert', '(', @args, ')
		AS
		BEGIN
			DECLARE @errorCode bigint
			DECLARE @errorMessage nvarchar(4000)

			BEGIN TRY
				INSERT INTO ', @tblSchema, '.', @table,' VALUES (', @values, ')
			END TRY
			BEGIN CATCH			
				SET @errorCode = (SELECT ERROR_NUMBER())
				SET @errorMessage = (SELECT ERROR_MESSAGE())
				RAISERROR(@errorMessage,16,1)
				INSERT INTO dbo.ErrorLog VALUES (@errorCode, @errorMessage, CURRENT_USER, CURRENT_TIMESTAMP)
			END CATCH
		END
	')

	 --PRINT(@spCode)
	 EXEC(@spCode)
END
GO

-- UPDATE

CREATE PROCEDURE dbo.sp_GeneratorsUpdate(@table varchar(255))
AS
BEGIN

	DECLARE @tblSchema 	nvarchar(255)
	DECLARE @tablePKCursor 	cursor
	DECLARE @tblCursor 	cursor
	
	DECLARE @clmName 	nvarchar(255)
	DECLARE @clmType 	nvarchar(255)
	DECLARE @clmSize 	int
	
	DECLARE @args 		nvarchar(500)
	DECLARE @values 		nvarchar(1000)
	DECLARE @conditions 	nvarchar(500)
	
	DECLARE @spCode	nvarchar(4000)

	SET @tblSchema = (SELECT TABLE_SCHEMA FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table)

	IF (@tblSchema IS NULL)
	BEGIN
		DECLARE @error nvarchar(255) = CONCAT('Table ', @table , ' was not found')
		RAISERROR(@error, 16, 1)
		RETURN
	END
	
	SET @tablePKCursor =	CURSOR FOR (	
								SELECT DISTINCT(COLUMN_NAME),DATA_TYPE,CHARACTER_MAXIMUM_LENGTH
								FROM INFORMATION_SCHEMA.COLUMNS 
								WHERE COLUMN_NAME IN (
									SELECT COLUMN_NAME 
									FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
									WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + CONSTRAINT_NAME), 'IsPrimaryKey') = 1
									AND TABLE_NAME = @table 
									AND TABLE_SCHEMA = @tblSchema
								)
							)

	OPEN @tablePKCursor
	FETCH NEXT FROM @tablePKCursor INTO @clmName, @clmType, @clmSize
	WHILE @@FETCH_STATUS = 0 
		BEGIN
			SET @conditions = CONCAT(@conditions, @clmName, ' = @', @clmName, ' AND ')
			FETCH NEXT FROM @tablePKCursor INTO @clmName, @clmType, @clmSize
		END

	CLOSE 		@tablePKCursor
	DEALLOCATE 	@tablePKCursor

	SET @tblCursor = 	CURSOR FOR(
							SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH 
							FROM INFORMATION_SCHEMA.COLUMNS
							WHERE TABLE_NAME = @table
						)	
	
	OPEN @tblCursor
	FETCH NEXT FROM @tblCursor INTO @clmName, @clmType, @clmSize
	WHILE @@FETCH_STATUS = 0 
		BEGIN
			IF((SELECT COLUMNPROPERTY(OBJECT_ID(CONCAT(@tblSchema,'.',@table)), @clmName,'IsIdentity')) = 0)
				SET @values = CONCAT(@values, @clmName,' = @', @clmName, ', ')
			
			IF(@clmSize IS NULL)
				SET @args = CONCAT(@args , '@', @clmName, ' ', @clmType, ', ')				 
			ELSE
				BEGIN
					IF(@clmType = 'varbinary')
						SET @args  =  CONCAT(@args, '@', @clmName, ' ', @clmType, '(8000), ')
					ELSE	
						SET @args  =  CONCAT(@args, '@', @clmName, ' ', @clmType, '(', @clmSize, '), ')
				END
				
			FETCH NEXT FROM @tblCursor INTO @clmName, @clmType, @clmSize
		END

	CLOSE @tblCursor
	DEALLOCATE @tblCursor
	
	SET @args 		= SUBSTRING(@args , 0, (LEN(@args)))
	SET @values 		= SUBSTRING(@values , 0, (LEN(@values)))
	SET @conditions 	= SUBSTRING(@conditions , 0, (LEN(@conditions) - 2))
	SET @table 			= LOWER(@table)
	
	SET @spCode = CONCAT('
		CREATE PROCEDURE ', @tblSchema, '.sp_', @table, '_update', '(', @args, ')
		AS
		BEGIN
			DECLARE @errorCode bigint
			DECLARE @errorMessage nvarchar(4000)

			BEGIN TRY
				UPDATE ', @tblSchema, '.', @table, ' SET ', @values, ' WHERE ', @conditions, '
			END TRY
			BEGIN CATCH			
				SET @errorCode = (SELECT ERROR_NUMBER())
				SET @errorMessage = (SELECT ERROR_MESSAGE())
				RAISERROR(@errorMessage,16,1)
				INSERT INTO dbo.ErrorLog VALUES (@errorCode, @errorMessage, CURRENT_USER, CURRENT_TIMESTAMP)
			END CATCH
		END
	')
		
	 --PRINT(@spCode)
	 EXEC(@spCode)
END
GO

-- DELETE

CREATE PROCEDURE dbo.sp_GeneratorsDelete(@table varchar(255))
AS
BEGIN

	DECLARE @tblSchema 	nvarchar(255)
	DECLARE @tblCursor 	cursor
	
	DECLARE @clmName 	nvarchar(255)
	DECLARE @clmType 	nvarchar(255)
	DECLARE @clmSize 	int
	
	DECLARE @args 		nvarchar(500)
	DECLARE @conditions 	nvarchar(500)
	
	DECLARE @spCode	nvarchar(4000)

	SET @tblSchema = (SELECT TABLE_SCHEMA FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table)

	IF (@tblSchema IS NULL)
	BEGIN
		DECLARE @error nvarchar(255) = CONCAT('Table ', @table , ' was not found')
		RAISERROR(@error, 16, 1)
		RETURN
	END
	
	SET @tblCursor = CURSOR FOR (
	SELECT DISTINCT(COLUMN_NAME), DATA_TYPE, CHARACTER_MAXIMUM_LENGTH 
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE COLUMN_NAME IN (	SELECT COLUMN_NAME 
							FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
							WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + CONSTRAINT_NAME), 'IsPrimaryKey') = 1
							AND TABLE_NAME = @table 
							AND TABLE_SCHEMA = @tblSchema))

	OPEN @tblCursor
	
	FETCH NEXT FROM @tblCursor INTO @clmName, @clmType, @clmSize
	WHILE @@FETCH_STATUS = 0 
		BEGIN
			IF(@clmSize IS NULL)
			  SET @args = CONCAT(@args , '@', @clmName, ' ', @clmType, ', ')				 
			ELSE
			BEGIN
				IF(@clmType = 'varbinary')
					SET @args  =  CONCAT(@args, '@', @clmName, ' ', @clmType, '(8000), ')
				ELSE	
					SET @args  =  CONCAT(@args, '@', @clmName, ' ', @clmType, '(', @clmSize, '), ')
			END
			
			SET @conditions = CONCAT(@conditions, @clmName, ' = @', @clmName, ' AND ')
			
			FETCH NEXT FROM @tblCursor INTO  @clmName, @clmType, @clmSize
		END

	CLOSE 		@tblCursor
	DEALLOCATE 	@tblCursor

	SET @args 		= SUBSTRING(@args ,0 , (LEN(@args)))
	SET @conditions 	= SUBSTRING(@conditions ,0 , (LEN(@conditions) - 2))	
	SET @table 			= LOWER(@table)
	
	SET @spCode = CONCAT('
		CREATE PROCEDURE ', @tblSchema, '.sp_', @table ,'_delete(', @args ,')
		AS
		BEGIN
			DECLARE @errorCode bigint
			DECLARE @errorMessage nvarchar(4000)

			BEGIN TRY
				DELETE FROM ', @tblSchema , '.', @table , ' WHERE ', @conditions ,' 
			END TRY
			BEGIN CATCH			
				SET @errorCode = (SELECT ERROR_NUMBER())
				SET @errorMessage = (SELECT ERROR_MESSAGE())
				RAISERROR(@errorMessage,16,1)
				INSERT INTO dbo.ErrorLog VALUES (@errorCode, @errorMessage, CURRENT_USER, CURRENT_TIMESTAMP)
			END CATCH
		END
	')
	
	--PRINT(@spCode)
	EXEC(@spCode)
END
GO

CREATE PROCEDURE dbo.sp_GenerateGenerators(@tableName varchar(255))
AS
BEGIN
	EXEC dbo.sp_GeneratorsInsert @table=@tableName
	EXEC dbo.sp_GeneratorsUpdate @table=@tableName
	EXEC dbo.sp_GeneratorsDelete @table=@tableName
END
GO









