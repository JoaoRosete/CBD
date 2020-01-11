USE master

-- Create Device for our Database
EXEC master.dbo.sp_addumpdevice  
	@devtype = N'disk',
	@logicalname = N'AdventureServices_Device', 
	@physicalname = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\AdventureServices_Device.bak'



USE AdventureServices

-- Procedure to create a job that runs every 2 hours
CREATE PROCEDURE [dbo].sp_RunEveryTwoHours
AS
BEGIN
	EXEC msdb.dbo.sp_add_schedule 
		 @schedule_name = N'RunEveryTwoHours',
		 @freq_type = 4, -- Every Day
		 @freq_subday_type = 0x8, 
		 @freq_subday_interval = 2, -- Runs every 2 hours
         @freq_interval = 1, 
         @active_start_time = 000000 --Runs at 12am
END
GO

exec [dbo].sp_RunEveryTwoHours;


-- Procedure to create a job that runs every day
CREATE PROCEDURE [dbo].sp_RunDaily
AS
BEGIN
	EXEC msdb.dbo.sp_add_schedule 
		 @schedule_name = N'RunDaily',
		 @freq_type = 4, -- Every Day
         @freq_interval = 1, 
         @active_start_time = 000000 --Runs at 12am
END
GO

exec [dbo].sp_RunDaily;


-- Procedure to create a job that runs weekly
CREATE PROCEDURE [dbo].sp_RunWeekly
AS
BEGIN
	EXEC msdb.dbo.sp_add_schedule 
        @schedule_name = N'RunWeekly',
        @freq_type = 8, --Weekly
        @freq_interval = 1, --Sunday
		@freq_recurrence_factor = 1,
        @active_start_time = 030000 --Runs at 3am
END
GO

exec [dbo].sp_RunWeekly;



-- Procedure to generate a Full Backup
CREATE PROCEDURE [dbo].CreateFullBackup
AS
BEGIN
	EXEC msdb.dbo.sp_add_job 
        @job_name = 'FullBackupDatabase'
    
    EXEC msdb.dbo.sp_add_jobstep 
        @job_name = 'FullBackupDatabase', 
        @step_name = 'step_FullBackupDatabase', 
        @subsystem = N'TSQL', 
        @command = 'FULLBACKUP DATABASDE FROM AdventureServices to AdventuresServices Device'

    EXEC msdb.dbo.sp_attach_schedule 
        @job_name ='FullBackupDatabase', 
        @schedule_name = 'RunWeekly';  

    EXEC msdb.dbo.sp_add_jobserver 
        @job_name ='FullBackupDatabase'
END
GO

exec [dbo].CreateFullBackup;

-- Procedure to generate a Differential Backup
CREATE PROCEDURE [dbo].CreateDifferentialBackup
AS
BEGIN
	EXEC msdb.dbo.sp_add_job 
        @job_name = 'DifferentialBackupDatabase'
    
    EXEC msdb.dbo.sp_add_jobstep 
        @job_name = 'DifferentialBackupDatabase', 
        @step_name = 'step_DifferentialBackupDatabase', 
        @subsystem = N'TSQL', 
        @command = 'Differential BACKUP DATABASDE FROM AdventureServices to AdventuresServices Device'

    EXEC msdb.dbo.sp_attach_schedule 
        @job_name ='DifferentialBackupDatabase', 
        @schedule_name = 'RunDaily';  

    EXEC msdb.dbo.sp_add_jobserver 
        @job_name ='DifferentialBackupDatabase'
END
GO

exec [dbo].CreateDifferentialBackup;


-- Procedure to generate a Log Backup
CREATE PROCEDURE [dbo].CreateLogBackup
AS
BEGIN
	EXEC msdb.dbo.sp_add_job 
        @job_name = 'LogBackupDatabase'
    
    EXEC msdb.dbo.sp_add_jobstep 
        @job_name = 'LogBackupDatabase', 
        @step_name = 'step_LogBackupDatabase', 
        @subsystem = N'TSQL', 
        @command = 'Log BACKUP DATABASDE FROM AdventureServices to AdventuresServices Device'

    EXEC msdb.dbo.sp_attach_schedule 
        @job_name ='LogBackupDatabase', 
        @schedule_name = 'RunEveryTwoHours';  

    EXEC msdb.dbo.sp_add_jobserver 
        @job_name ='LogBackupDatabase'
END
GO

exec [dbo].CreateLogBackup;


