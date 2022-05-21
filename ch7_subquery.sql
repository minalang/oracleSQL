/* 7. 서브쿼리 */
-- 서브쿼리가 SELECT 절에 사용--> 스칼라(Scalar) 서브쿼리
-- 서브쿼리가 FROM 절에 사용--> 인라인뷰(Inline view)
-- 서브쿼리가 WHERE 절에 사용--> 중첩(Need)서브쿼리

-- 1. 서브쿼리
-- 일반적으로 서브쿼리를 먼저 실행하고 그것의 결과를 메인쿼리 혹은 외부질의에 대한 질의 조건을 완성하는데 사용

--2. 단일행 서브쿼리: 서브쿼리가 하나의 행을 반환

-- 103번 사원과 job_id가 같은 사람 출력
SELECT first_name, job_id, hire_date
FROM employees
WHERE job_id = (SELECT job_id
                            FROM employees
                            WHERE employee_id = 103);
-- 3. 다중행 서브쿼리: 서브쿼리의 결과가 2개 행 이상
-- 연산자: IN, EXISTS, ANY, SOME, ALL
-- first_name이 David인 사람 중 어느 한 사람의 급여보다 많은 급여를 받는 사람의 이름과 급여
SELECT first_name, salary
FROM employees
WHERE salary > ANY (SELECT salary -- 최솟값보다 크다
                                    FROM employees
                                    WHERE first_name = 'David');
                                    
SELECT first_name, salary
FROM employees
WHERE salary > ALL (SELECT salary -- 최댓값보다 크다
                                    FROM employees
                                    WHERE first_name = 'David');
                                    
-- DAVID와 같은 부서에 근무하는 사원의 이름, 부서번호, 직무
SELECT first_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                                            FROM employees
                                            WHERE first_name = 'David');
-- EXISTS
-- 매니저에 속하는 사원의 이름과 부서 아이디 구하기
SELECT first_name, department_id, job_id
FROM employees e
WHERE EXISTS(SELECT *
                        FROM departments d
                        WHERE d.manager_id = e.employee_id);

-- 조인으로 같은 결과값을 만들어낼 수 있다                        
SELECT e.first_name, e.department_id, e.job_id
FROM employees e
JOIN departments d ON d.manager_id = e.employee_id;
                        
-- 4. 상호연관 서브쿼리
-- 중첩 서브쿼리 중에서 참조하는 테이블이 부모/자식 관계를 가지면 상호연관 서브쿼리라고 함
-- 서브쿼리가 메인 쿼리의 값을 이용하고, 그렇게 구해진 서브쿼리의 값을 다시 메인쿼리가 이용
-- 자신이 속한 부서의 평균보다 많은 급여를 받는 사원의 이름과 급여를 출력

SELECT first_name, salary
FROM employees a
WHERE salary > (SELECT AVG(salary)
                            FROM employees b
                            WHERE b.department_id = a.department_id);

-- 5. 스칼라 서브쿼리
-- select 절에 사용하는 서브쿼리
-- 조인할 행의 수를 줄여 성능을 향상시킴
-- 모든 사원의 이름과 부서의 이름
SELECT first_name, (SELECT department_name
                                FROM departments d
                                WHERE e.department_id = d.department_id) AS dept_name
FROM employees e
ORDER BY first_name;

-- 조인을 활용
SELECT e.first_name, d.department_name AS dept_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY first_name;

-- 6. 인라인 뷰
-- from절에 서브쿼리를 사용하는 것: 가상의 테이블 혹은 뷰처럼 사용할 수 있음
-- 급여를 가장 많이 받는 사람부터 상위 10명의 사원이름과 급여 출력
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
            row_number()    OVER(ORDER BY salary DESC) AS row_number
            FROM employees)
WHERE row_number BETWEEN 1 AND 10;

-- 7. 3중쿼리
-- 급여액 상위 1위 ~ 10위의 이름과 급여를 출력. 단 분석함수를 사용하지 않고 ROWNUM의사열을 이용
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
WHERE rownum BETWEEN 1 AND 10;

-- 급여액 상위 기준11위 ~ 20위의 이름과 급여를 출력. 단 분석함수를 사용하지 않고 ROWNUM의사열을 이용
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC) 
WHERE rownum BETWEEN 11 AND 20; -- 출력값이 없음: 반드시 첫번째 행부터 조회하기 때문에

-- 삼중쿼리 활용
SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum AS rnum -- 여기서 의사열 만들고
            FROM (SELECT first_name, salary
                        FROM employees
                        ORDER BY salary DESC) -- 여기서 정렬
                        )
WHERE rnum BETWEEN 11 AND 20; -- 여기서 부분 추출

-- 삼중쿼리 활용 안하고 해당 결과 얻기
SELECT row_number, first_name, salary
FROM    (SELECT first_name, salary,
                row_number() OVER (ORDER BY salary DESC) AS row_number
                FROM employees)
WHERE row_number BETWEEN 11 AND 20;


-- 8. 계층형 쿼리
-- 수직적 관계를 맺고 있는 행들의 계층형 정보를 조회
-- 모든 사원의 매니저-사원 관계도를 출력
SELECT employee_id, 
            LPAD(' ', 3*(LEVEL - 1)) || first_name || ' ' || last_name AS full_name,
            LEVEL
FROM employees
START WITH manager_id IS NULL 
CONNECT BY PRIOR employee_id = manager_id;

-- 같은 매니저를 갖는 사원들을 이름순으로 정렬
SELECT employee_id, 
            LPAD(' ', 3*(LEVEL - 1)) || first_name || ' ' || last_name AS full_name,
            LEVEL
FROM employees
START WITH manager_id IS NULL 
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY first_name;


-- 9. 연습문제
-- 1. 20번 부서에 근무하는 사원들의 매니저와 매니저가 같은 사원들의 정보를 출력하세요
SELECT employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary
FROM employees
WHERE manager_id IN (SELECT DISTINCT manager_id
                                        FROM employees
                                        WHERE department_id = 20);

-- 2. 가장 많은 급여를 받은 사람의 이름을 출력하세요
SELECT first_name
FROM employees
WHERE salary = (SELECT MAX(salary)
                            FROM employees);


--3.  급여 순으로(내림차순) 3위부터 5위까지 출력하세요(rownum)이용
SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum AS rnum
            FROM (SELECT first_name, salary 
                        FROM employees
                        ORDER BY salary DESC)
                        )
WHERE rnum BETWEEN 3 AND 5;

--4 . 부서별 부서의 평균이상 급여를 받는 사원의 부서번호, 이름, 급여, 평균급여를 출력하세요
-- 한참 더 복잡하게 해야함
SELECT department_id, first_name, salary, 
                (SELECT ROUND(AVG(salary))
                FROM employees c
                WHERE c.department_id = a.department_id) AS avg_sal
FROM employees a
WHERE salary >= (SELECT AVG(salary)
                            FROM employees b
                            WHERE b.department_id = a.department_id)
ORDER BY department_id;


