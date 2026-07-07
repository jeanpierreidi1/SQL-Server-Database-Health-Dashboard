-- BUILD THE HEALTH CHECK STORED PROCEDURES

-- SP 1. Database size & space usage
CREATE PROCEDURE sp_CheckDatabaseSize
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        DB_NAME()                               AS database_name,
        name                                    AS file_name,
        type_desc                               AS file_type,
        ROUND(size * 8.0 / 1024, 2)            AS total_size_mb,
        ROUND(FILEPROPERTY(name,
            'SpaceUsed') * 8.0 / 1024, 2)      AS used_mb,
        ROUND((size - FILEPROPERTY(name,
            'SpaceUsed')) * 8.0 / 1024, 2)     AS free_mb,
        ROUND(FILEPROPERTY(name, 'SpaceUsed')
            * 100.0 / size, 1)                  AS used_pct,
        CASE
            WHEN FILEPROPERTY(name, 'SpaceUsed')
                * 100.0 / size > 85
                THEN '⚠️ WARNING — Low space'
            WHEN FILEPROPERTY(name, 'SpaceUsed')
                * 100.0 / size > 70
                THEN 'MONITOR — Getting full'
            ELSE '✅ OK'
        END                                     AS space_status
    FROM sys.database_files;
END;
GO

-- SP 2: Backup Status Check 
CREATE PROCEDURE sp_CheckBackupStatus
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        d.name                                  AS database_name,
        MAX(b.backup_finish_date)               AS last_backup_date,
        DATEDIFF(HOUR,
            MAX(b.backup_finish_date),
            GETDATE())                          AS hours_since_backup,
        CASE
            WHEN MAX(b.backup_finish_date) IS NULL
                THEN '❌ NEVER BACKED UP'
            WHEN DATEDIFF(HOUR,
                MAX(b.backup_finish_date),
                GETDATE()) > 24
                THEN '⚠️ WARNING — Backup overdue'
            ELSE '✅ OK'
        END                                     AS backup_status
    FROM sys.databases d
    LEFT JOIN msdb.dbo.backupset b
        ON d.name = b.database_name
        AND b.type = 'D'  -- Full backups only
    WHERE d.name NOT IN ('tempdb')
    GROUP BY d.name
    ORDER BY hours_since_backup DESC;
END;
GO

-- SP 3: Active Connections Monitor
CREATE PROCEDURE sp_CheckActiveConnections
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        DB_NAME(dbid)                           AS database_name,
        COUNT(dbid)                             AS connection_count,
        loginame                                AS login_name,
        hostname                                AS client_host
    FROM sys.sysprocesses
    WHERE dbid > 0
    GROUP BY dbid, loginame, hostname
    ORDER BY connection_count DESC;
END;
GO

-- SP 4: Table Row Counts 
CREATE PROCEDURE sp_CheckTableStats
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        t.name                                  AS table_name,
        p.rows                                  AS row_count,
        ROUND(SUM(a.total_pages) * 8.0
            / 1024, 3)                          AS total_size_mb,
        ROUND(SUM(a.used_pages) * 8.0
            / 1024, 3)                          AS used_size_mb
    FROM sys.tables t
    JOIN sys.indexes i
        ON t.object_id = i.object_id
    JOIN sys.partitions p
        ON i.object_id = p.object_id
        AND i.index_id = p.index_id
    JOIN sys.allocation_units a
        ON p.partition_id = a.container_id
    GROUP BY t.name, p.rows
    ORDER BY row_count DESC;
END;
GO

-- SP 5: Full Health Dashboard — Run This Every Shift
CREATE PROCEDURE sp_RunHealthDashboard
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '============================================';
    PRINT ' DBA HEALTH DASHBOARD — ' + CONVERT(VARCHAR, GETDATE(), 120);
    PRINT '============================================';

    PRINT '';
    PRINT '--- 1. DATABASE SIZE & SPACE ---';
    EXEC sp_CheckDatabaseSize;

    PRINT '';
    PRINT '--- 2. BACKUP STATUS ---';
    EXEC sp_CheckBackupStatus;

    PRINT '';
    PRINT '--- 3. ACTIVE CONNECTIONS ---';
    EXEC sp_CheckActiveConnections;

    PRINT '';
    PRINT '--- 4. TABLE STATISTICS ---';
    EXEC sp_CheckTableStats;

    PRINT '';
    PRINT '============================================';
    PRINT ' Dashboard complete. All checks passed.';
    PRINT '============================================';
END;
GO