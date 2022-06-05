/*9. 트랜잭션*/

-- TCL(TRANSACTION CONTROL LANGUAGE)

----- 1. 트랜잭션-----
--논리적인 작업의 단위
SET AUTOCOMMIT OFF; 
SHOW AUTOCOMMIT;

--1.3 SAVEPOINT 와 ROLLBACK
DELETE FROM emps WHERE department_id = 10;
SAVEPOINT delete_10;

DELETE FROM emps WHERE department_id = 20;
SAVEPOINT delete_20;

DELETE FROM emps WHERE department_id = 30;
-- 30번 부서 사원 삭제한 것 롤백(20번 제거 시점에 만든 savepoint는 그 다음꺼부터 복원가능)
ROLLBACK TO SAVEPOINT delete_20;

----- 2. LOCK -----


----- 3. 연습문제 -----
--1. 실습을 위해 EMPLOYEES 테이블의 사본 테이블을 생성하세요. 사본 테이블의 이름은EMP_TEMP입니다.
CREATE TABLE emp_temp AS SELECT * FROM employees;

--2. EMP_TEMP 테이블에서 20번 부서 사원의 정보를 삭제하고 롤백 지점을 생성하세요. 롤백 지점의 이름은 SVPNT_DEL_20여야 합니다.
DELETE FROM emp_temp WHERE department_id = 20;
SAVEPOINT svpnt_del_20;

--3. 50번부서의 사원의 정보를 삭제하고 롤백 지점을 생성하세요. 롤백 지점의 이름은 SVPNT_DEL_50여야 합니다.
DELETE FROM emp_temp WHERE department_id = 50;
SAVEPOINT svpnt_del_50;

-- 4. 60번 부서의 사원 정보를 삭제하세요.
DELETE FROM emp_temp WHERE department_id = 60;


-- 5. 앞의 60번 부서의 사원 정보를 삭제했던 작업을 취소하세요. 그 이전 작업은 취소하면안됩니다.
ROLLBACK TO SAVEPOINT svpnt_del_50;
