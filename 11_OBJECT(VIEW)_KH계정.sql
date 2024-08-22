/*
    < VIEW 뷰>
    
    SELECT (쿼리문) 을 저장해둘 수 있는 객ㅊ
    (자주 쓰이는 긴 SELECT 문을 저장해두면
    긴 SELECT 문을 매번 다시 기술할 필요가 없음)
    조회용 임시 테이블 같은 존재
    => 실제 데이터가 담겨있는 것은 아님 (저장용X)
    
*/

-- 뷰를 사용하는 이유
-- 예) "한국" 에서 근무하는 사원들의 사번, 이름, 부서명, 급여,
--    근무국가명, 직급명을 조회하시오
SELECT EMP_ID, EMP_NAME ,DEPT_TITLE, NATIONAL_NAME, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE= N.NATIONAL_CODE(+)
AND E.JOB_CODE = J.JOB_CODE -- 연결고리에 대한 조건
AND N.NATIONAL_NAME = '한국'; -- 추가적인 조건
--> 업무상 위의 긴 쿼리문이 자주 많이 쓰일 경우
-- 매번 필요할때마다 위의 쿼리문을 계속 기술해서 써야함!!

/*
    1. VIEW 생성 방법 (CREATE)
    
    [ 표현법 ]
    CREATE VIEW 뷰명
    AS (서브쿼리);
    
    CREATE OR REPLACE VIEW 뷰명
    AS (서브쿼리);
    => OR REPLACE 는 생략 가능하다.
       뷰 생성 시 기존에 중복된 이름의 뷰가 없다면
       새로이 뷰를 추가하고
       뷰 생성 시 기존에 중복된 이름의 뷰가 있다면
       해당 뷰를 변경 (갱신) 하는 옵션
    
*/

-- 위의 복잡했던 SELECT 문을 뷰로 저장하기
CREATE VIEW VW_EMPLOYEE
AS (SELECT EMP_ID, EMP_NAME ,DEPT_TITLE, NATIONAL_NAME, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE= N.NATIONAL_CODE(+)
AND E.JOB_CODE = J.JOB_CODE);
--> 현재 KH 계정에 뷰 생성 권한이 없어서 오류 발생
-- ORA-01031: insufficient privileges
-- (불충분한 권한)

--> 관리자 계정에서 GRANT CREATE VIEW TO KH; 구문으로 권한 부여 하기
-- 아래의 구문만 관리자 계정에서  실행할것!!
GRANT CREATE VIEW TO KH;

--> 위의 뷰 생성 구문 다시 실행
-- 이제는 잘 생성됨!!

SELECT * FROM VW_EMPLOYEE;


-- 한국에서 근무하는 사원들만 보기
SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

-- 러시아에서 근무하는 사원들만 보기
SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '러시아';

-- 일본에서 근무하는 사원들의 사번, 이름, 직급명, 보너스를 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, BONUS
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '일본';
--> VW_EMPLOYEE 뷰에는 BONUS 컬럼이 없기 때문에 오류 발생

-- BONUS 컬럼이 없는 뷰에서 보너스도 같이 조회 하고 싶을 경우 
-- 방법 1. 뷰를 삭제하고 BONUS 컬럼을 추가한 뷰를 새로이 다시 만들기
-- 방법 2. CREATE OR REPLACE VIEW 명령어를 사용하는 방법

CREATE OR REPLACE VIEW VW_EMPLOYEE
AS (SELECT EMP_ID, EMP_NAME ,DEPT_TITLE, NATIONAL_NAME, JOB_NAME , BONUS
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE= N.NATIONAL_CODE(+)
AND E.JOB_CODE = J.JOB_CODE);

SELECT EMP_ID, EMP_NAME , JOB_NAME, BONUS
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '일본';

--> 기존의 뷰 변경 후 오류 사라짐!!

-- 뷰는 논리적인 가상테이블이다.
-- 즉, 실질적으로 데이터를 저장하고 있지는 않음!!
-- 단순히 "SELECT 문" 이 TEXT 문구로 저장되어있음!! 
-- 참고) USER_VIEWS : 해당 계정이 가지고있는 VIEW 들에 대한 내용을
--                   가지고 있는 데이터 딕셔너리

SELECT * FROM USER_VIEWS;

-------------------------------------------------------------------

/*
    * 뷰 생성 시 컬럼에 별칭 부여하기
    
    서브쿼리의 SELECT 절에
    함수식 또는 연산식이 포함된 경우 반드시 별칭 부여해야함!!
    
    
*/
    
-- 사원의 사번, 이름, 직급명, 성별, 근무년수를 조회할 수 있는
-- SELECT 문을 뷰로 정의

SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DECODE(SUBSTR(EMP_NO, 8 ,1), '1','남','2','여')
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
 FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE);
 
CREATE OR REPLACE VIEW VW_EMP_JOB
AS (SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DECODE(SUBSTR(EMP_NO, 8 ,1), '1','남','2','여') 
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 
 FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE));
--> 별칭을 지정하지 않아서 오류 발생
-- ORA-00998: must name this expression with a column alias
-- ALIAS : 별칭

CREATE OR REPLACE VIEW VW_EMP_JOB
AS (SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DECODE(SUBSTR(EMP_NO, 8 ,1), '1','남','2','여') AS "성별"
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근무년수"
 FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE));
--> 뷰 생성 성공
SELECT * FROM VW_EMP_JOB;

-- 또 다른 방법으로도 별칭 부여 가능!!
-- 단, 모든 컬럼에 대한 별칭을 모두 다 기술해야함!!
CREATE OR REPLACE VIEW  VW_EMP_JOB (사번, 사원명, 직급명, 성별, 근무년수)
AS (SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DECODE(SUBSTR(EMP_NO, 8 ,1), '1','남','2','여') AS "성별"
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근무년수"
     FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE));
SELECT * FROM VW_EMP_JOB;

-- 뷰의 컬럼에 별칭을 지정했다면?
--> 조회 시 메인쿼리 부분에서 별칭 사용 가능
-- 여자인 사원들의 사원명, 직급명 조회
SELECT 사원명, 직급명
 FROM VW_EMP_JOB
WHERE 성별 = '여';

-- 근무년수가 20년 이상인 사원들의 모든 컬럼 조회
SELECT * FROM VW_EMP_JOB
WHERE 근무년수 >= 20;


-- 뷰를 삭제하고자 한다면?
-- DROP VIEW 뷰명;
DROP VIEW VW_EMP_JOB;
SELECT * FROM VW_EMP_JOB;
-- > 뷰 삭제 시 조회 안됨!!
-- 뷰가 삭제되었다고 해서 데이터가 삭제된건 아님!!

-------------------------------------------------------

/*
    * 생성된 뷰를 이용해서 DML (INSERT, UPDATE, DELETE) 사용 가능
    단, 뷰를 통해서 데이터 내용을 변경하게 되면
    실제 데이터가 담겨있는 실질적인 테이블 (베이스 테이블, 원본 테이블)
    에도 적용이 된다!!
    
    
*/
-- 테스트용 뷰 생성
CREATE OR REPLACE VIEW VW_JOB
AS (SELECT * FROM JOB);

SELECT * FROM VW_JOB; -- 뷰를 조회
SELECT * FROM JOB;    -- 원본테이블을 조회

-- 뷰에 INSERT
INSERT INTO VW_JOB VALUES('J8', '인턴');
-- > 뷰명을 기술했음에도 불구하고 INSERT 가 잘 됨

SELECT * FROM VW_JOB; -- 뷰를 조회
SELECT * FROM JOB;    -- 원본테이블을 조회
--> 뷰에 ISERT 를 한다 하더라도
--  뷰에 데이터가 실제로 INSERT 되는게 아니라
--  그 뷰를 만들기 위한 원본 테이블 (베이스 테이블) 에 INSERT 된 것

-- JOB_CODE 가 J8 인 JOB_NAME 을 알바로 UPDATE
UPDATE VW_JOB SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

SELECT * FROM VW_JOB;
SELECT * FROM JOB;
--> UPDATE 도 마찬가지로 원본 테이블 내용이 변경됨


-- 뷰에 DELETE
-- JOB_CODE 가 J8 인 행 삭제
DELETE FROM VW_JOB
WHERE JOB_CODE ='J8';

SELECT * FROM VW_JOB;
SELECT * FROM JOB;
--> DELETE 도 마찬가지로 원본 테이블에서 삭제됨

/*
    * 하지만 뷰를 가지고 DML 이 불가능한 경우가 더 많음!!
    
    1) 뷰에 정의되어있지 않은 컬럼을 조작하는 경우
    2) 뷰에 정의되어있지 않은 컬럼 중에
       베이스 테이블 상에 NOT NULL 제약조건이 지정된 경우
    3) 산술연산식 또는 함수식을 통해 뷰를 정의한 경우
    4) 그룹함수나 GROUP BY 절이 포함된 경우
    5) DISTINCT 구문이 포함된 경우
    6) JOIN 을 이용해서 여러 테이블을 매칭시켜 놓은 경우
    
*/
-- 예)
CREATE OR REPLACE VIEW VW_JOB
AS (SELECT JOB_CODE
            FROM JOB);
SELECT * FROM VW_JOB;

INSERT INTO VW_JOB(JOB_CODE, JOB_NAME)
            VALUES('J8','인턴');
--> INSERT 안됨 명시적으로 뷰 자체에는 JOB_NAME이라는 컬럼은 존재하지않는다.

UPDATE VW_JOB SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J7';
--> UPDATE 안됨

DELETE 
FROM VW_JOB
WHERE JOB_NAME = '사원';
--> DELETE 안됨

--> 현재 VW_JOB 뷰에 존재하지 않는 JOB_NAME 컬럼에
-- 값을 추가, 변경, 삭제하고자 하여 오류 발생
-- (아무리 원본 테이블에는 있어도 정작 뷰에는 없는 컬럼을 건들일때)

-- 예2)
CREATE OR REPLACE VIEW VW_EMP_SAL
AS (SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 "연봉"
    FROM EMPLOYEE);

SELECT * FROM VW_EMP_SAL;

INSERT INTO VW_EMP_SAML VALUES(400
                             , '박말순'
                             , 3000000
                             , 36000000);
                             
-- INSERT 안됨

--> 이 경우에는 UPDATE 와 DELETE 또한 안될것!!
-- 원본 테이블인 EMPLOYEE 테이블에 "연봉" 을 나타내는 컬럼이
-- 애초에 존재하지 않기 때문!!

--> 위와 같이 뷰에 DML 문이 처리 안되는 경우가 더 많음!!

ROLLBACK;

----------------------------------------------------------------

/*
    * VIEW 생성 시 사용 가능한 옵션들
    
    [ 최종 상세 표현법 ]
    
    CREATE OR REPLACE FOR/NOFORCE VIEW 뷰명
    AS (서브쿼리)
    WITH CHECK OPTION
    WITH READ ONLY;
    
    1) OR REPLACE
    해당 뷰 이름이 이미 존재하면 갱신시켜주는 옵션
    (해당 뷰 이름이 존재하지 않으면 새로이 생성해줌)
    
    
    2) FORCE/NOFORCE
    - FORCE : 서브쿼리에 기술된 테이블이 실제로 존재하지 않아도 뷰가 생성
    - NOFORCE : 서브쿼리에 기술된 테이블이 반드시 존재해야지만 뷰가 생성 (생략 시 기본값)
    
    
    3) WITH CHECK OPTION
    서브쿼리의 조건절 (WHERE 절) 에 기술된 내용에 만족하는 값으로만
    뷰에 DML 이가능하게끔 해주는 옵션
    조건에 부합하지 않는 값으로 DML 구문을 실행하는 순간 오류 발생
    
    4) WITH READ ONLY
    뷰에 대해 조회만 가능하게끔 해주는 옵션 (DML 수행불가)
   
    
*/

-- 2) FORCE/NOFORCE
CREATE OR REPLACE /* NOFORCE */VIEW VW_TEST
AS (SELECT TCODE, TNAME, TCONTENT FROM TT);
--> TT 라는 테이블이 존재하지 않아서 뷰 생성 시 오류 발생
-- TABLE OR VIEW DOES NOT EXIST
CREATE OR REPLACE FORCE VIEW VW_TEST
AS (SELECT TCODE, TNAME, TCONTENT FROM TT);

-- 실행은 되고, 뷰도 생성이 되나
-- 경고 : 컴파일 오류와 함께 뷰가 생성되었습니다. 라고 뜸

SELECT * FROM VW_TEST;
--> 오류 발생
-- 단, 접속 탭에서는 확인 가능 함!!

-- 주로 추후에 해당 테이블이 만들어 질 것 같은 경우에 쓰임

CREATE TABLE TT (
    TCODE NUMBER,
    TNAME VARCHAR2(30),
    TCONTENT VARCHAR2(50)
    
);


SELECT * FROM VW_TEST;
--> TT 테이블을 생성 후 다시 한번 VW_TEST 를 조회하면
-- 오류가 발생하지 않음!!


-- 3) WITH CHECT OPTION
CREATE OR REPLACE VIEW VW_EMP
AS (SELECT * FROM EMPLOYEE WHERE SALARY >= 3000000)
WITH CHECK OPTION;

SELECT * FROM VW_EMP;

-- VW_EMP 테이블에 UPDATE 문 적용
UPDATE VW_EMP
    SET SALARY = 10000
    WHERE EMP_ID = 200;
--> 서브쿼리에 기술한 조건에 부합하지 않기 때문에 UPDATE 불가

UPDATE VW_EMP
 SET SALARY = 10000000
 WHERE EMP_ID = 200;
--> 서브쿼리에 기술한 조건에 부합하기 떄문에 UPDATE 가능

ROLLBACK;

-- 4) WITH READ ONLY
CREATE OR REPLACE VIEW VW_EMP_BONUS
AS (SELECT EMP_ID, EMP_NAME, BONUS
    FROM EMPLOYEE
    WHERE BONUS IS NOT NULL)
    WITH READ ONLY;
SELECT * FROM VW_EMP_BONUS;

DELETE FROM VW_EMP_BONUS
WHERE EMP_ID = 200;
--> DML 조작 자체가 불가해짐
-- SQL 오류: ORA-42399: cannot perform a DML operation on a read-only view


















