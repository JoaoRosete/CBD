-- CREATE LOGINS
USE master;
GO

CREATE LOGIN login_Administrador WITH PASSWORD = 'passAdmin';
GO
CREATE LOGIN login_Gestor_de_Marketing WITH PASSWORD = 'passGestor';
GO
CREATE LOGIN login_Utilizador_Anonimo WITH PASSWORD = 'passUtilizadorA';
GO
-- Dúvidas
CREATE LOGIN login_Utilizador_Registado WITH PASSWORD = 'passUtilizadorR';
GO


-- CREATE USERS
USE AdventureServices;

CREATE USER user_Administrador FOR LOGIN login_Administrador;
GO
CREATE USER user_Gestor_de_Marketing FOR LOGIN login_Gestor_de_Marketing;
GO
CREATE USER user_Utilizador_Anonimo FOR LOGIN login_Utilizador_Anonimo WITH DEFAULT_SCHEMA = [sch_Product];
GO
CREATE USER user_Utilizador_Registado FOR LOGIN login_Utilizador_Registado WITH DEFAULT_SCHEMA = [sch_Customer];
GO

-- CREATE ROLES
CREATE ROLE role_managment_all
GRANT SELECT,INSERT, UPDATE ON SCHEMA::[sch_Admin] TO role_managment_all
GRANT SELECT,INSERT, UPDATE ON SCHEMA::[sch_Customer] TO role_managment_all
GRANT SELECT,INSERT, UPDATE ON SCHEMA::[sch_Location] TO role_managment_all
GRANT SELECT,INSERT, UPDATE ON SCHEMA::[sch_Product] TO role_managment_all
GRANT SELECT,INSERT, UPDATE ON SCHEMA::[sch_Sales] TO role_managment_all
GRANT SELECT,INSERT, UPDATE ON SCHEMA::[sch_User] TO role_managment_all
EXEC sp_addrolemember 'role_managment_all', 'user_Administrador';


CREATE ROLE role_view_promotion_campaigns
GRANT SELECT ON OBJECT::[sch_Sales].Promotion TO role_view_promotion_campaigns
EXEC sp_addrolemember 'role_view_promotion_campaigns', 'user_Gestor_de_Marketing';


CREATE ROLE role_view_products
GRANT SELECT ON SCHEMA::[sch_Product] TO role_view_products
EXEC sp_addrolemember 'role_view_products', 'user_Utilizador_Anonimo';



-- Tests

	-- user_Administrador                   
	EXECUTE AS USER = 'user_Administrador';
	GO
	SELECT * FROM  sch_Customer.Customer;
	SELECT * FROM  sch_Product.Product;
	GO
	REVERT
	GO

	-- user_Gestor_de_Marketing
	EXECUTE AS USER = 'user_Gestor_de_Marketing';
	GO 
	SELECT * FROM sch_Sales.Promotion;
	GO
	REVERT
	GO 

	-- user_Utilizador_Anonimo
	EXECUTE AS USER = 'user_Utilizador_Anonimo'
	GO 
	SELECT * FROM sch_Product.Product
	SELECT * FROM sch_Product.Description
	GO
	REVERT 
	GO










