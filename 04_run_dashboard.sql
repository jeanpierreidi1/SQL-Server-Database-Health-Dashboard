-- RUN THE DASHBOARD

-- Run full health check in one command
EXEC sp_RunHealthDashboard;

-- Or run individual checks
EXEC sp_CheckDatabaseSize;
EXEC sp_CheckBackupStatus;
EXEC sp_CheckActiveConnections;
EXEC sp_CheckTableStats;