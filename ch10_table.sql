/* 10. ���̺� ������ ���� */

----- 1. ���̺� ���� -----
--- 1.1 �̸� ����� ��Ģ
CREATE TABLE "Test" (c1 VARCHAR2(1)); --�����ǥ�� ������ ��/�ҹ��� ����
INSERT INTO "Test" VALUES('X');
SELECT * FROM "Test";

--- 1.2 ������Ÿ��
--- 1.3 CREATE TABLE
-- ������ ���Ǿ� ����
CREATE TABLE dept2(
    deptno  NUMBER(2), -- ���ڸ��� ���� ������Ÿ��
    dname   VARCHAR2(14), --�ִ� 4000byteũ�⸦ ���� �������� ���� ������. �Է��� ��ŭ�� ������� �Ҵ��� 
    loc VARCHAR2(13));

-- ���̺��� ���� Ȯ��
DESCRIBE dept2;

--- 1.4 ���������� ����� ������ ����: CTAS������ �̿��� ���̺� ����
CREATE TABLE emp_dept50 AS 
SELECT employee_id, first_name, salary*12 as ann_sal, hire_date, job_id
FROM employees
WHERE department_id = 50;

----- 2. ���̺� ���� ����(ALTER TABLE) -----
--- 2.2 �� �߰�
/* ALTER TABLE���忡 ADD���� ����Ͽ� ���� �߰�
���ο� ���� ������ ���� ��*/

-- ���ο� �� �߰�
ALTER TABLE emp_dept50
ADD(job VARCHAR2(10));

SELECT * FROM emp_dept50;

--- 2.3 �� ����
/* ALTER TABLE���忡 MODIFY���� ����Ͽ� ���� ����
������ �����Ͱ� �ջ�ǰ� ũ�⸦ ������ ���� ����*/

-- first_name�� ũ�� ����
ALTER TABLE emp_dept50
MODIFY(first_name VARCHAR2(30));

-- ��, ���� ũ�⸦ ���� �� �ֵ� �����͸� �Ѽ��ϵ��� ���� ���� ����. FIRST_NAME������ ���� �� �̸��� 8byte. ���� �� ���� ����
ALTER TABLE emp_dept50
MODIFY(first_name VARCHAR2(7));  -- �����޼���: �Ϻ� ���� �ʹ� Ŀ�� �� ���̸� ���� �� ����

--- 2.4 �� ����
/* ALTER TABLE���� DROP COLUMN���� �Բ� ����Ͽ� ���̺��� �� ����
�� ���� �ϳ��� ���� ������ �� ����
���̺� ���� �� ���̺� ���� �ϳ� �̻� �־����
������ ���� ������ �� ����*/

-- JOB�� ����
ALTER TABLE emp_dept50
DROP COLUMN job;

--- 2.5 �� �̸� ����
/* RENAME COLUMN ���� ����Ͽ� ���̺��� �� �̸� ���� */
ALTER TABLE emp_dept50
RENAME COLUMN job TO job_id;

-- ������ Ȯ��
DESC emp_dept50;

--- 2.6 SET UNUSED�ɼǰ� DROP UNUSED �ɼ�
--- 1) SET UNUSED
/* ������ ���̺��� �� �࿡�� �ش� ���� ���ŵ����� ������, 
������ �ʴ� ���� ǥ�õ� ���� �����Ͱ� ���Ƶ� ������ ������ ó���Ǹ� �׼��� �� �� ����
SELECT�� DESCRIBE�� ���� �߿� ǥ�õ��� �ʴ´�*/ 

-- ������� �ʴ� ���� ����
ALTER TABLE emp_dept50 SET UNUSED(first_name);
-- Ȯ��
DESC emp_dept50;

--- 2) DROP UNUSED COLUMNS
/*���̺��� ���� ������ �ʾҴٰ� ǥ�õ� ��� ���� ����*/

ALTER TABLE emp_dept50 DROP UNUSED COLUMNS;

-- SET USED�� �������� ����. ALTER TABLE������ �ǵ��� �� ����

---2.7 ��ü �̸� ����
RENAME emp_dept50 TO employees_dept50;
--�� �̸� ����: ALTER TABLE������ RENAME COLUMN�� ���
-- ALTER TABLE table_name RENAME COLUMN old_name TO new_name

----- 3. ���̺� ����(DROP) -----
/* ��� �����Ϳ� ���� ����, �ε��� ���� �ѹ� X */
DROP TABLE employees_dept50;

DESC employees_dept50; -- ORA-04043: employees_dept50 ��ü�� �������� �ʽ��ϴ�.

----- 4. ���̺� ������ ����(TRUNCATE) -----
/* ���̺��� ��� �� ����, �ѹ� X, ��������δ� DELETE���� ����� �� ���� ���� */
TRUNCATE TABLE emp2;

SELECT * FROM emp2;

----- 5. �������� -----
-- 1��

CREATE TABLE member(
    user_id VARCHAR2(15)    NOT NULL,
    user_name    VARCHAR2(20)   NOT NULL,
    phone   VARCHAR2(15),
    pw  VARCHAR2(15)    NOT NULL,
    email VARCHAR(100)
    );
    
-- 2��
/*2. ����ھ��̵�, �̸�, ��й�ȣ, ��ȭ��ȣ, �̸����� �����ϴ� ������ �ۼ��ϼ���.
- user123, �����, a1234567890, 011-234-5678, user@user.com*/
DELETE FROM member
WHERE user_id = 'user123';

INSERT INTO member (user_id, user_name, pw, phone, email)
VALUES('user123', '�����', 'a1234567890', '011-234-5678', 'user@user.com');

-- 3��
/* 3. ����ھ��̵� user123�� ������� ��� ������ ��ȸ�ϼ���. */
SELECT * 
FROM member
WHERE user_id = 'user123';

-- 4�� 
/*����ھ��̵� user123�� ������� �̸�, ��й�ȣ, ��ȭ��ȣ, �̸����� �����ϼ���.
- ȫ�浿, a1234, 011-222-3333, user@user.co.kr*/
UPDATE member
SET user_name = 'ȫ�浿', pw = 'a1234', phone = '011-222-3333', email = 'user@user.co.kr'
WHERE user_id = 'user123';

-- 5��
/* ����ھ��̵� user123�̰� ��й�ȣ�� a1234�� ȸ���� ������ �����ϼ���.*/
DELETE FROM member
WHERE user_id = 'user123' and pw = 'a1234';

-- 6��
/* ȸ�� ������ �����ϴ� ���̺�(member)�� ��� ���� �����ϼ���. TRUNCATE ������
�̿��ϼ���*/
TRUNCATE TABLE member;

-- 7��
DROP TABLE member;