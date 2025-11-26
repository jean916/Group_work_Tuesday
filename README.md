
Group Work members


1.Uwase Honette 27628

2.Ukwizagira Jean Bosco 27625

3.Ange UWIMBABAZI 27629

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





Hospital Management System (PL/SQL Package with Bulk Processing)
 Project Overview

This project implements a Hospital Management System using Oracle PL/SQL.
It demonstrates:

Bulk data processing

Package specification and body

Use of records, collections, cursors

Updating patient admission status

Testing procedures and functions

The system manages patients and doctors, supports bulk loading, and allows retrieval and update of patient information efficiently.

 1. Database Tables
## 1.1 Patients Table

Stores patient demographic and admission details.

CREATE TABLE patients (
    patient_id      NUMBER PRIMARY KEY,
    patient_name    VARCHAR2(100),
    age             NUMBER,
    gender          VARCHAR2(10),
    admitted_status VARCHAR2(3) DEFAULT 'NO'
);

## 1.2 Doctors Table

Stores doctor information.

CREATE TABLE doctors (
    doctor_id   NUMBER PRIMARY KEY,
    doctor_name VARCHAR2(100),
    specialty   VARCHAR2(100)
);

 2. Package Specification (hospital_pkg)

Defines:

A record type for one patient

A collection type to store multiple patients

Procedures and functions:

✔ bulk_load_patients — Insert multiple patients
✔ show_all_patients — Return all patients via REF CURSOR
✔ count_admitted — Count patients with status YES
✔ admit_patient — Update patient’s admission status
CREATE OR REPLACE PACKAGE hospital_pkg AS
    
    TYPE patient_rec IS RECORD(
        patient_id      NUMBER,
        patient_name    VARCHAR2(100),
        age             NUMBER,
        gender          VARCHAR2(10)
    );

    TYPE patient_table IS TABLE OF patient_rec;

    PROCEDURE bulk_load_patients(p_patients IN patient_table);
    FUNCTION show_all_patients RETURN SYS_REFCURSOR;
    FUNCTION count_admitted RETURN NUMBER;
    PROCEDURE admit_patient(p_id IN NUMBER);

END hospital_pkg;
/

3. Package Body

Implements:

FORALL for bulk insert

REF CURSOR for retrieval

UPDATE for admission

COMMIT for data persistence

CREATE OR REPLACE PACKAGE BODY hospital_pkg AS

    PROCEDURE bulk_load_patients(p_patients IN patient_table) IS
    BEGIN
        FORALL i IN 1..p_patients.COUNT
            INSERT INTO patients(patient_id, patient_name, age, gender)
            VALUES (
                p_patients(i).patient_id,
                p_patients(i).patient_name,
                p_patients(i).age,
                p_patients(i).gender
            );
        COMMIT;
    END bulk_load_patients;

    FUNCTION show_all_patients RETURN SYS_REFCURSOR IS
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR SELECT * FROM patients ORDER BY patient_id;
        RETURN rc;
    END show_all_patients;

    FUNCTION count_admitted RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM patients
        WHERE admitted_status = 'YES';
        RETURN v_count;
    END count_admitted;

    PROCEDURE admit_patient(p_id IN NUMBER) IS
    BEGIN
        UPDATE patients
        SET admitted_status = 'YES'
        WHERE patient_id = p_id;
        COMMIT;
    END admit_patient;

END hospital_pkg;
/

 4. Testing the Package
4.1 Bulk Insert Test
DECLARE
    v_patients hospital_pkg.patient_table := hospital_pkg.patient_table();
BEGIN
    v_patients.EXTEND(3);

    v_patients(1).patient_id := 1;
    v_patients(1).patient_name := 'Alice';
    v_patients(1).age := 25;
    v_patients(1).gender := 'F';

    v_patients(2).patient_id := 2;
    v_patients(2).patient_name := 'Brian';
    v_patients(2).age := 40;
    v_patients(2).gender := 'M';

    v_patients(3).patient_id := 3;
    v_patients(3).patient_name := 'Clara';
    v_patients(3).age := 30;
    v_patients(3).gender := 'F';

    hospital_pkg.bulk_load_patients(v_patients);
END;
/

4.2 Displaying All Patients
VARIABLE x REFCURSOR;

BEGIN
    :x := hospital_pkg.show_all_patients;
END;
/

PRINT x;

4.3 Admit Patient & Check Counts
BEGIN
    hospital_pkg.admit_patient(2);
END;
/

SELECT * FROM patients;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Total admitted: ' || hospital_pkg.count_admitted);
END;
/

 5. Expected Output
✔ Bulk loading inserts all 3 patients
✔ show_all_patients returns all records
✔ admit_patient updates admitted_status to "YES"
✔ count_admitted returns correct number of admitted patients
 6. Conclusion

This PL/SQL project demonstrates:

Efficient bulk data processing (FORALL)

Reusable and modular package architecture

Use of collections, records, cursors, and DML

Practical patient management functionality

The system is extendable and ready for additional hospital features such as appointments, billing, or ward management.

### Individual Contributions

- Denis: Implemented `bulk_load_patients` procedure and `login_failure_trigger` for security alerts.
- Janet: Designed database schema and wrote test scripts.
- [Other members]: [Their tasks...]
