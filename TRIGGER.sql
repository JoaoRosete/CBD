use AdventureServices

-- 2 A/B
CREATE TRIGGER ResetPassword
ON [sch_User].[User]
AFTER INSERT
AS
BEGIN

DECLARE @id INT
DECLARE @newPassword varchar(8)

SELECT @newPassword = CONVERT(VARCHAR(10), CRYPT_GEN_RANDOM(5), 2)

SELECT @id = UserKey
FROM INSERTED

INSERT INTO [sch_User].sentEmails([Subject], UserKey) VALUES(@newPassword, @id)

UPDATE [sch_User].[User]
SET [Password] = @newPassword,
	PasswordEncrypt = HASHBYTES('SHA1', @newPassword)
WHERE UserKey = @id;

END
GO

