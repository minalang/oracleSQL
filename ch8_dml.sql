/*8. ������ ����(DML)*/

----- 2. CTAS -----
-- ���� �ִ� ���̺�� ���� ������ ���� ���̺� ����
CREATE TABLE emp1 AS SELECT * FROM employees;

-- �����ʹ� ���� �ʰ� ������ ���� ���̺� ����
CREATE TABLE emp2 AS SELECT * FROM employees WHERE 1=2;
SELECT COUNT(*) FROM emp2;


----- 3. INSERT: ���ο� �� �߰� -----
--3.1 ���̺� ���� Ȯ��
DESC departments; -- desc(=descibe)
DESC employees;

--- 3.2 ���ο� �� ����
-- ������ ���� ���� ���� �����ϴ� ���ο� ���� ����
-- ���̺� �ִ� ���� ����Ʈ ������ ���� ����
-- INSERT������ ���� ���������� ����
-- ���ڿ� ��¥���� ���� ����ǥ ���� ��
CREATE TABLE department2 AS SELECT * FROM departments;

INSERT INTO department2 
VALUES(280, 'Data Analytics', null, 1700);

INSERT INTO department2(department_id, department_name, location_id)
VALUES (280, 'Data Analytics', 1700);

SELECT * FROM department2 WHERE department_id = 280;
-- �����ߴ� INSERT������ �������
ROLLBACK;

----- 3.3 �ٸ� ���̺�κ��� �� ����-----
-- ���������� INSERT���� �ۼ�--> VALUES���� ������� ����
-- �������� �� ���� INSERT���� �� ���� ��ġ
CREATE TABLE managers AS
SELECT employee_id, first_name, job_id, salary, hire_date
FROM employees
WHERE 1=2;

INSERT INTO managers
(employee_id, first_name, job_id, salary, hire_date) -- �� �κ��� ���� ����
SELECT employee_id, first_name, job_id, salary, hire_date
FROM employees
WHERE job_id LIKE '%MAN';

SELECT * FROM managers;


----- 4. UPDATE -----
-- ������ ���� ����, �ʿ��ϴٸ� �ϳ� �̻��� �൵ ���� ����

CREATE TABLE emps AS SELECT * FROM employees;

ALTER TABLE emps
ADD (CONSTRAINT emps_emp_id_pk PRIMARY KEY (employee_id),
        CONSTRAINT emps_manager_id_fk FOREIGN KEY (manager_id)
                                REFERENCES emps (employee_id)
);

-- 4.1 ���̺� �� ����
UPDATE emps
SET salary = salary*1.1
WHERE employee_id = 103;

SELECT employee_id, first_name, salary
FROM emps
WHERE employee_id = 103;

COMMIT;

-- 4.2 ���������� ���� �� ����
SELECT employee_id, job_id, salary, manager_id
FROM emps
WHERE employee_id IN (108, 109);

UPDATE emps
SET (job_id, salary, manager_id) = (
        SELECT job_id, salary, manager_id
        FROM emps
        WHERE employee_id = 108) -- 109�� ����� ������ 108�� ����� ������ �ٲ��ּ���
WHERE employee_id = 109;

----- 5. DELETE -----
-- ������ �� ����, ���� ���Ἲ �������ǿ� ����
/*
delete: �����͸� ����, rollback������� ���� ��Ұ� ����
truncate: ���̺��� ������ �����ϸ� �����͸� ����. rollback������� ������ ���� ��� �� �� ����
drop: ���̺��� ����. �������� ���� ���� ����. rollback������� ���� ��� �Ұ�
*/

-- 5.1 �� ����
DELETE FROM emps
WHERE employee_id = 103;
-- 104�� ����� �Ŵ����� 103�� ������� �����Ǿ��ֱ� ������ 103�� ����� �������� ����
-- ���Ἲ�������ǿ� ����Ǳ� ������ �������� ����
ROLLBACK;

--5.2 �ٸ� ���̺��� �̿��� �� ����
-- �ٸ� ���̺� ���� �ٰŷ� ���̺�κ��� ���� �����ϱ� ���� �������� Ȱ��
CREATE TABLE depts AS SELECT * FROM departments;

DESC depts;

--emps���̺��� shipping�μ��� ��� ��� ������ �������� depts���̺� �˻�
DELETE FROM emps
WHERE department_id = (SELECT department_id
                                            FROM depts
                                            WHERE department_name = 'Shipping'); -- 45�� �� ����

COMMIT;

-- 5.3 RETURNING
-- DML������ ���� ������ �޴� ���� �˻��� �� �ְ� ���ִ� ��
VARIABLE emp_name VARCHAR2(50); --emp_name���� ����
VARIABLE emp_sal NUMBER;-- emp_sal���� ����
VARIABLE;

DELETE emps
WHERE employee_id = 109
RETURNING first_name, salary INTO:emp_name, :emp_sal;

PRINT emp_name;
PRINT emp_sal;

-- 6. MERGE
-- db insert, update�� �� ������ �����ϴ��� üũ�ϰ� �����ϸ� update, �������� ������ insert������ �� �ְ� ��
-- �� ���� ���̺��� �ϳ��� ���̺�� ���� �ϴµ� ���
CREATE TABLE emps_it AS SELECT * FROM employees WHERE 1=2;

INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES
    (105, 'David', 'Kim', 'DAVIDKIM', '06/03/04', 'IT_PROG');

-- EMPS_IT��EMPLOYEES ����. ������ IT_PROG�� ������� EMPLOYEES���̺��� ��ȸ �� ����
-- ���� ��� ���� ���� ��� EMPLOYEES���̺��� ������ ������Ʈ. EMPS_IT���̺� ���� ���� INSERT
MERGE INTO emps_it a -- ���̺� ��Ī a
    USING(SELECT * FROM employees where job_id = 'IT_PROG') b
    ON (a.employee_id = b.employee_id)
WHEN MATCHED THEN
    UPDATE SET
    a.phone_number = b.phone_number,
    a.hire_date = b.hire_date,
    a.job_id = b.job_id,
    a.salary = b.salary,
    a.commission_pct = b.commission_pct,
    a.manager_id = b.manager_id,
    a.department_id = b.department_id
WHEN NOT MATCHED THEN
    INSERT VALUES
    (b.employee_id, b.first_name, b.last_name, b.email,
     b.phone_number, b.hire_date, b.job_id, b.salary,
     b.commission_pct, b.manager_id, b.department_id);
-- ��� Ȯ��
SELECT * FROM emps_it;


-- 7. multiple insert
-- �ϳ��� insert ������ ���� ���� ���̺� ���ÿ� �ϳ��� ���� �Է�
-- 7.1 unconditional insert all

-- 7.2 comditional insert all
-- Ư�� ���ǵ��� ����Ͽ� �� ���ǿ� �´� ����� ���ϴ� ���̺� ������ ����
CREATE TABLE emp_10 AS SELECT * FROM employees WHERE 1=2;

CREATE TABLE emp_20 AS SELECT * FROM employees WHERE 1=2;

INSERT ALL
    WHEN department_id = 10 THEN
        INTO emp_10 VALUES
                (employee_id, first_name,last_name, email,
                phone_number, hire_date, job_id, salary,
                commission_pct, manager_id, department_id)
    WHEN department_id = 20 THEN
            INTO emp_20 VALUES
                     (employee_id, first_name,last_name, email,
                      phone_number, hire_date, job_id, salary,
                      commission_pct, manager_id, department_id)
    SELECT * FROM employees;
    
SELECT * FROM emp_10;
-- 7.3 conditional insert first
--ù���� when������ ������ ������ ��� ������ when���� �������� ����
-- ���̺� �����
CREATE TABLE emp_sal5000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal10000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal15000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;

-- ���ǹ����� �� ���� 
INSERT FIRST
    WHEN salary <= 5000 THEN
        INTO emp_sal5000 VALUES(employee_id, first_name, salary)
    WHEN salary <= 10000 THEN
        INTO emp_sal10000 VALUES(employee_id, first_name, salary)
    WHEN salary <= 15000 THEN
        INTO emp_sal15000 VALUES(employee_id, first_name, salary)
    SELECT employee_id, first_name, salary FROM employees;

-- �� ���̺� �� ��� ���Ҹ� �������� Ȯ��
SELECT COUNT(*) FROM emp_sal5000;
SELECT COUNT(*) FROM emp_sal10000;
SELECT COUNT(*) FROM emp_sal15000;

-- 7.4 PIVOTING INSERT
-- ������������ͺ��̽��� �����������ͺ��̽� ������ ���� ��



------- 8. �������� ------
/*1. EMPLOYEES ���̺� �ִ� �����͸� �� ������ ���� �����ϰ� �ͽ��ϴ�. �����ȣ,
����̸�, �޿�, ���ʽ����� �����ϱ� ���� ������ �����͸� ���� ���̺���
EMP_SALARY_INFO�̶�� �̸����� �����ϼ���. �׸��� �����ȣ, ����̸�, �Ի���,
�μ���ȣ�� �����ϱ� ���� ������ �����͸� ���� ���̺��� EMP_HIREDATE_INFO��
�� �̸����� �����ϼ���.*/
CREATE TABLE emp_salary_info AS SELECT employee_id, first_name, salary, commission_pct FROM employees;
CREATE TABLE emp_hiredate_info AS SELECT employee_id, first_name, hire_date, job_id FROM employees;


/*2. EMPLOYEES ���̺� ���� �����͸� �߰��ϼ���.
�����ȣ : 1030
�� : KilDong
�̸� : Hong
�̸��� : HONGKD
��ȭ��ȣ : 010-1234-5678
�Ի��� : 2018/03/20
�������̵� : IT_PROG
�޿� : 6000
���ʽ��� : 0.2
�Ŵ�����ȣ : 103
�μ���ȣ : 60*/
INSERT INTO emps VALUES(1030, 'Kildong', 'Hong', 'HONGKD', '010-1234-5678', '18/03/20', 'IT_PROG',6000, 0.2, 103, 60);

/*3. 1030�� ����� �޿��� 10% �λ��Ű����.*/
UPDATE emps
SET salary = salary*1.1
WHERE employee_id = 1030;

SELECT * FROM emps WHERE employee_id = 1030;
/*4. 1030�� ����� ������ �����ϼ���*/
DELETE FROM emps
WHERE employee_id = 1030;

/*5. ������̺��� �̿��Ͽ�, 2001����� 2003������� ������ �ٹ��� ������� ������̵�,
�̸�, �Ի���, ������ ����ϼ���.
����1) �� ������ �ش��ϴ� ���̺��� �����ϼ���. �Ӽ��� ������̵�, �̸�, �Ի���, ����
�Դϴ�. ������ ������ ũ�⸦ �����ϼ���. ���̺��̸��� ��emp_yr_������ ��������
�����ϼ���.
����2) ���� ���� �Ի��Ͽ��� ������ ����ϼ���. �� �̸��� ��yr���̰�, 4�ڸ� ���ڷ� ǥ��
�ϼ���.
����3) INSERT ALL �������� �ۼ��ϼ���.*/
-- ���̺� ����
CREATE TABLE emp_yr_2001 (
            employee_id NUMBER(6, 0),
            first_name VARCHAR(20),
            hire_date DATE,
            yr VARCHAR(20)); 
CREATE TABLE emp_yr_2002 (
            employee_id NUMBER(6, 0),
            first_name VARCHAR(20),
            hire_date DATE,
            yr VARCHAR(20));
CREATE TABLE emp_yr_2003 (
            employee_id NUMBER(6, 0),
            first_name VARCHAR(20),
            hire_date DATE,
            yr VARCHAR(20));

-- �� ����
INSERT ALL
    WHEN TO_CHAR(hire_date, 'RRRR') = '2001' THEN
        INTO emp_yr_2001 VALUES(employee_id, first_name, hire_date,  yr)
    WHEN TO_CHAR(hire_date, 'RRRR') = '2002' THEN
        INTO emp_yr_2002 VALUES(employee_id, first_name, hire_date,  yr)
    WHEN TO_CHAR(hire_date, 'RRRR') = '2003' THEN
        INTO emp_yr_2003 VALUES(employee_id, first_name, hire_date,  yr)
    SELECT employee_id, first_name, hire_date,
        TO_CHAR(hire_date, 'RRRR') AS yr FROM employees;
    
SELECT * FROM emp_yr_2001;

/*6. ���� 5���� ����3�� �񱳿����ڸ� ����Ͽ�, INSERT FIRST �������� �ۼ��ϼ���*/
INSERT FIRST
    WHEN hire_date <= '01/12/31' THEN
        INTO emp_yr_2001 VALUES(employee_id, first_name, hire_date, yr)
    WHEN hire_date <= '02/12/31' THEN
        INTO emp_yr_2002 VALUES(employee_id, first_name, hire_date, yr)
    WHEN hire_date <= '03/12/31' THEN
        INTO emp_yr_2003 VALUES(employee_id, first_name, hire_date, yr)
    SELECT employee_id, first_name, hire_dtae, TO_CHAR(hire_date, 'RRRR') AS yr FROM employees;

/*7. Employees ���̺��� ����� ������ �Ʒ��� �� ���̺� ���� �����ϼ���.
����1) emp_personal_info ���̺��� employee_id, first_name, last_name, email,
phone_number�� ����ǵ��� �ϼ���.
����2) emp_office_info ���̺��� employee_id, hire_date, salary, commission_pct,
manager_id, department_id�� ����ǵ��� �ϼ���.*/
CREATE TABLE emp_personal_info AS SELECT employee_id, first_name, last_name, email, phone_number FROM employees;
CREATE TABLE emp_office_info AS SELECT employee_id, hire_date, salary, commission_pct, manager_id, department_id FROM employees;
INSERT ALL
    INTO emp_personal_info VALUES
        (employee_id, first_name, last_name, email, phone_number)
    INTO emp_office_info VALUES
        (employee_id, hire_date, salary, commission_pct, manager_id, department_id)
    SELECT * FROM employees;

SELECT * FROM emp_personal_info;

/*8. Employees ���̺��� ����� ������ �Ʒ��� �� ���̺� ���� �����ϼ���.
����1) ���ʽ��� �ִ� ������� ������ emp_comm ���̺� �����ϼ���.
����2) ���ʽ��� ���� ������� ������ emp_nocomm ���̺� �����ϼ���*/
CREATE TABLE emp_comm AS SELECT employee_id, first_name, salary, commission_pct FROM employees WHERE 1=2;
CREATE TABLE emp_nocomm AS SELECT employee_id, first_name, salary, commission_pct FROM employees WHERE 1=2;


INSERT FIRST
    WHEN commission_pct IS NOT NULL THEN
        INTO emp_comm VALUES(employee_id, first_name, salary, commission_pct)
    WHEN commission_pct IS NULL THEN
        INTO emp_nocomm VALUES(employee_id, first_name, salary, commission_pct)
    SELECT employee_id, first_name, salary, commission_pct FROM employees;

SELECT * FROM emp_nocomm;  
