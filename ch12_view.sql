/* 12. 뷰 */

SELECT * FROM USER_VIEWS;

----- 2. 뷰 생성, 데이터검색, 수정, 삭제 -----
CREATE VIEW emp_view_60
    AS SELECT employee_id, first_name, last_name, job_id, salary
        FROM employees
        WHERE department_id = 60;
DROP VIEW emp_view_dept60;

CREATE VIEW emp_dept60_salary -- 혹은 (empno, name, monthly_salary)
    AS SELECT employee_id AS deptno,
    first_name || ' ' || last_name AS name,
    salary AS monthly_salary
    FROM employees
    WHERE department_id = 60;

---- 2.5 복합 뷰 생성
CREATE VIEW emp_view 
AS SELECT
    e.employee_id AS id,
    e.first_name AS name,
    j.job_title AS job
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id
    JOIN jobs j ON e.job_id = j.job_id;

DROP VIEW emp_view;

----- 5. 연습문제 -----
/* . 직무별 급여 평균과 사원의 급여 차이를 구하는 뷰를 생성하세요.
조건1) 뷰 이름은 SAL_GAP_VIEW_BY_JOB로 하세요.
조건2) 뷰의 열은 사원이름과 직무아이디, 직무별 급여 평균과 사원급여의 차이입니다.
조건3) 직무별 급여 평균은 직무테이블의 최대 급여와 최소 급여의 평균을 의미합니다.*/

CREATE VIEW sal_gap_view_by_job
AS SELECT
    e.first_name AS name,
    e.job_id AS job_id,
    ROUND(j.avg_sal - e.salary, 0) AS job_sal_gap
    FROM employees e JOIN (SELECT job_id, (max_salary+min_salary)/2 as avg_sal FROM jobs) j 
    ON e.job_id = j.job_id;

SELECT * FROM sal_gap_view_by_job;
DROP VIEW sal_gap_view_by_job;

/* 2. 모든 사원의 아이디와 이름 그리고 부서 이름과 직무 이름을 출력할 수 있는 뷰를 생성
하세요.*/
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