/* 10. 테이블 생성과 관리 */

----- 1. 테이블 생성 -----
--- 1.1 이름 만드는 규칙
CREATE TABLE "Test" (c1 VARCHAR2(1)); --겹따옴표로 묶으면 대/소문자 구분
INSERT INTO "Test" VALUES('X');
SELECT * FROM "Test";

--- 1.2 데이터타입
--- 1.3 CREATE TABLE
-- 데이터 정의어 문장
CREATE TABLE dept2(
    deptno  NUMBER(2), -- 두자리수 숫자 데이터타입
    dname   VARCHAR2(14), --최대 4000byte크기를 갖는 가변길이 문자 데이터. 입력한 만큼만 저장공간 할당함 
    loc VARCHAR2(13));

-- 테이블의 구조 확인
DESCRIBE dept2;

--- 1.4 서브쿼리를 사용한 데이터 생성: CTAS구문을 이용한 테이블 복제
CREATE TABLE emp_dept50 AS 
SELECT employee_id, first_name, salary*12 as ann_sal, hire_date, job_id
FROM employees
WHERE department_id = 50;

----- 2. 테이블 구조 변경(ALTER TABLE) -----
--- 2.2 열 추가
/* ALTER TABLE문장에 ADD절을 사용하여 열을 추가
새로운 열이 마지막 열이 됨*/

-- 새로운 열 추가
ALTER TABLE emp_dept50
ADD(job VARCHAR2(10));

SELECT * FROM emp_dept50;

--- 2.3 열 수정
/* ALTER TABLE문장에 MODIFY절을 사용하여 열을 수정
기존의 데이터가 손상되게 크기를 조정할 수는 없다*/

-- first_name열 크기 변경
ALTER TABLE emp_dept50
MODIFY(first_name VARCHAR2(30));

-- 단, 열의 크기를 줄일 수 있되 데이터를 훼손하도록 줄일 수는 없다. FIRST_NAME열에서 가장 긴 이름은 8byte. 따라서 위 값은 에러
ALTER TABLE emp_dept50
MODIFY(first_name VARCHAR2(7));  -- 에러메세지: 일부 값이 너무 커서 열 길이를 줄일 수 없음

--- 2.4 열 삭제
/* ALTER TABLE문을 DROP COLUMN절과 함께 사용하여 데이블에서 열 삭제
한 번에 하나의 열만 삭제할 수 있음
테이블 변경 후 테이블에 열이 하나 이상 있어야함
삭제된 열은 복구할 수 없음*/

-- JOB열 삭제
ALTER TABLE emp_dept50
DROP COLUMN job;

--- 2.5 열 이름 변경
/* RENAME COLUMN 절을 사용하여 테이블의 열 이름 변경 */
ALTER TABLE emp_dept50
RENAME COLUMN job TO job_id;

-- 데이터 확인
DESC emp_dept50;

--- 2.6 SET UNUSED옵션과 DROP UNUSED 옵션
--- 1) SET UNUSED
/* 실제로 테이블의 각 행에서 해당 열이 제거되지는 않으나, 
사용되지 않는 열로 표시된 열은 데이터가 남아도 삭제된 것으로 처리되며 액세스 할 수 없다
SELECT문 DESCRIBE문 실행 중에 표시되지 않는다*/ 

-- 사용하지 않는 열로 설정
ALTER TABLE emp_dept50 SET UNUSED(first_name);
-- 확인
DESC emp_dept50;

--- 2) DROP UNUSED COLUMNS
/*테이블에서 현재 사용되지 않았다고 표시된 모든 열을 제거*/

ALTER TABLE emp_dept50 DROP UNUSED COLUMNS;

-- SET USED는 존재하지 않음. ALTER TABLE구문은 되돌릴 수 없음

---2.7 객체 이름 변경
RENAME emp_dept50 TO employees_dept50;
--열 이름 변경: ALTER TABLE문에서 RENAME COLUMN절 사용
-- ALTER TABLE table_name RENAME COLUMN old_name TO new_name

----- 3. 테이블 삭제(DROP) -----
/* 모든 데이터와 구조 삭제, 인덱스 삭제 롤백 X */
DROP TABLE employees_dept50;

DESC employees_dept50; -- ORA-04043: employees_dept50 객체가 존재하지 않습니다.

----- 4. 테이블 데이터 비우기(TRUNCATE) -----
/* 테이블의 모든 행 삭제, 롤백 X, 대안적으로는 DELETE문장 사용해 행 삭제 가능 */
TRUNCATE TABLE emp2;

SELECT * FROM emp2;

----- 5. 연습문제 -----
-- 1번

CREATE TABLE member(
    user_id VARCHAR2(15)    NOT NULL,
    user_name    VARCHAR2(20)   NOT NULL,
    phone   VARCHAR2(15),
    pw  VARCHAR2(15)    NOT NULL,
    email VARCHAR(100)
    );
    
-- 2번
/*2. 사용자아이디, 이름, 비밀번호, 전화번호, 이메일을 저장하는 쿼리를 작성하세요.
- user123, 사용자, a1234567890, 011-234-5678, user@user.com*/
DELETE FROM member
WHERE user_id = 'user123';

INSERT INTO member (user_id, user_name, pw, phone, email)
VALUES('user123', '사용자', 'a1234567890', '011-234-5678', 'user@user.com');

-- 3번
/* 3. 사용자아이디가 user123인 사용자의 모든 정보를 조회하세요. */
SELECT * 
FROM member
WHERE user_id = 'user123';

-- 4번 
/*사용자아이디가 user123인 사용자의 이름, 비밀번호, 전화번호, 이메일을 수정하세요.
- 홍길동, a1234, 011-222-3333, user@user.co.kr*/
UPDATE member
SET user_name = '홍길동', pw = 'a1234', phone = '011-222-3333', email = 'user@user.co.kr'
WHERE user_id = 'user123';

-- 5번
/* 사용자아이디가 user123이고 비밀번호가 a1234인 회원의 정보를 삭제하세요.*/
DELETE FROM member
WHERE user_id = 'user123' and pw = 'a1234';

-- 6번
/* 회원 정보를 저장하는 테이블(member)의 모든 행을 삭제하세요. TRUNCATE 구문을
이용하세요*/
TRUNCATE TABLE member;

-- 7번
DROP TABLE member;