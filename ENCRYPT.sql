use AdventureServices;

-- Encriptar Password dos Utilizadores

SELECT * FROM sch_User.[User]

SELECT HashBytes('SHA1', [Password])
FROM sch_User.[User]
GROUP BY UserKey, [Password]

CREATE PROCEDURE sp_Encrypt_Users_Password
AS
	declare @passwordEncrypt VarBinary(256);
	
	IF((SELECT * FROM [sch_User].[User]) != 0)
		BEGIN
				
			

		END

GO
