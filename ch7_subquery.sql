/* 7. �������� */
-- ���������� SELECT ���� ���--> ��Į��(Scalar) ��������
-- ���������� FROM ���� ���--> �ζ��κ�(Inline view)
-- ���������� WHERE ���� ���--> ��ø(Need)��������

-- 1. ��������
-- �Ϲ������� ���������� ���� �����ϰ� �װ��� ����� �������� Ȥ�� �ܺ����ǿ� ���� ���� ������ �ϼ��ϴµ� ���

--2. ������ ��������: ���������� �ϳ��� ���� ��ȯ

-- 103�� ����� job_id�� ���� ��� ���
SELECT first_name, job_id, hire_date
FROM employees
WHERE job_id = (SELECT job_id
                            FROM employees
                            WHERE employee_id = 103);
-- 3. ������ ��������: ���������� ����� 2�� �� �̻�
-- ������: IN, EXISTS, ANY, SOME, ALL
-- first_name�� David�� ��� �� ��� �� ����� �޿����� ���� �޿��� �޴� ����� �̸��� �޿�
SELECT first_name, salary
FROM employees
WHERE salary > ANY (SELECT salary -- �ּڰ����� ũ��
                                    FROM employees
                                    WHERE first_name = 'David');
                                    
SELECT first_name, salary
FROM employees
WHERE salary > ALL (SELECT salary -- �ִ񰪺��� ũ��
                                    FROM employees
                                    WHERE first_name = 'David');
                                    
-- DAVID�� ���� �μ��� �ٹ��ϴ� ����� �̸�, �μ���ȣ, ����
SELECT first_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                                            FROM employees
                                            WHERE first_name = 'David');
-- EXISTS
-- �Ŵ����� ���ϴ� ����� �̸��� �μ� ���̵� ���ϱ�
SELECT first_name, department_id, job_id
FROM employees e
WHERE EXISTS(SELECT *
                        FROM departments d
                        WHERE d.manager_id = e.employee_id);

-- �������� ���� ������� ���� �� �ִ�                        
SELECT e.first_name, e.department_id, e.job_id
FROM employees e
JOIN departments d ON d.manager_id = e.employee_id;
                        
-- 4. ��ȣ���� ��������
-- ��ø �������� �߿��� �����ϴ� ���̺��� �θ�/�ڽ� ���踦 ������ ��ȣ���� ����������� ��
-- ���������� ���� ������ ���� �̿��ϰ�, �׷��� ������ ���������� ���� �ٽ� ���������� �̿�
-- �ڽ��� ���� �μ��� ��պ��� ���� �޿��� �޴� ����� �̸��� �޿��� ���

SELECT first_name, salary
FROM employees a
WHERE salary > (SELECT AVG(salary)
                            FROM employees b
                            WHERE b.department_id = a.department_id);

-- 5. ��Į�� ��������
-- select ���� ����ϴ� ��������
-- ������ ���� ���� �ٿ� ������ ����Ŵ
-- ��� ����� �̸��� �μ��� �̸�
SELECT first_name, (SELECT department_name
                                FROM departments d
                                WHERE e.department_id = d.department_id) AS dept_name
FROM employees e
ORDER BY first_name;

-- ������ Ȱ��
SELECT e.first_name, d.department_name AS dept_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY first_name;

-- 6. �ζ��� ��
-- from���� ���������� ����ϴ� ��: ������ ���̺� Ȥ�� ��ó�� ����� �� ����
-- �޿��� ���� ���� �޴� ������� ���� 10���� ����̸��� �޿� ���
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
            row_number()    OVER(ORDER BY salary DESC) AS row_number
            FROM employees)
WHERE row_number BETWEEN 1 AND 10;

-- 7. 3������
-- �޿��� ���� 1�� ~ 10���� �̸��� �޿��� ���. �� �м��Լ��� ������� �ʰ� ROWNUM�ǻ翭�� �̿�
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
WHERE rownum BETWEEN 1 AND 10;

-- �޿��� ���� ����11�� ~ 20���� �̸��� �޿��� ���. �� �м��Լ��� ������� �ʰ� ROWNUM�ǻ翭�� �̿�
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC) 
WHERE rownum BETWEEN 11 AND 20; -- ��°��� ����: �ݵ�� ù��° ����� ��ȸ�ϱ� ������

-- �������� Ȱ��
SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum AS rnum -- ���⼭ �ǻ翭 �����
            FROM (SELECT first_name, salary
                        FROM employees
                        ORDER BY salary DESC) -- ���⼭ ����
                        )
WHERE rnum BETWEEN 11 AND 20; -- ���⼭ �κ� ����

-- �������� Ȱ�� ���ϰ� �ش� ��� ���
SELECT row_number, first_name, salary
FROM    (SELECT first_name, salary,
                row_number() OVER (ORDER BY salary DESC) AS row_number
                FROM employees)
WHERE row_number BETWEEN 11 AND 20;


-- 8. ������ ����
-- ������ ���踦 �ΰ� �ִ� ����� ������ ������ ��ȸ
-- ��� ����� �Ŵ���-��� ���赵�� ���
SELECT employee_id, 
            LPAD(' ', 3*(LEVEL - 1)) || first_name || ' ' || last_name AS full_name,
            LEVEL
FROM employees
START WITH manager_id IS NULL 
CONNECT BY PRIOR employee_id = manager_id;

-- ���� �Ŵ����� ���� ������� �̸������� ����
SELECT employee_id, 
            LPAD(' ', 3*(LEVEL - 1)) || first_name || ' ' || last_name AS full_name,
            LEVEL
FROM employees
START WITH manager_id IS NULL 
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY first_name;


-- 9. ��������
-- 1. 20�� �μ��� �ٹ��ϴ� ������� �Ŵ����� �Ŵ����� ���� ������� ������ ����ϼ���
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary
FROM employees
WHERE manager_id IN (SELECT DISTINCT manager_id
                                        FROM employees
                                        WHERE department_id = 20);

-- 2. ���� ���� �޿��� ���� ����� �̸��� ����ϼ���
SELECT first_name
FROM employees
WHERE salary = (SELECT MAX(salary)
                            FROM employees);


--3.  �޿� ������(��������) 3������ 5������ ����ϼ���(rownum)�̿�
SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum AS rnum
            FROM (SELECT first_name, salary 
                        FROM employees
                        ORDER BY salary DESC)
                        )
WHERE rnum BETWEEN 3 AND 5;

--4 . �μ��� �μ��� ����̻� �޿��� �޴� ����� �μ���ȣ, �̸�, �޿�, ��ձ޿��� ����ϼ���
-- ���� �� �����ϰ� �ؾ���
SELECT department_id, first_name, salary, 
                (SELECT ROUND(AVG(salary))
                FROM employees c
                WHERE c.department_id = a.department_id) AS avg_sal
FROM employees a
WHERE salary >= (SELECT AVG(salary)
                            FROM employees b
                            WHERE b.department_id = a.department_id)
ORDER BY department_id;


