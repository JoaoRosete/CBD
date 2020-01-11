USE AdventureServices;

-- CREATE MASTER KEY ENCRYPTION
CREATE MASTER KEY ENCRYPTION 
BY PASSWORD = 'EncryptionKey';

-- CREATE CERTIFICATE
CREATE CERTIFICATE EncryptCertificate
WITH SUBJECT='Certificate_EncryptCertificate';

-- CREATE SYMMETRIC KEY => ADD TO OUR CERTIFICATE
Create SYMMETRIC KEY EncryptInformation
With Algorithm = AES_256  
ENCRYPTION BY CERTIFICATE EncryptCertificate;


-- CHANGE OUR TABLE USERS AND ADD EmailEncrypt AND PasswordEncrypt
ALTER TABLE [sch_User].[User] ADD EmailEncrypt VARBINARY(256);
ALTER TABLE [sch_User].[User] ADD PasswordEncrypt VARBINARY(256);

-- PROCEDURE TO ENCRYPT => EmailEncrypt AND PasswordEncrypt OF ALL USERS
CREATE PROCEDURE sp_EncryptInformation_AllUsers
AS
	DECLARE @userID INT;
	DECLARE @password NVARCHAR(55);
	DECLARE @email NVARCHAR(55);

	IF((SELECT COUNT(*) FROM [sch_User].[User]) > 0)
		BEGIN
			
			DECLARE cursorUsers CURSOR
			FOR 
				SELECT UserKey, EmailAddress, [Password] 
				FROM [sch_User].[User];

			OPEN cursorUsers;

			FETCH NEXT FROM cursorUsers 
			INTO @userID, @email, @password

			OPEN SYMMETRIC KEY EncryptInformation DECRYPTION BY CERTIFICATE EncryptCertificate;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				UPDATE [sch_User].[User]
				SET EmailEncrypt = ENCRYPTBYKEY(KEY_GUID('EncryptInformation'), @email),
					PasswordEncrypt = HashBytes('SHA1', @password)
				WHERE UserKey = @userID;

				FETCH NEXT FROM cursorUsers 
				INTO @userID, @email, @password
			END;
			
			CLOSE cursorUsers;
			DEALLOCATE cursorUsers;

			CLOSE SYMMETRIC KEY EncryptInformation;
		END

GO

-- TEST
exec sp_EncryptInformation_AllUsers;



