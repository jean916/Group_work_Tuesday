-- PATIENTS TABLE
CREATE TABLE patients (
    patient_id      NUMBER PRIMARY KEY,
    patient_name    VARCHAR2(100),
    age             NUMBER,
    gender          VARCHAR2(10),
    admitted_status VARCHAR2(3) DEFAULT 'NO'
);

-- DOCTORS TABLE
CREATE TABLE doctors (
    doctor_id   NUMBER PRIMARY KEY,
    doctor_name VARCHAR2(100),
    specialty   VARCHAR2(100)
);

CREATE OR REPLACE PACKAGE hospital_pkg AS
    
    -- Collection type for bulk patient loading
    TYPE patient_rec IS RECORD(
        patient_id      NUMBER,
        patient_name    VARCHAR2(100),
        age             NUMBER,
        gender          VARCHAR2(10)
    );

    TYPE patient_table IS TABLE OF patient_rec;

    -- Bulk insert procedure
    PROCEDURE bulk_load_patients(p_patients IN patient_table);

    -- Function to return all patients
    FUNCTION show_all_patients RETURN SYS_REFCURSOR;

    -- Function to count admitted patients
    FUNCTION count_admitted RETURN NUMBER;

    -- Procedure to admit a patient
    PROCEDURE admit_patient(p_id IN NUMBER);

END hospital_pkg;
/
DROP TABLE patients CASCADE CONSTRAINTS;
DROP TABLE doctors CASCADE CONSTRAINTS;

CREATE TABLE patients (
    patient_id      NUMBER PRIMARY KEY,
    patient_name    VARCHAR2(100),
    age             NUMBER,
    gender          VARCHAR2(10),
    admitted_status VARCHAR2(3) DEFAULT 'NO'
);

CREATE TABLE doctors (
    doctor_id   NUMBER PRIMARY KEY,
    doctor_name VARCHAR2(100),
    specialty   VARCHAR2(100)
);

CREATE OR REPLACE PACKAGE hospital_pkg AS
    
    -- Collection type for bulk patient loading
    TYPE patient_rec IS RECORD(
        patient_id      NUMBER,
        patient_name    VARCHAR2(100),
        age             NUMBER,
        gender          VARCHAR2(10)
    );

    TYPE patient_table IS TABLE OF patient_rec;

    -- Bulk insert procedure
    PROCEDURE bulk_load_patients(p_patients IN patient_table);

    -- Function to return all patients
    FUNCTION show_all_patients RETURN SYS_REFCURSOR;

    -- Function to count admitted patients
    FUNCTION count_admitted RETURN NUMBER;

    -- Procedure to admit a patient
    PROCEDURE admit_patient(p_id IN NUMBER);

END hospital_pkg;
/
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

VARIABLE x REFCURSOR;

BEGIN
    :x := hospital_pkg.show_all_patients;
END;
/

PRINT x;
BEGIN
    hospital_pkg.admit_patient(2);
END;
/

SELECT * FROM patients;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Total admitted: ' || hospital_pkg.count_admitted);
END;
/







