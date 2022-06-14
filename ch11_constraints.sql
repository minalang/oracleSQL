/* 11. 제약조건(Constraints) */

----- 1. 제약조건이란? -----
SELECT * FROM USER_CONSTRAINTS WHERE table_name = 'EMPLOYEES';

--- 1.2 열 레벨 제약조건 ---
CREATE TABLE emp4(
    empno NUMBER(4) CONSTRAINT emp4_empno_pk PRIMARY KEY,
    ename  VARCHAR2(10) NOT NULL,
    sal NUMBER(7, 2)    CONSTRAINT emp4_sal_ck  CHECK(sal<=10000),
    deptno  NUMBER(2)   CONSTRAINT emp4_deptno_dept_deptid_fk  REFERENCES departments(department_id)
    );

---1.3 테이블 레벨 제약조건 ---
-- 하나 이상의 열을 참조하고 테이블의 열 정의와는 개별적으로 정의, NOT NULL제약조건은 정의할 수 없다
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

----- 2. 제약조건 종류 -----

--- 2.1 NOT NULL 제약조건
--- 2.2 PRIMARY KEY 제약조건
-- -> 둘은 테이블레벨과 열레벨 모두에서 정의가능

-- 2.3 UNIQUE 제약조건
ALTER TABLE emp4
ADD (nickname VARCHAR2(20));

SELECT * FROM emp4;
DESC emp4;
ALTER TABLE emp4
ADD CONSTRAINT emp4_nickname_uk UNIQUE(nickname);

INSERT INTO emp4
VALUES(1000, 'KILDONG', 2000, 10, NULL);

INSERT INTO emp4
VALUES(2000, 'KILSEO', 3000, 20, NULL); -- null값은 중복해서 가질 수 있음. 값이 없는 것이므로 그 자체로 unique함

INSERT INTO emp4
VALUES(3000, 'KILWOO', 3000, 20, 'kwoo');

INSERT INTO emp4
VALUES(4000, 'KILWI', 3000, 20, 'kwi');


UPDATE emp4 SET nickname = 'kwoo' WHERE empno = 4000; -- 무결성 제약조건에 위배

--- 2.4 FOREIGN KEY 제약조건(참조 무결성 제약조건)
-- 테이블의 열 또는 열의 집합을 외래키로 지정하여 동일테이블 또는 다른 테이블 간의 기본키 또는

--- 2.5 CHECK제약조건
-- 각 행을 만족해야하는 조건을 정의

----- 3. 제약조건관리 -----
-- 추가
ALTER TABLE emps
ADD CONSTRAINT  emps_mgr_fk FOREIGN KEY(mgr)    REFERENCES  emps(empno);

-- 조회
SELECT constraint_name, constraint_type, status
FROM USER_CONSTRAINTS
WHERE table_name = 'EMPS';
/* 제약조건 유형(CONSTRAINT_TYPE)은 다음과 같습니다.
- C (check constraint on a table)
- P (primary key)
- U (unique key)
- R (referential integrity)
- V (with check option, on a view)
- O (with read only, on a view)*/

--삭제
ALTER TABLE emps DROP CONSTRAINT emps_mgr_fk;

-- 비활성화
ALTER TABLE emp4 DISABLE CONSTRAINT emp4_sal_ck;

-- 활성화
ALTER TABLE emp4 ENABLE NOVALIDATE CONSTRAINT emp4_sal_ck; -- 검사하지 않고 활성화
ALTER TABLE emp4 ENABLE VALIDATE CONSTRAINT emp4_sal_ck; --이건 제약조건 활성화해도되는지 체크 후 활성화

----- 4. 연습문제 -----
/*1. 회원 정보를 저장하는 테이블(member)을 생성하세요. 회원 정보는 사용자 아이디(15),
이름(20), 비밀번호(20), 전화번호(15), 이메일(100)을 포함해야 합니다. 괄호 안의 숫자
는 크기입니다. 회원 정보를 저장하는 테이블은 사용자 아이디를 PK로 갖습니다.*/
CREATE TABLE member(
   user_id  VARCHAR2(15)    PRIMARY KEY,
   user_name    VARCHAR2(20),
   pw   VARCHAR2(15),
   email    VARCHAR2(100));


/*2. 다음 테이블 구문을 수정해서 제약조건을 추가하세요.
- DEPT 테이블의 DEPTNO 열은 주키(primary key) 열이어야 합니다. 제약조건의 이름
은 pk_dept로 하세요.
- EMP 테이블의 EMPNO 열은 주키(primary key) 열이어야 합니다. 제약조건의 이름
은 pk_emp로 하세요.
- EMP 테이블의 DEPTNO 열은 DEPT 테이블의 DEPTNO 열을 참조하는 외래키
(foreign key)여야 합니다. 제약조건의 이름은 fk_deptno로 하세요.*/

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

-- 제약조건 추가할 때
ALTER TABLE emp4
ADD CONSTRAINT emp4_nickname_uk UNIQUE(nickname);
