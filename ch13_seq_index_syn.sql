/* 13. 시퀀스, 인덱스, 동의어 */

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
-- 새로운 부서정보 삽입
INSERT INTO depts(deptno, dname, loc)
VALUES(depts_seq.NEXTVAL, 'MARKETNG', 'SAN DIEGO');

-- depts_seq 시퀀스의 현재 값
SELECT depts_seq.CURRVAL
FROM dual;

SELECT sequence_name, min_value, max_value, increment_by, last_number
FROM USER_SEQUENCES;

-- 시퀀스 수정
ALTER SEQUENCE [sequence name];
-- 삭제
DROP SEQUENCE [sequence_name];


----- 2. 인덱스 -----
CREATE TABLE emps AS SELECT * FROM employees;

CREATE INDEX emps_first_name_idx ON emps(first_name);
SELECT * FROM emps;

-- 비트맵 인덱스
CREATE BITMAP INDEX emps_comm_idx ON emps(commission_pct);

--unique 인덱스: 열의 중복 값들을 포함하지 않고 사용할 수 있는 장점

CREATE UNIQUE INDEX emps_email_idx ON emps(email);

-- 함수기반 인덱스: 함수 또는 수식을 이용한 데이터 조희 시 검색속도를 빠르게 함 / 중복데이터 가질 수 있음
CREATE INDEX emps_annsal_idx
ON emps (COALESCE(salary+salary*commission_pct, salary));

-- 복합 인덱스: 2개 이상의 열로 이루어진 인덱스 / 조회 시 검색 속도를 빠르게 함
CREATE UNIQUE INDEX emps_name_idx
ON emps(first_name, last_name);

----- 3. 동의어 -----
-- 객체를 위한 대체 이름 제공
CREATE SYNONYM emp60
FOR emp_dept60;

DROP SYNONYM emp60;

----- 4. 연습문제 -----
/* 1. 게시판의 게시글 번호를 위한 시퀀스를 생성하세요.
조건1) 시퀀스 이름은 BBS_SEQ여야 합니다.
조건2) 게시글 번호는 1씩 증가합니다.
조건3) 시퀀스는 1부터 시작하며 최대값을 설정하지 않습니다.
조건4) 캐쉬 개수는 20개이며, 사이클은 허용치 않습니다.*/

CREATE SEQUENCE bbs_seq
    INCREMENT BY 1
    START WITH 1
    CACHE 20
    NOCYCLE;


/*2. 사원의 급여 지급액으로 검색을 하고 싶습니다. 급여 지급액으로 인덱스를 생성하세요.
조건1) 인덱스 이름은 idx_emp_realsal입니다.
조건2) 급여 지급액 계산식은 SALARY + SALARY * COMMISSION_PCT입니다.*/

CREATE INDEX idx_emp_realsal
ON emps (COALESCE(salary+salary*commission_pct, salary));
