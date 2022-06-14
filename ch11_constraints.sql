/* 11. ��������(Constraints) */

----- 1. ���������̶�? -----
SELECT * FROM USER_CONSTRAINTS WHERE table_name = 'EMPLOYEES';

--- 1.2 �� ���� �������� ---
CREATE TABLE emp4(
    empno NUMBER(4) CONSTRAINT emp4_empno_pk PRIMARY KEY,
    ename  VARCHAR2(10) NOT NULL,
    sal NUMBER(7, 2)    CONSTRAINT emp4_sal_ck  CHECK(sal<=10000),
    deptno  NUMBER(2)   CONSTRAINT emp4_deptno_dept_deptid_fk  REFERENCES departments(department_id)
    );

---1.3 ���̺� ���� �������� ---
-- �ϳ� �̻��� ���� �����ϰ� ���̺��� �� ���ǿʹ� ���������� ����, NOT NULL���������� ������ �� ����
CREATE TABLE emp5   (
    empno   NUMBER(4),
    ename   VARCHAR2(10)    NOT NULL,
    sal NUMBER(7, 2),
    deptno  NUMBER(2),
    CONSTRAINT  emp5_empno_pk  PRIMARY KEY (empno),
    CONSTRAINT  emp5_sal_ck CHECK(sal<=10000),
    CONSTRAINT  emp5_deptno_dept_deptid_fk
                            FOREIGN KEY (deptno)   REFERENCES  departments(department_id)
    );

----- 2. �������� ���� -----

--- 2.1 NOT NULL ��������
--- 2.2 PRIMARY KEY ��������
-- -> ���� ���̺����� ������ ��ο��� ���ǰ���

-- 2.3 UNIQUE ��������
ALTER TABLE emp4
ADD (nickname VARCHAR2(20));

SELECT * FROM emp4;
DESC emp4;
ALTER TABLE emp4
ADD CONSTRAINT emp4_nickname_uk UNIQUE(nickname);

INSERT INTO emp4
VALUES(1000, 'KILDONG', 2000, 10, NULL);

INSERT INTO emp4
VALUES(2000, 'KILSEO', 3000, 20, NULL); -- null���� �ߺ��ؼ� ���� �� ����. ���� ���� ���̹Ƿ� �� ��ü�� unique��

INSERT INTO emp4
VALUES(3000, 'KILWOO', 3000, 20, 'kwoo');

INSERT INTO emp4
VALUES(4000, 'KILWI', 3000, 20, 'kwi');


UPDATE emp4 SET nickname = 'kwoo' WHERE empno = 4000; -- ���Ἲ �������ǿ� ����

--- 2.4 FOREIGN KEY ��������(���� ���Ἲ ��������)
-- ���̺��� �� �Ǵ� ���� ������ �ܷ�Ű�� �����Ͽ� �������̺� �Ǵ� �ٸ� ���̺� ���� �⺻Ű �Ǵ�

--- 2.5 CHECK��������
-- �� ���� �����ؾ��ϴ� ������ ����

----- 3. �������ǰ��� -----
-- �߰�
ALTER TABLE emps
ADD CONSTRAINT  emps_mgr_fk FOREIGN KEY(mgr)    REFERENCES  emps(empno);

-- ��ȸ
SELECT constraint_name, constraint_type, status
FROM USER_CONSTRAINTS
WHERE table_name = 'EMPS';
/* �������� ����(CONSTRAINT_TYPE)�� ������ �����ϴ�.
- C (check constraint on a table)
- P (primary key)
- U (unique key)
- R (referential integrity)
- V (with check option, on a view)
- O (with read only, on a view)*/

--����
ALTER TABLE emps DROP CONSTRAINT emps_mgr_fk;

-- ��Ȱ��ȭ
ALTER TABLE emp4 DISABLE CONSTRAINT emp4_sal_ck;

-- Ȱ��ȭ
ALTER TABLE emp4 ENABLE NOVALIDATE CONSTRAINT emp4_sal_ck; -- �˻����� �ʰ� Ȱ��ȭ
ALTER TABLE emp4 ENABLE VALIDATE CONSTRAINT emp4_sal_ck; --�̰� �������� Ȱ��ȭ�ص��Ǵ��� üũ �� Ȱ��ȭ

----- 4. �������� -----
/*1. ȸ�� ������ �����ϴ� ���̺�(member)�� �����ϼ���. ȸ�� ������ ����� ���̵�(15),
�̸�(20), ��й�ȣ(20), ��ȭ��ȣ(15), �̸���(100)�� �����ؾ� �մϴ�. ��ȣ ���� ����
�� ũ���Դϴ�. ȸ�� ������ �����ϴ� ���̺��� ����� ���̵� PK�� �����ϴ�.*/
CREATE TABLE member(
   user_id  VARCHAR2(15)    PRIMARY KEY,
   user_name    VARCHAR2(20),
   pw   VARCHAR2(15),
   email    VARCHAR2(100));


/*2. ���� ���̺� ������ �����ؼ� ���������� �߰��ϼ���.
- DEPT ���̺��� DEPTNO ���� ��Ű(primary key) ���̾�� �մϴ�. ���������� �̸�
�� pk_dept�� �ϼ���.
- EMP ���̺��� EMPNO ���� ��Ű(primary key) ���̾�� �մϴ�. ���������� �̸�
�� pk_emp�� �ϼ���.
- EMP ���̺��� DEPTNO ���� DEPT ���̺��� DEPTNO ���� �����ϴ� �ܷ�Ű
(foreign key)���� �մϴ�. ���������� �̸��� fk_deptno�� �ϼ���.*/

CREATE TABLE dept(
    deptno  NUMBER(2),
    dname   VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT  pk_dept PRIMARY KEY(deptno)
    );

CREATE TABLE emp(
 empno NUMBER(4,0),
 ename VARCHAR2(10),
 job VARCHAR2(9),
 mgr NUMBER(4,0),
 hiredate date,
 sal NUMBER(7,2),
 comm NUMBER(7,2),
 deptno NUMBER(2,0),
 CONSTRAINT pk_emp  PRIMARY KEY(empno),
 CONSTRAINT fk_deptno   FOREIGN KEY(deptno) REFERENCES dept(deptno)
);
DESCRIBE emp;

-- �������� �߰��� ��
ALTER TABLE emp4
ADD CONSTRAINT emp4_nickname_uk UNIQUE(nickname);
