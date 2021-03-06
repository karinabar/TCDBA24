--USE [master]
--GO
--CREATE LOGIN [TestAdmin_Casino] WITH PASSWORD=N'Pass.word', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
--GO
--ALTER SERVER ROLE [sysadmin] ADD MEMBER [TestAdmin_Casino]
--GO
--USE [Casino]
--GO
--CREATE USER [TestAdmin_Casino] FOR LOGIN [TestAdmin_Casino]
--GO
--USE [Casino]
--GO
--ALTER USER [TestAdmin_Casino] WITH DEFAULT_SCHEMA=[Admin]
--GO
--USE [Casino]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [TestAdmin_Casino]
--GO
--DENY UNMASK TO  [TestAdmin_Casino]

ALTER TABLE  [Admin].[utbl_Players]
ALTER COLUMN FirstName varchar(20) MASKED WITH (FUNCTION = 'default()')

ALTER TABLE  [Admin].[utbl_Players]
ALTER COLUMN LastName varchar(20) MASKED WITH (FUNCTION = 'default()')

ALTER TABLE  [Admin].[utbl_Players]
ALTER COLUMN EmailAddress varchar(50) MASKED WITH (FUNCTION = 'email()')

select *
from Admin.utbl_Players


GRANT UNMASK  TO  [TestAdmin_Casino]

EXECUTE AS USER ='TestAdmin_Casino'
select *
from Admin.utbl_Players
REVERT

select CURRENT_USER  , ORIGINAL_LOGIN( ) 
