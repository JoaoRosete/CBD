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
exec sp_EncryptInformation_AllUsers; -- Worked


-- CHANGE PROCEDURE resetPassword that existed on the previous Fase 1
CREATE PROCEDURE [sch_User].sp_recoverPassword(@UserKey INT, @Answer1 NVARCHAR(25), @Answer2 NVARCHAR(25), @Answer3 NVARCHAR(25))
AS
	DECLARE @newPassword NVARCHAR(10);
	IF ((SELECT count(*) FROM [sch_User].AnsweredQuestions WHERE UserKey = @UserKey) >= 3)
	BEGIN

		IF(((SELECT count(*) FROM [sch_User].AnsweredQuestions WHERE Answer = @Answer1 AND UserKey = @UserKey) = 1) 
		AND ((SELECT count(*) FROM [sch_User].AnsweredQuestions WHERE Answer = @Answer2 AND UserKey = @UserKey) = 1) 
		AND ((SELECT count(*) FROM [sch_User].AnsweredQuestions WHERE Answer = @Answer3 AND UserKey = @UserKey) = 1))
		BEGIN
			SELECT @newPassword = CONVERT(VARCHAR(10), CRYPT_GEN_RANDOM(5), 2)

			INSERT INTO [sch_User].sentEmails([Subject], UserKey) VALUES(@newPassword, @UserKey)

			UPDATE [sch_User].[User]
			SET [Password] = @newPassword,
				PasswordEncrypt = HashBytes('SHA1', @newPassword)
			WHERE UserKey = @UserKey;
		END
		ELSE
		BEGIN
			print 'Check The Answers!'
		END

	END
GO

-- Test
exec [sch_User].sp_recoverPassword 1, 'Cao', 'Agua', 'Vermelho' -- Worked


-- Procedure to authenticate using the Encrypted fields
CREATE PROCEDURE [sch_User].sp_authentication_user(@EmailAddress NVARCHAR(125), @Password NVARCHAR(125))
AS
	BEGIN
		
		OPEN SYMMETRIC KEY EncryptInformation DECRYPTION BY CERTIFICATE EncryptCertificate;
		
		If EXISTS (
		SELECT UserKey
		FROM [sch_User].[User]
		WHERE [PasswordEncrypt] = HashBytes('SHA1', @Password) AND @EmailAddress = convert(nvarchar(50),DECRYPTBYKEY(EmailEncrypt))
	)
		Print 'Sucess!';
	ELSE
		Print 'Error! Check your EmailAddress AND Password';

		CLOSE SYMMETRIC KEY EncryptInformation;
	END
GO


-- Test
exec  [sch_User].sp_authentication_user 'rosete@gmail.com', 'F493711237'; -- Done




