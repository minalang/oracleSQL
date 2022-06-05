/*9. Ʈ�����*/

-- TCL(TRANSACTION CONTROL LANGUAGE)

----- 1. Ʈ�����-----
--������ �۾��� ����
SET AUTOCOMMIT OFF; 
SHOW AUTOCOMMIT;

--1.3 SAVEPOINT �� ROLLBACK
DELETE FROM emps WHERE department_id = 10;
SAVEPOINT delete_10;

DELETE FROM emps WHERE department_id = 20;
SAVEPOINT delete_20;

DELETE FROM emps WHERE department_id = 30;
-- 30�� �μ� ��� ������ �� �ѹ�(20�� ���� ������ ���� savepoint�� �� ���������� ��������)
ROLLBACK TO SAVEPOINT delete_20;

----- 2. LOCK -----


----- 3. �������� -----
--1. �ǽ��� ���� EMPLOYEES ���̺��� �纻 ���̺��� �����ϼ���. �纻 ���̺��� �̸���EMP_TEMP�Դϴ�.
CREATE TABLE emp_temp AS SELECT * FROM employees;

--2. EMP_TEMP ���̺��� 20�� �μ� ����� ������ �����ϰ� �ѹ� ������ �����ϼ���. �ѹ� ������ �̸��� SVPNT_DEL_20���� �մϴ�.
DELETE FROM emp_temp WHERE department_id = 20;
SAVEPOINT svpnt_del_20;

--3. 50���μ��� ����� ������ �����ϰ� �ѹ� ������ �����ϼ���. �ѹ� ������ �̸��� SVPNT_DEL_50���� �մϴ�.
DELETE FROM emp_temp WHERE department_id = 50;
SAVEPOINT svpnt_del_50;

-- 4. 60�� �μ��� ��� ������ �����ϼ���.
DELETE FROM emp_temp WHERE department_id = 60;


-- 5. ���� 60�� �μ��� ��� ������ �����ߴ� �۾��� ����ϼ���. �� ���� �۾��� ����ϸ�ȵ˴ϴ�.
ROLLBACK TO SAVEPOINT svpnt_del_50;
