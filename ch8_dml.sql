/*8. 데이터 조작(DML)*/

----- 2. CTAS -----
-- 현재 있는 테이블과 같은 구조를 갖는 테이블 생성
CREATE TABLE emp1 AS SELECT * FROM employees;

-- 데이터는 갖지 않고 구조만 갖는 테이블 생성
CREATE TABLE emp2 AS SELECT * FROM employees WHERE 1=2;
SELECT COUNT(*) FROM emp2;


----- 3. INSERT: 새로운 행 추가 -----
--3.1 테이블 구조 확인
DESC departments; -- desc(=descibe)
DESC employees;

--- 3.2 새로운 행 삽입
-- 각각의 열에 대한 값을 포함하는 새로운 행을 삽입
-- 테이블에 있는 열의 디폴트 순서로 값을 나열
-- INSERT절에서 열을 선택적으로 나열
-- 문자와 날짜값은 단일 따옴표 내에 둠
CREATE TABLE department2 AS SELECT * FROM departments;

INSERT INTO department2 
VALUES(280, 'Data Analytics', null, 1700);

INSERT INTO department2(department_id, department_name, location_id)
VALUES (280, 'Data Analytics', 1700);

SELECT * FROM department2 WHERE department_id = 280;
-- 삽입했던 INSERT문장의 실행취소
ROLLBACK;

----- 3.3 다른 테이블로부터 행 복사-----
-- 서브쿼리로 INSERT문장 작성--> VALUES절을 사용하지 않음
-- 서브쿼리 열 수와 INSERT절의 열 수는 일치
CREATE TABLE managers AS
SELECT employee_id, first_name, job_id, salary, hire_date
FROM employees
WHERE 1=2;

INSERT INTO managers
(employee_id, first_name, job_id, salary, hire_date) -- 이 부분은 생략 가능
SELECT employee_id, first_name, job_id, salary, hire_date
FROM employees
WHERE job_id LIKE '%MAN';

SELECT * FROM managers;


----- 4. UPDATE -----
-- 기존의 행을 갱신, 필요하다면 하나 이상의 행도 갱신 가능

CREATE TABLE emps AS SELECT * FROM employees;

ALTER TABLE emps
ADD (CONSTRAINT emps_emp_id_pk PRIMARY KEY (employee_id),
        CONSTRAINT emps_manager_id_fk FOREIGN KEY (manager_id)
                                REFERENCES emps (employee_id)
);

-- 4.1 테이블 행 갱신
UPDATE emps
SET salary = salary*1.1
WHERE employee_id = 103;

SELECT employee_id, first_name, salary
FROM emps
WHERE employee_id = 103;

COMMIT;

-- 4.2 서브쿼리로 다중 열 갱신
SELECT employee_id, job_id, salary, manager_id
FROM emps
WHERE employee_id IN (108, 109);

UPDATE emps
SET (job_id, salary, manager_id) = (
        SELECT job_id, salary, manager_id
        FROM emps
        WHERE employee_id = 108) -- 109번 사원의 정보를 108번 사원의 것으로 바꿔주세요
WHERE employee_id = 109;

----- 5. DELETE -----
-- 기존의 행 제거, 참조 무결성 제약조건에 주의
/*
delete: 데이터를 삭제, rollback명령으로 삭제 취소가 가능
truncate: 테이블의 구조는 유지하며 데이터만 삭제. rollback명령으로 데이터 삭제 취소 할 수 없음
drop: 데이블을 삭제. 데이터의 구조 역시 삭제. rollback명령으로 삭제 취소 불가
*/

-- 5.1 행 삭제
DELETE FROM emps
WHERE employee_id = 103;
-- 104번 사원의 매니저는 103번 사원으로 지정되어있기 때문에 103번 사원은 삭제되지 않음
-- 무결성제약조건에 위배되기 때문에 삭제되지 않음
ROLLBACK;

--5.2 다른 테이블을 이용한 행 삭제
-- 다른 테이블 값을 근거로 테이블로부터 행을 삭제하기 위해 서브쿼리 활용
CREATE TABLE depts AS SELECT * FROM departments;

DESC depts;

--emps테이블에서 shipping부서의 모든 사원 정보를 삭제위해 depts테이블 검색
DELETE FROM emps
WHERE department_id = (SELECT department_id
                                            FROM depts
                                            WHERE department_name = 'Shipping'); -- 45개 행 삭제

COMMIT;

-- 5.3 RETURNING
-- DML구문에 의해 영향을 받는 행을 검색할 수 있게 해주는 절
VARIABLE emp_name VARCHAR2(50); --emp_name변수 선언
VARIABLE emp_sal NUMBER;-- emp_sal변수 선언
VARIABLE;

DELETE emps
WHERE employee_id = 109
RETURNING first_name, salary INTO:emp_name, :emp_sal;

PRINT emp_name;
PRINT emp_sal;

-- 6. MERGE
-- db insert, update할 때 데이터 존재하는지 체크하고 존재하면 update, 존재하지 않으면 insert수행할 수 있게 함
-- 두 개의 테이블을 하나의 테이블로 병합 하는데 사용
CREATE TABLE emps_it AS SELECT * FROM employees WHERE 1=2;

INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES
    (105, 'David', 'Kim', 'DAVIDKIM', '06/03/04', 'IT_PROG');

-- EMPS_IT와EMPLOYEES 병합. 직무가 IT_PROG인 사원정보 EMPLOYEES테이블에서 조회 후 병합
-- 같은 사원 정보 있을 경우 EMPLOYEES테이블의 정보로 업데이트. EMPS_IT테이블에 없는 행은 INSERT
MERGE INTO emps_it a -- 테이블 별칭 a
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
-- 결과 확인
SELECT * FROM emps_it;


-- 7. multiple insert
-- 하나의 insert 문에서 여러 개의 테이블에 동시에 하나의 행을 입력
-- 7.1 unconditional insert all

-- 7.2 comditional insert all
-- 특정 조건들을 기술하여 그 조건에 맞는 행들을 원하는 테이블에 나누어 삽입
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
--첫번재 when절에서 조건을 만족할 경우 다음의 when절을 수행하지 않음
-- 테이블 만들기
CREATE TABLE emp_sal5000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal10000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal15000 AS SELECT employee_id, first_name, salary FROM employees WHERE 1=2;

-- 조건문으로 값 삽입 
INSERT FIRST
    WHEN salary <= 5000 THEN
        INTO emp_sal5000 VALUES(employee_id, first_name, salary)
    WHEN salary <= 10000 THEN
        INTO emp_sal10000 VALUES(employee_id, first_name, salary)
    WHEN salary <= 15000 THEN
        INTO emp_sal15000 VALUES(employee_id, first_name, salary)
    SELECT employee_id, first_name, salary FROM employees;

-- 각 테이블 당 몇개의 원소를 가지는지 확인
SELECT COUNT(*) FROM emp_sal5000;
SELECT COUNT(*) FROM emp_sal10000;
SELECT COUNT(*) FROM emp_sal15000;

-- 7.4 PIVOTING INSERT
-- 비관계형데이터베이스를 관계형데이터베이스 구조로 만들 때



------- 8. 연습문제 ------
/*1. EMPLOYEES 테이블에 있는 데이터를 열 단위로 나눠 저장하고 싶습니다. 사원번호,
사원이름, 급여, 보너스율을 저장하기 위한 구조와 데이터를 갖는 테이블을
EMP_SALARY_INFO이라는 이름으로 생성하세요. 그리고 사원번호, 사원이름, 입사일,
부서번호를 저장하기 위한 구조와 데이터를 갖는 테이블을 EMP_HIREDATE_INFO라
는 이름으로 생성하세요.*/
CREATE TABLE emp_salary_info AS SELECT employee_id, first_name, salary, commission_pct FROM employees;
CREATE TABLE emp_hiredate_info AS SELECT employee_id, first_name, hire_date, job_id FROM employees;


/*2. EMPLOYEES 테이블에 다음 데이터를 추가하세요.
사원번호 : 1030
성 : KilDong
이름 : Hong
이메일 : HONGKD
전화번호 : 010-1234-5678
입사일 : 2018/03/20
직무아이디 : IT_PROG
급여 : 6000
보너스율 : 0.2
매니저번호 : 103
부서번호 : 60*/
INSERT INTO emps VALUES(1030, 'Kildong', 'Hong', 'HONGKD', '010-1234-5678', '18/03/20', 'IT_PROG',6000, 0.2, 103, 60);

/*3. 1030번 사원의 급여를 10% 인상시키세요.*/
UPDATE emps
SET salary = salary*1.1
WHERE employee_id = 1030;

SELECT * FROM emps WHERE employee_id = 1030;
/*4. 1030번 사원의 정보를 삭제하세요*/
DELETE FROM emps
WHERE employee_id = 1030;

/*5. 사원테이블을 이용하여, 2001년부터 2003년까지의 연도에 근무한 사원들의 사원아이디,
이름, 입사일, 연도를 출력하세요.
조건1) 각 연도에 해당하는 테이블을 생성하세요. 속성은 사원아이디, 이름, 입사일, 연도
입니다. 적절한 데이터 크기를 지정하세요. 테이블이름은 ‘emp_yr_연도’ 형식으로
생성하세요.
조건2) 연도 열은 입사일에서 연도만 출력하세요. 열 이름은 ‘yr’이고, 4자리 문자로 표현
하세요.
조건3) INSERT ALL 구문으로 작성하세요.*/
-- 테이블 생성
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

-- 행 삽입
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

/*6. 문제 5의의 조건3을 비교연산자를 사용하여, INSERT FIRST 구문으로 작성하세요*/
INSERT FIRST
    WHEN hire_date <= '01/12/31' THEN
        INTO emp_yr_2001 VALUES(employee_id, first_name, hire_date, yr)
    WHEN hire_date <= '02/12/31' THEN
        INTO emp_yr_2002 VALUES(employee_id, first_name, hire_date, yr)
    WHEN hire_date <= '03/12/31' THEN
        INTO emp_yr_2003 VALUES(employee_id, first_name, hire_date, yr)
    SELECT employee_id, first_name, hire_dtae, TO_CHAR(hire_date, 'RRRR') AS yr FROM employees;

/*7. Employees 테이블의 사원들 정보를 아래의 두 테이블에 나눠 저장하세요.
조건1) emp_personal_info 테이블에는 employee_id, first_name, last_name, email,
phone_number가 저장되도록 하세요.
조건2) emp_office_info 테이블에는 employee_id, hire_date, salary, commission_pct,
manager_id, department_id가 저장되도록 하세요.*/
CREATE TABLE emp_personal_info AS SELECT employee_id, first_name, last_name, email, phone_number FROM employees;
CREATE TABLE emp_office_info AS SELECT employee_id, hire_date, salary, commission_pct, manager_id, department_id FROM employees;
INSERT ALL
    INTO emp_personal_info VALUES
        (employee_id, first_name, last_name, email, phone_number)
    INTO emp_office_info VALUES
        (employee_id, hire_date, salary, commission_pct, manager_id, department_id)
    SELECT * FROM employees;

SELECT * FROM emp_personal_info;

/*8. Employees 테이블의 사원들 정보를 아래의 두 테이블에 나눠 저장하세요.
조건1) 보너스가 있는 사원들의 정보는 emp_comm 테이블에 저장하세요.
조건2) 보너스가 없는 사원들의 정보는 emp_nocomm 테이블에 저장하세요*/
CREATE TABLE emp_comm AS SELECT employee_id, first_name, salary, commission_pct FROM employees WHERE 1=2;
CREATE TABLE emp_nocomm AS SELECT employee_id, first_name, salary, commission_pct FROM employees WHERE 1=2;


INSERT FIRST
    WHEN commission_pct IS NOT NULL THEN
        INTO emp_comm VALUES(employee_id, first_name, salary, commission_pct)
    WHEN commission_pct IS NULL THEN
        INTO emp_nocomm VALUES(employee_id, first_name, salary, commission_pct)
    SELECT employee_id, first_name, salary, commission_pct FROM employees;

SELECT * FROM emp_nocomm;  
