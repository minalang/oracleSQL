/* 13. ������, �ε���, ���Ǿ� */

CREATE SEQUENCE depts_seq
    INCREMENT BY 1
    START WITH 91
    MAXVALUE 100
    NOCACHE
    NOCYCLE;
    
CREATE TABLE depts (
    deptno NUMBER(2),
    dname   VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT depts_dname_uk   UNIQUE(dname),
    CONSTRAINT depts_deptno_pk  PRIMARY KEY(deptno));

DESC depts;

SELECT * FROM depts;
-- ���ο� �μ����� ����
INSERT INTO depts(deptno, dname, loc)
VALUES(depts_seq.NEXTVAL, 'MARKETNG', 'SAN DIEGO');

-- depts_seq �������� ���� ��
SELECT depts_seq.CURRVAL
FROM dual;

SELECT sequence_name, min_value, max_value, increment_by, last_number
FROM USER_SEQUENCES;

-- ������ ����
ALTER SEQUENCE [sequence name];
-- ����
DROP SEQUENCE [sequence_name];


----- 2. �ε��� -----
CREATE TABLE emps AS SELECT * FROM employees;

CREATE INDEX emps_first_name_idx ON emps(first_name);
SELECT * FROM emps;

-- ��Ʈ�� �ε���
CREATE BITMAP INDEX emps_comm_idx ON emps(commission_pct);

--unique �ε���: ���� �ߺ� ������ �������� �ʰ� ����� �� �ִ� ����

CREATE UNIQUE INDEX emps_email_idx ON emps(email);

-- �Լ���� �ε���: �Լ� �Ǵ� ������ �̿��� ������ ���� �� �˻��ӵ��� ������ �� / �ߺ������� ���� �� ����
CREATE INDEX emps_annsal_idx
ON emps (COALESCE(salary+salary*commission_pct, salary));

-- ���� �ε���: 2�� �̻��� ���� �̷���� �ε��� / ��ȸ �� �˻� �ӵ��� ������ ��
CREATE UNIQUE INDEX emps_name_idx
ON emps(first_name, last_name);

----- 3. ���Ǿ� -----
-- ��ü�� ���� ��ü �̸� ����
CREATE SYNONYM emp60
FOR emp_dept60;

DROP SYNONYM emp60;

----- 4. �������� -----
/* 1. �Խ����� �Խñ� ��ȣ�� ���� �������� �����ϼ���.
����1) ������ �̸��� BBS_SEQ���� �մϴ�.
����2) �Խñ� ��ȣ�� 1�� �����մϴ�.
����3) �������� 1���� �����ϸ� �ִ밪�� �������� �ʽ��ϴ�.
����4) ĳ�� ������ 20���̸�, ����Ŭ�� ���ġ �ʽ��ϴ�.*/

CREATE SEQUENCE bbs_seq
    INCREMENT BY 1
    START WITH 1
    CACHE 20
    NOCYCLE;


/*2. ����� �޿� ���޾����� �˻��� �ϰ� �ͽ��ϴ�. �޿� ���޾����� �ε����� �����ϼ���.
����1) �ε��� �̸��� idx_emp_realsal�Դϴ�.
����2) �޿� ���޾� ������ SALARY + SALARY * COMMISSION_PCT�Դϴ�.*/

CREATE INDEX idx_emp_realsal
ON emps (COALESCE(salary+salary*commission_pct, salary));
