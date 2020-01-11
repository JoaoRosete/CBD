USE AdventureServices;

CREATE MASTER KEY ENCRYPTION 
BY PASSWORD = 'EncryptionKey';

CREATE CERTIFICATE EncryptCertificate
WITH SUBJECT='Certificate_EncryptCertificate';


