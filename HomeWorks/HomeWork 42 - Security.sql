
--- 2 ---
USE [Northwind]
CREATE LOGIN [SecurityUser2] WITH PASSWORD=N'123' MUST_CHANGE, DEFAULT_DATABASE=[Northwind], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
CREATE USER [SecurityUser2] FOR LOGIN [SecurityUser2] WITH DEFAULT_SCHEMA=[SecurityUser2]
GO
DENY ALTER ON [dbo].[Products] TO [SecurityUser2]
DENY CONTROL ON [dbo].[Products] TO [SecurityUser2]
DENY DELETE ON [dbo].[Products] TO [SecurityUser2]
DENY INSERT ON [dbo].[Products] TO [SecurityUser2]
DENY REFERENCES ON [dbo].[Products] TO [SecurityUser2]
DENY SELECT ON [dbo].[Products] TO [SecurityUser2]
DENY TAKE OWNERSHIP ON [dbo].[Products] TO [SecurityUser2]
DENY UPDATE ON [dbo].[Products] TO [SecurityUser2]
DENY VIEW CHANGE TRACKING ON [dbo].[Products] TO [SecurityUser2]
DENY VIEW DEFINITION ON [dbo].[Products] TO [SecurityUser2]
GRANT SELECT ON [dbo].[Products_ammount] TO [SecurityUser2]

--- 3 ---

USE [msdb]
GO
-- creates credential
CREATE CREDENTIAL [Backup] WITH IDENTITY = N'TCDBA1\DBBackup', SECRET = N'Pass.word'
GO
-- creates proxy
EXEC msdb.dbo.sp_add_proxy @proxy_name=N'Backup_Job',@credential_name=N'Backup', 
		@enabled=1, 
		@description=N'DBBackup'
GO
-- grants roles to the proxy
EXEC msdb.dbo.sp_grant_login_to_proxy @proxy_name=N'Backup_Job', @fixed_server_role=N'sysadmin'
GO
EXEC msdb.dbo.sp_grant_login_to_proxy @proxy_name=N'Backup_Job', @msdb_role=N'SQLAgentUserRole'
GO
CREATE LOGIN [TCDBA1\DBBackup] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO
ALTER LOGIN [DBBackup] ADD CREDENTIAL [Backup]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [TCDBA1\DBBackup]
GO
-- create job
USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Backup Full', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DB Backup', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'TCDBA1\DBBackup', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Backup Full', @server_name = N'TCDBA'
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Backup Full', @step_name=N'Backup Northwind', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [Northwind] TO  DISK = N''C:\backup\security job\Northwind\Northwind.bak'' WITH NOFORMAT, NOINIT,  NAME = N''Northwind-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N''Northwind'' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N''Northwind'' )
if @backupSetId is null begin raiserror(N''Verify failed. Backup information for database ''''Northwind'''' not found.'', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N''C:\backup\security job\Northwind\Northwind.bak'' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
', 
		@database_name=N'master', 
		@database_user_name=N'dbo', 
		@flags=4
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_update_job @job_name=N'Backup Full', 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=N'DB Backup', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'TCDBA1\DBBackup', 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''
GO
-- Job schedule
USE [msdb]
Go
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Backup Full', @name=N'Backup Full', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20190202, 
		@active_end_date=99991231, 
		@active_start_time=30000, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO

