# 🏥 SQL Server Database Health Dashboard

> **A T-SQL stored procedure toolkit that automates daily SQL Server health checks — monitoring database space, backup status, active connections, and table statistics with built-in alerts and a DBA maintenance log.**

---

## 📌 Project Overview

This project simulates the daily health check workflow of a Junior Database Administrator working in a managed services environment. Instead of manually running individual queries across multiple system views, this toolkit consolidates all critical checks into a single stored procedure — `sp_RunHealthDashboard` — that can be executed at the start of every shift to get an immediate picture of database health.

Built entirely in T-SQL for Microsoft SQL Server, this project demonstrates core DBA skills including database monitoring, proactive maintenance, stored procedure development, and shift documentation.

---

## 🎯 Why This Project Exists

Every DBA shift starts with the same question: **"Is everything healthy?"**

This dashboard answers it in one command:

```sql
EXEC sp_RunHealthDashboard;
```

---

## 🏗️ Architecture

```
SQL Server Instance
        │
        ▼
┌─────────────────────────────────────────┐
│         sp_RunHealthDashboard           │  ← Run this every shift
│                                         │
│  ├── sp_CheckDatabaseSize              │  ← Space usage + alerts
│  ├── sp_CheckBackupStatus              │  ← Backup overdue detection
│  ├── sp_CheckActiveConnections         │  ← Live connection monitor
│  └── sp_CheckTableStats               │  ← Table row counts + sizes
└─────────────────────────────────────────┘
        │
        ▼
DBA_MaintenanceLog Table
└── Documents all findings and actions taken per shift
```

---

## 📁 Repository Structure

```
sql-server-health-dashboard/
│
├── 01_create_database.sql       ← Sample database and tables
├── 02_stored_procedures.sql     ← All 5 stored procedures
├── 03_maintenance_log.sql       ← Shift documentation table
├── 04_run_dashboard.sql         ← Execute the full dashboard
└── README.md
```

---

## 🔧 Stored Procedures

| Procedure | Purpose | Alert Levels |
|---|---|---|
| `sp_CheckDatabaseSize` | Monitor file sizes and free space | ✅ OK / 🟡 MONITOR (>70%) / ⚠️ WARNING (>85%) |
| `sp_CheckBackupStatus` | Verify last backup date and recency | ✅ OK / ⚠️ WARNING (>24 hrs) / ❌ NEVER BACKED UP |
| `sp_CheckActiveConnections` | Monitor live connections by user and host | Informational |
| `sp_CheckTableStats` | Track row counts and table sizes | Informational |
| `sp_RunHealthDashboard` | Runs all checks in one command | Combined output |

---

## 🚀 How to Run

### Prerequisites
- Microsoft SQL Server (Express edition is free)
- SQL Server Management Studio (SSMS)

### Setup Steps

**Step 1 — Create the sample database:**
```sql
-- Run in SSMS
01_create_database.sql
```

**Step 2 — Build the stored procedures:**
```sql
02_stored_procedures.sql
```

**Step 3 — Create the maintenance log:**
```sql
03_maintenance_log.sql
```

**Step 4 — Run the full health dashboard:**
```sql
EXEC sp_RunHealthDashboard;
```

**Or run individual checks:**
```sql
EXEC sp_CheckDatabaseSize;
EXEC sp_CheckBackupStatus;
EXEC sp_CheckActiveConnections;
EXEC sp_CheckTableStats;
```

---

## 📊 Sample Dashboard Output

```
============================================
 DBA HEALTH DASHBOARD — 2026-07-07 00:15:42
============================================

--- 1. DATABASE SIZE & SPACE ---
database_name          file_type   total_size_mb   used_mb   free_mb   used_pct   space_status
HealthDashboard_Demo   ROWS            8.00          3.44      4.56      43.0      ✅ OK
HealthDashboard_Demo   LOG             8.00          1.18      6.82      14.8      ✅ OK

--- 2. BACKUP STATUS ---
database_name          last_backup_date      hours_since_backup   backup_status
HealthDashboard_Demo   2026-07-06 22:00:00   2                    ✅ OK
master                 2026-07-05 22:00:00   26                   ⚠️ WARNING — Backup overdue

--- 3. ACTIVE CONNECTIONS ---
database_name          connection_count   login_name   client_host
HealthDashboard_Demo   3                  sa           DESKTOP-DBA01

--- 4. TABLE STATISTICS ---
table_name    row_count   total_size_mb   used_size_mb
Orders        5           0.016           0.008
Customers     5           0.016           0.008

============================================
 Dashboard complete. All checks passed.
============================================
```

---

## 📋 DBA Maintenance Log

All findings are documented in the `DBA_MaintenanceLog` table — simulating shift handoff documentation used in managed services environments:

```sql
-- Log a finding
INSERT INTO DBA_MaintenanceLog
    (CheckType, DatabaseName, FindingStatus, Notes, ActionTaken)
VALUES
    ('Backup Status Check',
     'master',
     'WARNING',
     'Last backup was 26 hours ago — overdue.',
     'Ran manual full backup. Scheduled automated job for 2 AM daily.');

-- View shift log
SELECT LogDate, CheckType, FindingStatus, Notes, ActionTaken
FROM DBA_MaintenanceLog
ORDER BY LogDate DESC;
```

---

## 💡 Key Features

- **Single-command health check** — `sp_RunHealthDashboard` consolidates all monitoring into one execution
- **Automated space alerts** — Three-tier warning system (OK / MONITOR / WARNING) based on percentage thresholds
- **Backup overdue detection** — Automatically flags databases not backed up within 24 hours
- **Maintenance log** — Documents all findings and corrective actions per shift for audit and handoff purposes
- **Modular design** — Each stored procedure can be run independently or as part of the full dashboard

---

## 🧰 Tech Stack

| Component | Technology |
|---|---|
| Database | Microsoft SQL Server (Express) |
| Language | T-SQL |
| IDE | SQL Server Management Studio (SSMS) |
| Monitoring | System DMVs (sys.databases, sys.database_files, sys.sysprocesses) |
| Version Control | Git / GitHub |

---

## 📈 Skills Demonstrated

- Stored procedure design and development in T-SQL
- Database monitoring using SQL Server system views and DMVs
- Proactive maintenance — space monitoring, backup validation, connection tracking
- DBA documentation — maintenance log table for shift handoff
- Alert logic — conditional health status using T-SQL CASE expressions
- Disaster recovery awareness — backup recency monitoring

---

## 👤 Author

**Jean Pierre Idi**
M.S. Business Informatics — Northern Kentucky University (2025)
📧 jeanpierreidi1@gmail.com | 🔗 github.com/jeanpierreidi1
