/*
    < SEQUENCE ������ >
    
    �ڵ����� ��ȣ�� �߻������ִ� ������ �ϴ� ��ü
    �������� �ڵ����� "���������� ��������
    
    ��) ȸ����ȣ, ���, �Խñ۹�ȣ
       PRIMARY KEY ������ �� �������� "ä��" �� �� ���� ��
       
    
    1. ������ ��ü ���� ����
    
    
    [ ǥ���� ]
    
    CREATE SEQUENCE ��������
    START WITH ���ۼ�        => ó���߻���ų ���۰� ����
    INCREMENT BY ������      => �� �� ������ų���� ����
    MAXVLAUE �ִ밪          => �ִ밪 ����
    MINVLAUE �ּҰ�          => �ּҰ� ����
    CYCLE/NOCYCLE           => �� ��ȯ ���� ����
    CACHE ����Ʈ ũ��/NOCACHE => ĳ�ø޸� ��� ���� ����
                                CACHE_SIZE �⺻���� 20BYTE
    => ���� ��� �ɼǵ��� ���� ������!!
    
    * ĳ�ø޸�
    �̸� ������ �߻��� ���������� �����ؼ� �����صδ� ����
    �Ź� ȣ���� �� ���� ������ ��ȣ�� �����ϴ� �� ����
    ĳ�ø޸� ������ �̸� ������ ��ȣ�� �����صΰ� �ٷ� ������ ���� �Ǹ�
    �ξ� �ӵ��� ����
    ��, �ش� ������ ������ ����� ���� ������ �Ŀ���
    ���� ĳ�ø޸𸮿� ����� ���������� ������ ����!!
                                    
                                                   
*/
/*
    ����) ���λ�
    - ���̺�� : TB_XXX
    - ��� : VW_XXX
    - �������� : SEQ_XXX
    
*/
CREATE SEQUENCE SEQ_TEST;

-- �������� ������ ���� �ǿ��� Ȯ�� ����
-- �Ǵ� USER_SEQUENCES ������ ��ųʸ��� ���� Ȯ�� ����
-- : ���� ������ �� ������ ������ �ִ� �������鿡 ���� �������� �����
SELECT * FROM USER_SEQUENCES;

-- �ɼ��� �����ؼ� �����غ���
CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;
---------------------------------------------------------------------
/*
    2. ������ ��� ����
    
    - ��������.CURRVAL
    : ���� �������� ��
      ���������� ���������� �߻��� NEXTVAL ��
      (���������� �߻��� NEXTVAL ���� �����ϴ� �������� ����)
      
    - ��������.NEXTVAL
    : ���� ��ȣ�� �߻�Ű���ִ� ����
      ������ ������ ������ INCREMENT BY ����ŭ ������ ���� ����
      ��, ��������.CURRVAL + INCEMENT BY ��
      
      
      
    
*/

-- �߻��� �������� ��ȣ���� �ܼ��� ����غ��� ����
-- (DUAL ���̺��� ���� �߻��� ������ �ܼ��� ���)

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;
--> ������ ���� �� �� �ѹ��̶� NEXTVAL �� �������� �ʾҴٸ�
-- CURRVAR ������ ������ �� ����!!
-- ��, CURRVAL �� ���������� ���������� ����� NEXTVAL �� ��� ����

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --300
--> ���������� 300 �̶�� ���� CURRVAR �� ��� ��!!


SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; -- 300

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; -- 305
--> ���������� 305 ���� CURRVAL �� ���� ���۱��� �����

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; -- 305

-- ������ ��ųʸ��� ���� ������ ���� ��Ȯ��
SELECT * FROM USER_SEQUENCES;
--> USER_SEQUENCES ������ ��ųʸ��� LAST_NUMBER �÷�
-- ���� LAST_NUMBER �÷��� 310 �� �������
-- LAST_NUMBER : ���� �������� NEXTVAL �� ������ ����� ���� ��

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; -- 310
SELECT * FROM USER_SEQUENCES;
--> �� ���� �������� LAST_NUMBER �� 315

SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; --������
--> ������ MAXVALUE ���� 310�� �ʰ��߱� ������ ��ȣ �߻� �Ұ�!!
SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; -- 310
--> �׻� CURRVAL ���� "������" ���� "������" ���� ����� NEXTVAL ���� ���!!

-------------------------------------------------------------------------------
/*
    3. ������ ����
    
    [ ǥ���� ]
    
    ALTER SEQUENCE ��������
    INCREMENT BY ������            => �� �� ������ų���� ����
    MAXVALUE �ִ밪                => �ִ밪 ����
    MINVALUE �ּҰ�                => �ּҰ� ����
    CYCYLE/NOCYCYLE               => ���� ��ȯ ���� ����
    CACHE ����Ʈ ũ��/NOCACHE       => ĳ�ø޸� ���� ����
    
    => ��� �ɼ��� ���� ����
    => START WITH �� ���� �Ұ�!!
      �� �ٲٰ� �ʹٸ� �ش� �������� �����ߴٰ� �ٽ� �����ؾ���
*/


-- SEQ_EMPNO �� ����
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;


-- ������ ��ųʸ��� ��Ȯ��
SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL; -- 310
SELECT SEQ_EMPNO.NEXTVAL
FROM DUAL; -- 320

-- �� ���� �������� SEQ_EMPNO.CURRVAL �� �����ϸ� 320 �� ����
-- �� ���� �������� ������ ��ųʸ��� LAST_NUMBER �� 330 �� ����

-- ���ǻ���
-- ������ �ȵ�!! �̹� �߻��� NEXTVAL ���� ���ǵ���!!

-- SEQUENCE �� �����ϰ��� �Ѵٸ�?
-- DROP SEQUENCE ��������;
DROP SEQUENCE SEQ_EMPNO;

SELECT SEQ_EMPNO.CURRVAL
FROM DUAL;
-- ORA-02289: sequence does not exist ���� �߻�

----------- �������� ���Ǵ� ���� --------------------

-- EMPLOYEE ���̺� ��� ������ �߰��ϴ� ��� ������..

-- ����� �Ź� �߰��� �� ����
-- ��� (EMP_D) �� ���Ӱ� �߻���Ű�� ������ �����غ���
CREATE SEQUENCE SEQ_EID
START WITH 300;


-- ����� �߰��ɶ����� ������ INSERT ��
INSERT INTO EMPLOYEE VALUES(SEQ_EID.NEXTVAL
                          , '�谩��'
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
                          , '������'
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
--> �ַ� INSERT �� ���ο���
-- �÷����� �ڵ� �߻����Ѽ� �ְ��� �� �� ���� ����!!

-- ���� �������� ����� �߰��ɶ����� ����Ǵ�
-- INSERT ������ ��Ģ�� ã�ƺ��ڸ�..

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
                          
--> JDBC �ð��� �̷� ������ Ȱ���غ��� 
