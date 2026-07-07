-- Step 4: ADD A MAINTENANCE LOG TABLE

-- Track all maintenance activities — like a DBA shift log
CREATE TABLE DBA_MaintenanceLog (
    LogID           INT IDENTITY PRIMARY KEY,
    LogDate         DATETIME DEFAULT GETDATE(),
    CheckType       VARCHAR(100),
    DatabaseName    VARCHAR(100),
    FindingStatus   VARCHAR(20),
    Notes           TEXT,
    ActionTaken     TEXT,
    DBAName         VARCHAR(100) DEFAULT 'Jean Pierre Idi'
);

-- Log a finding from your health check
INSERT INTO DBA_MaintenanceLog
    (CheckType, DatabaseName, FindingStatus, Notes, ActionTaken)
VALUES
    ('Backup Status Check',
     'HealthDashboard_Demo',
     'WARNING',
     'Last backup was 26 hours ago — overdue.',
     'Ran manual full backup. Scheduled automated job for 2 AM daily.'),

    ('Space Usage Check',
     'HealthDashboard_Demo',
     'OK',
     'Database at 42% capacity — within normal range.',
     'No action required. Monitored and logged.'),

    ('Active Connections',
     'HealthDashboard_Demo',
     'OK',
     '3 active connections — normal for off-peak hours.',
     'No action required.');

-- View shift log
SELECT
    LogDate,
    CheckType,
    FindingStatus,
    Notes,
    ActionTaken
FROM DBA_MaintenanceLog
ORDER BY LogDate DESC;