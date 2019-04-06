-- Create Transactions table
DROP TABLE IF EXISTS [Admin].[utbl_Transactions]
CREATE TABLE [Admin].[utbl_Transactions](
	[TransactionID]		INT NOT NULL IDENTITY (1,1),
	[Username]			NVARCHAR(50),
	[Ammount]			FLOAT,
	[Type]				NVARCHAR(20),
	[Transaction_Date]	DATETIME
) ON [PRIMARY]
GO
---- Insert test data
--truncate table [Admin].[utbl_Transactions]
--insert into [Admin].[utbl_Transactions]
--values
--('TestKarina', '19.19','Deposit', Getdate()),
--('TestKarina', '30.19','Win', Getdate()),
--('TestKarina', '19.19','Withdrowal', Getdate())

select *
from [admin].utbl_transactions

-- chekc for bankroll function
select dbo.[udf_Bankroll]('TestKarina')

