# Group_work_Tuesday
This project implements a login security monitoring system that records all login attempts and automatically detects suspicious activity. When a user fails to log in more than twice in one day, the system triggers an alert and stores it in the security alerts table.


README – Login Security Monitoring System

This project implements a database-level security monitoring system that records all login attempts and automatically detects suspicious login behavior. When any user fails to log in more than two times in the same day, the system triggers a security alert to help protect against unauthorized access.
 Features

Records every login attempt in login_audit

Stores security notifications in security_alerts

Automatically checks daily failed attempts per user

Generates an alert after 3 failed logins

Supports saving IP/device data

Trigger-based automation (no need for manual checking)

Tables Created
1. login_audit

Stores all login attempts.
Columns:

audit_id – auto-generated ID

username – user attempting login

attempt_time – date/time (default: SYSDATE)

status – SUCCESS / FAILED

ip_address – optional client IP

2. security_alerts

Stores alerts for suspicious login patterns.
Columns:

alert_id – auto ID

username – user who failed

failed_attempts – total failures today

alert_time – SYSDATE

alert_message – reason for alert

contact_email – security team email

⚙️ Trigger Logic (Summary)

A compound trigger monitors inserts into login_audit:

Row-level section

Collects usernames of users who failed login.

Statement-level section

Counts how many failures each user has today.

If failures > 2, it inserts a new alert in security_alerts.

This avoids the mutating-table error and ensures accurate counting.

Example Inserts
INSERT INTO login_audit (username, status, ip_address)
VALUES ('keza', 'FAILED', '192.168.1.10');

INSERT INTO login_audit (username, status)
VALUES ('keza', 'FAILED');

INSERT INTO login_audit (username, status)
VALUES ('keza', 'FAILED');  -- Third failure triggers alert

Expected Results
login_audit

Shows all login attempts, successful or not.

security_alerts

Shows an alert only when:

The same user has more than 2 FAILED attempts

The failed attempts occur within the same day
