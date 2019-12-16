use AdventureServices

-- Autenticar um Customer
CREATE FUNCTION [sch_User].fn_authUser(@EmailAddress NVARCHAR(25), @Password NVARCHAR(25))
RETURNS INT
AS
BEGIN
	DECLARE @result int
	SET @result = 0

	SELECT @result = UserKey
	FROM [sch_User].[User]
	WHERE EmailAddress = @EmailAddress AND [Password] = @Password

	RETURN @result
END
GO








