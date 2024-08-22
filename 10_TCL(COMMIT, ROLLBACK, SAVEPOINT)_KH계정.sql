
/*
     < TCL >
       
      TRANSACTION CONTROL LANGUAGE
      트랜잭션 제어 언어
      
      * 트랜잭션 (TRANSACTION)
      - 데이터베이스의 논리적 연산 단위
      - 쉽게 생각하면 웹 개발 시의 "기능 1개" 의 단위
      예) 로그인 기능, 회원가입 기능, 게시글 작성 기능. ..
      => 하나의 기능을 구현할 때 
      무조건 쿼리문이 1개만 필요하다는 법은 없음!!
      필요하다면 2개의 이상의 쿼리문들이 묶여서 하나의 기능을 이루어냄
      이 경우에는 그 쿼리문들이 "순차적으로 모두 성공적으로"
      실행되야 해당 기능이 제대로 동작한다고 볼 수 있음!!
 -  여러개의 쿼리문들을 하나의 트랜잭션으로 묶어서 처리함
 - 단, INSERT, UPDATE, DELETE 문에만 해당됨 (SELECT 문은 해봣자 어차피 보여주기만 하고 테이블에 변화가 없기때문에)
   즉, 데이터의 변경 사항 (DML) 들을 한번에 트랜잭션에 담았다가
   한번에 처리하는 원리라고 보면 됨
   
   
   * TCL 종류
   - COMMIT;
   하나의 트랜잭션에 담겨있는 변경사항들을
   실제 DB 에 반영하겠다는 것을 의미함 (데이터 변동사항 픽스)
   실제 DB 에 반영시킨 후 트랜잭션은 비워짐!!
   
   
   - ROLLBACK;
   하나의 트랜잭션에 담겨있는 변경사항들을
   삭제한 후 마지막 COMMIT 시점으로 돌아감
   
   - SAVEPOINT 포인트명;
   현재 이 시점에 임시저장점을 정의해두는 것
   (여러개 잡아둘 수 있다)
   
   - ROLLBACK TO 포인트명;
   전체 변경사항들을 모두 삭제하는게 아니라
   해당 포인트 지점까지만 롤백하겠다.
   
   
*/

SELECT * FROM EMP_01;
--> 전체 사원은 26명

-- 사번이 901 인 사원 삭제
DELETE 
FROM EMP_01
WHERE EMP_ID=901;

-- 사번이 900 인 사원 삭제
DELETE
FROM EMP_01
WHERE EMP_ID=900;

SELECT * FROM EMP_01;
--> 24명의 사원이 조회됨

ROLLBACK;

SELECT * FROM EMP_01;
-- 총 24명의 사원이 조회됨

-------------------------------

-- 사번이 200인 사원 삭제
DELETE
FROM EMP_01
WHERE EMP_ID= 200;

-- 사번 800, 이름 홍길동, 부서는 총무부인 사원 추가
INSERT INTO EMP_01 VALUES(800
                        , '홍길동'
                        , '총무부');

SELECT * FROM EMP_01;

--> 총 26명은 맞으나
-- 200 사원이 삭제되고 800 사원이 추가됨


COMMIT;


SELECT * FROM EMP_01;
--> 위의 변동사항이 픽스됨

------------------------------------------

-- 사번 200, 이름 김가현, 부서 교육부인 사원 추가
INSERT INTO EMP_01 VALUES(200
                        , '김가현'
                        , '교육부');
                        
ROLLBACK;

SELECT * FROM EMP_01;
--> 그냥 ROLLBACK 명령을 실행할 경우
--  마지막 COMMIT 시점으로 돌아감!!

----------------------------------------------------------

-- 사번이 217, 216, 214 인 사원 삭제
DELETE
FROM EMP_01
WHERE EMP_ID IN (217,216,214);

-- 3개의 행이 삭제된 시점에서
-- SAVEPOINT 지정
SAVEPOINT SP1;

-- 사번이 801, 이름 김말똥, 부서는 인사부인 사원 추가
INSERT INTO EMP_01 VALUES (801
                         , '김말똥'
                         , '인사부');
-- 사번이 218번 인 사원 삭제
DELETE 
FROM EMP_01
WHERE EMP_ID=218;

-- SP1 시점으로 되돌리기
ROLLBACK TO SP1;

COMMIT;

SELECT * FROM EMP_01;
--> 커밋 후 23명의 사원 정보 조회됨

-----------------------------------------

-- 200, 김가현, 교육부 추가
INSERT INTO EMP_01 VALUES(200
                         , '김가현'
                         , '교육부');

                         
SAVEPOINT SP1;                         

-- 218번 사원 삭제
DELETE
FROM EMP_01
WHERE EMP_ID = 218;

SAVEPOINT SP2;

-- 900, 901 사원 삭제
DELETE
FROM EMP_01
WHERE EMP_ID >= 900;

-- 이 시점에서 
-- ROLLBACK; 을 실행하면?
-- 모든 TRANSACTION 변경사항이 날라감

-- ROLLBACK TO SP1; 을 실행하면?
-- 218, 900, 901 사원 삭제 변경사항만 날라감

-- ROLLBACK TO SP2; 를 실행하면?
-- 900, 901 사원 삭제 변경사항만 날라감

-- COMMIT; 을 실행하면?
-- 전체 변경사항이 DB에 반영되고
-- TRANSACTION 깨끗이 비워짐!!

ROLLBACK TO SP1;

COMMIT;

----------------------------------------------

SELECT * FROM EMP_01;
--> 24명의 사원

-- 사번이 900, 901인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (900,901);
-- 사번이 218 인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 218;

-- 테이블 생성 (DDL)
CREATE TABLE TEST(
TID NUMBER
);
--> DDL 수행 시 자동 커밋됨!!

/*
    * DDL 구문을 실행하는 순간
    (CREATE, ALTER, DROP)
    기존에 트랜잭션에 있던 모든 변경사항들을
    무조건 실제 DB에 반영 (COMMIT) 시킨 후
    내부적으로 DDL 이 수행됨!!
    => 즉, DDL 수행 전 변경사항이 있다면
       정확히 (COMMIT, ROLLBACK) "픽스" 하고
       DDL 을 실행하는 것이 좋다!!
*/

ROLLBACK;

SELECT * FROM EMP_01;

















