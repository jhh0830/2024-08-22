/*
    < SEQUENCE 시퀀스 >
    
    자동으로 번호를 발생시켜주는 역할을 하는 객체
    정수값을 자동으로 "순차적으로 생성해줌
    
    예) 회원번호, 사번, 게시글번호
       PRIMARY KEY 역할을 할 정수값을 "채번" 할 때 많이 씀
       
    
    1. 시퀀스 객체 생성 구문
    
    
    [ 표현법 ]
    
    CREATE SEQUENCE 시퀀스명
    START WITH 시작수        => 처음발생시킬 시작값 지정
    INCREMENT BY 증가값      => 몇 씩 증가시킬건지 결정
    MAXVLAUE 최대값          => 최대값 지정
    MINVLAUE 최소값          => 최소값 지정
    CYCLE/NOCYCLE           => 값 순환 여부 지정
    CACHE 바이트 크기/NOCACHE => 캐시메모리 사용 여부 지정
                                CACHE_SIZE 기본값은 20BYTE
    => 위의 모든 옵션들은 생략 가능함!!
    
    * 캐시메모리
    미리 앞으로 발생될 정수값들을 생성해서 저장해두는 공간
    매번 호출할 때 마다 새로이 번호를 생성하는 것 보다
    캐시메모리 공간에 미리 생성된 번호를 저장해두고 바로 가져다 쓰게 되면
    훨씬 속도가 빠름
    단, 해당 계정의 접속이 끊기고 나서 재접속 후에는
    기존 캐시메모리에 저장된 정수값들은 날라라고 없음!!
                                    
                                                   
*/
/*
    참고) 접두사
    - 테이블명 : TB_XXX
    - 뷰명 : VW_XXX
    - 시퀀스명 : SEQ_XXX
    
*/
CREATE SEQUENCE SEQ_TEST;

-- 시퀀스의 정보는 접속 탭에서 확인 가능
-- 또는 USER_SEQUENCES 데이터 딕셔너리를 통해 확인 가능
-- : 현재 접속한 이 계정이 가지고 있는 시퀀스들에 대한 정보들이 저장됨
SELECT * FROM USER_SEQUENCES;

-- 옵션을 조합해서 생성해보기
CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;
---------------------------------------------------------------------
/*
    2. 시퀀스 사용 구문
    
    - 시퀀스명.CURRVAL
    : 현재 시퀀스의 값
      마지막으로 성공적으로 발생된 NEXTVAL 값
      (마지막으로 발생된 NEXTVAL 값을 저장하는 변수같은 존재)
      
    - 시퀀스명.NEXTVAL
    : 다음 번호를 발생키셔주는 구문
      기존의 시퀀스 값에서 INCREMENT BY 값만큼 증가된 값을 리턴
      즉, 시퀀스명.CURRVAL + INCEMENT BY 값
      
      
      
    
*/

-- 발생된 시퀀스의 번호값을 단순히 출력해보고 싶음
-- (DUAL 테이블을 통해 발생된 정수를 단순히 출력)

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;
--> 시퀀스 생성 후 단 한번이라도 NEXTVAL 을 수행하지 않았다면
-- CURRVAR 구문을 수행할 수 없음!!
-- 즉, CURRVAL 은 마지막으로 성공적으로 수행된 NEXTVAL 을 담는 변수

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --300
--> 내부적으로 300 이라는 값이 CURRVAR 에 담긴 것!!


SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; -- 300

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; -- 305
--> 내부적으로 305 값이 CURRVAL 에 담기는 동작까지 수행됨

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; -- 305

-- 데이터 딕셔너리를 통해 시퀀스 정보 재확인
SELECT * FROM USER_SEQUENCES;
--> USER_SEQUENCES 데이터 딕셔너리의 LAST_NUMBER 컬럼
-- 현재 LAST_NUMBER 컬럼에 310 이 들어있음
-- LAST_NUMBER : 현재 시점에서 NEXTVAL 을 수행할 경우의 예상 값

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; -- 310
SELECT * FROM USER_SEQUENCES;
--> 이 시점 기준으로 LAST_NUMBER 는 315

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --오류남
--> 지정한 MAXVALUE 값인 310을 초과했기 때문에 번호 발생 불가!!
SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; -- 310
--> 항상 CURRVAL 에는 "마지막" 으로 "성공적" 으로 수행된 NEXTVAL 값이 담김!!

-------------------------------------------------------------------------------
/*
    3. 시퀀스 변경
    
    [ 표현법 ]
    
    ALTER SEQUENCE 시퀀스명
    INCREMENT BY 증가값            => 몇 씩 증가시킬건지 결정
    MAXVALUE 최대값                => 최대값 지정
    MINVALUE 최소값                => 최소값 지정
    CYCYLE/NOCYCYLE               => 값의 순환 여부 지정
    CACHE 바이트 크기/NOCACHE       => 캐시메모리 여주 지정
    
    => 모든 옵션은 생략 가능
    => START WITH 는 변경 불가!!
      정 바꾸고 싶다면 해당 시퀀스를 삭제했다가 다시 생성해야함
*/


-- SEQ_EMPNO 을 변경
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;


-- 데이터 딕셔너리로 재확인
SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; -- 310
SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; -- 320

-- 이 시점 기준으로 SEQ_EMPNO.CURRVAL 을 수행하면 320 이 나옴
-- 이 시점 기준으로 데이터 딕셔너리의 LAST_NUMBER 은 330 이 나옴

-- 주의사항
-- 후진은 안됨!! 이미 발생한 NEXTVAL 값은 못되돌림!!

-- SEQUENCE 를 삭제하고자 한다면?
-- DROP SEQUENCE 시퀀스명;
DROP SEQUENCE SEQ_EMPNO;

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;
-- ORA-02289: sequence does not exist 오류 발생

----------- 시퀀스가 사용되는 예시 --------------------

-- EMPLOYEE 테이블에 사원 정보를 추가하는 기능 구현중..

-- 사원이 매번 추가될 때 마다
-- 사번 (EMP_D) 을 새롭게 발생시키는 시퀀스 생성해보기
CREATE SEQUENCE SEQ_EID
START WITH 300;


-- 사원이 추가될때마다 실행할 INSERT 문
INSERT INTO EMPLOYEE VALUES(SEQ_EID.NEXTVAL
                          , '김갑생'
                          , '991111-1111111'
                          , 'user11@naver.com'
                          , '01012345555'
                          , NULL
                          , 'J7'
                          , 'S3'
                          , 3500000
                          , NULL 
                          , 201
                          , SYSDATE
                          , NULL
                          , 'N');
                          
                          
SELECT * FROM EMPLOYEE;     

INSERT INTO EMPLOYEE VALUES(SEQ_EID.NEXTVAL
                          , '강개순'
                          , '991122-2222222'
                          , 'user22@naver.com'
                          , '01012342222'
                          , NULL
                          , 'J7'
                          , 'S3'
                          , 3500000
                          , NULL 
                          , 201
                          , SYSDATE
                          , NULL
                          , 'N');
SELECT * FROM EMPLOYEE;  
--> 주로 INSERT 문 내부에서
-- 컬럼값을 자동 발생시켜서 넣고자 할 때 많이 쓰임!!

-- 위의 과정에서 사원이 추가될때마다 실행되는
-- INSERT 구문의 규칙을 찾아보자면..

INSERT INTO EMPLOYEE VALUES(SEQ_EID.NEXTVAL
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , ?
                          , SYSDATE
                          , NULL
                          , 'N');
                          
--> JDBC 시간에 이런 식으로 활용해볼것 
