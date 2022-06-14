/* 12. �� */

SELECT * FROM USER_VIEWS;

----- 2. �� ����, �����Ͱ˻�, ����, ���� -----
CREATE VIEW emp_view_60
    AS SELECT employee_id, first_name, last_name, job_id, salary
        FROM employees
        WHERE department_id = 60;
DROP VIEW emp_view_dept60;

CREATE VIEW emp_dept60_salary -- Ȥ�� (empno, name, monthly_salary)
    AS SELECT employee_id AS deptno,
    first_name || ' ' || last_name AS name,
    salary AS monthly_salary
    FROM employees
    WHERE department_id = 60;

---- 2.5 ���� �� ����
CREATE VIEW emp_view 
AS SELECT
    e.employee_id AS id,
    e.first_name AS name,
    j.job_title AS job
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
    JOIN jobs j ON e.job_id = j.job_id;

DROP VIEW emp_view;

----- 5. �������� -----
/* . ������ �޿� ��հ� ����� �޿� ���̸� ���ϴ� �並 �����ϼ���.
����1) �� �̸��� SAL_GAP_VIEW_BY_JOB�� �ϼ���.
����2) ���� ���� ����̸��� �������̵�, ������ �޿� ��հ� ����޿��� �����Դϴ�.
����3) ������ �޿� ����� �������̺��� �ִ� �޿��� �ּ� �޿��� ����� �ǹ��մϴ�.*/

CREATE VIEW sal_gap_view_by_job
AS SELECT
    e.first_name AS name,
    e.job_id AS job_id,
    ROUND(j.avg_sal - e.salary, 0) AS job_sal_gap
    FROM employees e JOIN (SELECT job_id, (max_salary+min_salary)/2 as avg_sal FROM jobs) j 
    ON e.job_id = j.job_id;

SELECT * FROM sal_gap_view_by_job;
DROP VIEW sal_gap_view_by_job;

/* 2. ��� ����� ���̵�� �̸� �׸��� �μ� �̸��� ���� �̸��� ����� �� �ִ� �並 ����
�ϼ���.*/
CREATE VIEW ans_view
AS SELECT
    e.employee_id AS id,
    e.first_name AS name,
    d.department_name AS department,
    j.job_title AS job
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
    JOIN jobs j ON e.job_id = j.job_id;
    
DROP VIEW ans_view;