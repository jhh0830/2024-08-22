/*
    < VIEW ��>
    
    SELECT (������) �� �����ص� �� �ִ� ����
    (���� ���̴� �� SELECT ���� �����صθ�
    �� SELECT ���� �Ź� �ٽ� ����� �ʿ䰡 ����)
    ��ȸ�� �ӽ� ���̺� ���� ����
    => ���� �����Ͱ� ����ִ� ���� �ƴ� (�����X)
    
*/

-- �並 ����ϴ� ����
-- ��) "�ѱ�" ���� �ٹ��ϴ� ������� ���, �̸�, �μ���, �޿�,
--    �ٹ�������, ���޸��� ��ȸ�Ͻÿ�
SELECT EMP_ID, EMP_NAME ,DEPT_TITLE, NATIONAL_NAME, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE= N.NATIONAL_CODE(+)
AND E.JOB_CODE = J.JOB_CODE -- ������� ���� ����
AND N.NATIONAL_NAME = '�ѱ�'; -- �߰����� ����
--> ������ ���� �� �������� ���� ���� ���� ���
-- �Ź� �ʿ��Ҷ����� ���� �������� ��� ����ؼ� �����!!

/*
    1. VIEW ���� ��� (CREATE)
    
    [ ǥ���� ]
    CREATE VIEW ���
    AS (��������);
    
    CREATE OR REPLACE VIEW ���
    AS (��������);
    => OR REPLACE �� ���� �����ϴ�.
       �� ���� �� ������ �ߺ��� �̸��� �䰡 ���ٸ�
       ������ �並 �߰��ϰ�
       �� ���� �� ������ �ߺ��� �̸��� �䰡 �ִٸ�
       �ش� �並 ���� (����) �ϴ� �ɼ�
    
*/

-- ���� �����ߴ� SELECT ���� ��� �����ϱ�
CREATE VIEW VW_EMPLOYEE
AS (SELECT EMP_ID, EMP_NAME ,DEPT_TITLE, NATIONAL_NAME, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE= N.NATIONAL_CODE(+)
AND E.JOB_CODE = J.JOB_CODE);
--> ���� KH ������ �� ���� ������ ��� ���� �߻�
-- ORA-01031: insufficient privileges
-- (������� ����)

--> ������ �������� GRANT CREATE VIEW TO KH; �������� ���� �ο� �ϱ�
-- �Ʒ��� ������ ������ ��������  �����Ұ�!!
GRANT CREATE VIEW TO KH;

--> ���� �� ���� ���� �ٽ� ����
-- ������ �� ������!!

SELECT * FROM VW_EMPLOYEE;


-- �ѱ����� �ٹ��ϴ� ����鸸 ����
SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '�ѱ�';

-- ���þƿ��� �ٹ��ϴ� ����鸸 ����
SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '���þ�';

-- �Ϻ����� �ٹ��ϴ� ������� ���, �̸�, ���޸�, ���ʽ��� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_NAME, BONUS
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '�Ϻ�';
--> VW_EMPLOYEE �信�� BONUS �÷��� ���� ������ ���� �߻�

-- BONUS �÷��� ���� �信�� ���ʽ��� ���� ��ȸ �ϰ� ���� ��� 
-- ��� 1. �並 �����ϰ� BONUS �÷��� �߰��� �並 ������ �ٽ� �����
-- ��� 2. CREATE OR REPLACE VIEW ��ɾ ����ϴ� ���

CREATE OR REPLACE VIEW VW_EMPLOYEE
AS (SELECT EMP_ID, EMP_NAME ,DEPT_TITLE, NATIONAL_NAME, JOB_NAME , BONUS
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE= N.NATIONAL_CODE(+)
AND E.JOB_CODE = J.JOB_CODE);

SELECT EMP_ID, EMP_NAME , JOB_NAME, BONUS
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '�Ϻ�';

--> ������ �� ���� �� ���� �����!!

-- ��� ������ �������̺��̴�.
-- ��, ���������� �����͸� �����ϰ� ������ ����!!
-- �ܼ��� "SELECT ��" �� TEXT ������ ����Ǿ�����!! 
-- ����) USER_VIEWS : �ش� ������ �������ִ� VIEW �鿡 ���� ������
--                   ������ �ִ� ������ ��ųʸ�

SELECT * FROM USER_VIEWS;

-------------------------------------------------------------------

/*
    * �� ���� �� �÷��� ��Ī �ο��ϱ�
    
    ���������� SELECT ����
    �Լ��� �Ǵ� ������� ���Ե� ��� �ݵ�� ��Ī �ο��ؾ���!!
    
    
*/
    
-- ����� ���, �̸�, ���޸�, ����, �ٹ������ ��ȸ�� �� �ִ�
-- SELECT ���� ��� ����

SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DECODE(SUBSTR(EMP_NO, 8 ,1), '1','��','2','��')
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
 FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE);
 
CREATE OR REPLACE VIEW VW_EMP_JOB
AS (SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DECODE(SUBSTR(EMP_NO, 8 ,1), '1','��','2','��') 
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 
 FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE));
--> ��Ī�� �������� �ʾƼ� ���� �߻�
-- ORA-00998: must name this expression with a column alias
-- ALIAS : ��Ī

CREATE OR REPLACE VIEW VW_EMP_JOB
AS (SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DECODE(SUBSTR(EMP_NO, 8 ,1), '1','��','2','��') AS "����"
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "�ٹ����"
 FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE));
--> �� ���� ����
SELECT * FROM VW_EMP_JOB;

-- �� �ٸ� ������ε� ��Ī �ο� ����!!
-- ��, ��� �÷��� ���� ��Ī�� ��� �� ����ؾ���!!
CREATE OR REPLACE VIEW  VW_EMP_JOB (���, �����, ���޸�, ����, �ٹ����)
AS (SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DECODE(SUBSTR(EMP_NO, 8 ,1), '1','��','2','��') AS "����"
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "�ٹ����"
     FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE));
SELECT * FROM VW_EMP_JOB;

-- ���� �÷��� ��Ī�� �����ߴٸ�?
--> ��ȸ �� �������� �κп��� ��Ī ��� ����
-- ������ ������� �����, ���޸� ��ȸ
SELECT �����, ���޸�
 FROM VW_EMP_JOB
WHERE ���� = '��';

-- �ٹ������ 20�� �̻��� ������� ��� �÷� ��ȸ
SELECT * FROM VW_EMP_JOB
WHERE �ٹ���� >= 20;


-- �並 �����ϰ��� �Ѵٸ�?
-- DROP VIEW ���;
DROP VIEW VW_EMP_JOB;
SELECT * FROM VW_EMP_JOB;
-- > �� ���� �� ��ȸ �ȵ�!!
-- �䰡 �����Ǿ��ٰ� �ؼ� �����Ͱ� �����Ȱ� �ƴ�!!

-------------------------------------------------------

/*
    * ������ �並 �̿��ؼ� DML (INSERT, UPDATE, DELETE) ��� ����
    ��, �並 ���ؼ� ������ ������ �����ϰ� �Ǹ�
    ���� �����Ͱ� ����ִ� �������� ���̺� (���̽� ���̺�, ���� ���̺�)
    ���� ������ �ȴ�!!
    
    
*/
-- �׽�Ʈ�� �� ����
CREATE OR REPLACE VIEW VW_JOB
AS (SELECT * FROM JOB);

SELECT * FROM VW_JOB; -- �並 ��ȸ
SELECT * FROM JOB;    -- �������̺��� ��ȸ

-- �信 INSERT
INSERT INTO VW_JOB VALUES('J8', '����');
-- > ����� ����������� �ұ��ϰ� INSERT �� �� ��

SELECT * FROM VW_JOB; -- �並 ��ȸ
SELECT * FROM JOB;    -- �������̺��� ��ȸ
--> �信 ISERT �� �Ѵ� �ϴ���
--  �信 �����Ͱ� ������ INSERT �Ǵ°� �ƴ϶�
--  �� �並 ����� ���� ���� ���̺� (���̽� ���̺�) �� INSERT �� ��

-- JOB_CODE �� J8 �� JOB_NAME �� �˹ٷ� UPDATE
UPDATE VW_JOB SET JOB_NAME = '�˹�'
WHERE JOB_CODE = 'J8';

SELECT * FROM VW_JOB;
SELECT * FROM JOB;
--> UPDATE �� ���������� ���� ���̺� ������ �����


-- �信 DELETE
-- JOB_CODE �� J8 �� �� ����
DELETE FROM VW_JOB
WHERE JOB_CODE ='J8';

SELECT * FROM VW_JOB;
SELECT * FROM JOB;
--> DELETE �� ���������� ���� ���̺��� ������

/*
    * ������ �並 ������ DML �� �Ұ����� ��찡 �� ����!!
    
    1) �信 ���ǵǾ����� ���� �÷��� �����ϴ� ���
    2) �信 ���ǵǾ����� ���� �÷� �߿�
       ���̽� ���̺� �� NOT NULL ���������� ������ ���
    3) �������� �Ǵ� �Լ����� ���� �並 ������ ���
    4) �׷��Լ��� GROUP BY ���� ���Ե� ���
    5) DISTINCT ������ ���Ե� ���
    6) JOIN �� �̿��ؼ� ���� ���̺��� ��Ī���� ���� ���
    
*/
-- ��)
CREATE OR REPLACE VIEW VW_JOB
AS (SELECT JOB_CODE
            FROM JOB);
SELECT * FROM VW_JOB;

INSERT INTO VW_JOB(JOB_CODE, JOB_NAME)
            VALUES('J8','����');
--> INSERT �ȵ� ��������� �� ��ü���� JOB_NAME�̶�� �÷��� ���������ʴ´�.

UPDATE VW_JOB SET JOB_NAME = '����'
WHERE JOB_CODE = 'J7';
--> UPDATE �ȵ�

DELETE 
FROM VW_JOB
WHERE JOB_NAME = '���';
--> DELETE �ȵ�

--> ���� VW_JOB �信 �������� �ʴ� JOB_NAME �÷���
-- ���� �߰�, ����, �����ϰ��� �Ͽ� ���� �߻�
-- (�ƹ��� ���� ���̺��� �־ ���� �信�� ���� �÷��� �ǵ��϶�)

-- ��2)
CREATE OR REPLACE VIEW VW_EMP_SAL
AS (SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 "����"
    FROM EMPLOYEE);

SELECT * FROM VW_EMP_SAL;

INSERT INTO VW_EMP_SAML VALUES(400
                             , '�ڸ���'
                             , 3000000
                             , 36000000);
                             
-- INSERT �ȵ�

--> �� ��쿡�� UPDATE �� DELETE ���� �ȵɰ�!!
-- ���� ���̺��� EMPLOYEE ���̺� "����" �� ��Ÿ���� �÷���
-- ���ʿ� �������� �ʱ� ����!!

--> ���� ���� �信 DML ���� ó�� �ȵǴ� ��찡 �� ����!!

ROLLBACK;

----------------------------------------------------------------

/*
    * VIEW ���� �� ��� ������ �ɼǵ�
    
    [ ���� �� ǥ���� ]
    
    CREATE OR REPLACE FOR/NOFORCE VIEW ���
    AS (��������)
    WITH CHECK OPTION
    WITH READ ONLY;
    
    1) OR REPLACE
    �ش� �� �̸��� �̹� �����ϸ� ���Ž����ִ� �ɼ�
    (�ش� �� �̸��� �������� ������ ������ ��������)
    
    
    2) FORCE/NOFORCE
    - FORCE : ���������� ����� ���̺��� ������ �������� �ʾƵ� �䰡 ����
    - NOFORCE : ���������� ����� ���̺��� �ݵ�� �����ؾ����� �䰡 ���� (���� �� �⺻��)
    
    
    3) WITH CHECK OPTION
    ���������� ������ (WHERE ��) �� ����� ���뿡 �����ϴ� �����θ�
    �信 DML �̰����ϰԲ� ���ִ� �ɼ�
    ���ǿ� �������� �ʴ� ������ DML ������ �����ϴ� ���� ���� �߻�
    
    4) WITH READ ONLY
    �信 ���� ��ȸ�� �����ϰԲ� ���ִ� �ɼ� (DML ����Ұ�)
   
    
*/

-- 2) FORCE/NOFORCE
CREATE OR REPLACE /* NOFORCE */VIEW VW_TEST
AS (SELECT TCODE, TNAME, TCONTENT FROM TT);
--> TT ��� ���̺��� �������� �ʾƼ� �� ���� �� ���� �߻�
-- TABLE OR VIEW DOES NOT EXIST
CREATE OR REPLACE FORCE VIEW VW_TEST
AS (SELECT TCODE, TNAME, TCONTENT FROM TT);

-- ������ �ǰ�, �䵵 ������ �ǳ�
-- ��� : ������ ������ �Բ� �䰡 �����Ǿ����ϴ�. ��� ��

SELECT * FROM VW_TEST;
--> ���� �߻�
-- ��, ���� �ǿ����� Ȯ�� ���� ��!!

-- �ַ� ���Ŀ� �ش� ���̺��� ����� �� �� ���� ��쿡 ����

CREATE TABLE TT (
    TCODE NUMBER,
    TNAME VARCHAR2(30),
    TCONTENT VARCHAR2(50)
    
);


SELECT * FROM VW_TEST;
--> TT ���̺��� ���� �� �ٽ� �ѹ� VW_TEST �� ��ȸ�ϸ�
-- ������ �߻����� ����!!


-- 3) WITH CHECT OPTION
CREATE OR REPLACE VIEW VW_EMP
AS (SELECT * FROM EMPLOYEE WHERE SALARY >= 3000000)
WITH CHECK OPTION;

SELECT * FROM VW_EMP;

-- VW_EMP ���̺� UPDATE �� ����
UPDATE VW_EMP
    SET SALARY = 10000
    WHERE EMP_ID = 200;
--> ���������� ����� ���ǿ� �������� �ʱ� ������ UPDATE �Ұ�

UPDATE VW_EMP
 SET SALARY = 10000000
 WHERE EMP_ID = 200;
--> ���������� ����� ���ǿ� �����ϱ� ������ UPDATE ����

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
--> DML ���� ��ü�� �Ұ�����
-- SQL ����: ORA-42399: cannot perform a DML operation on a read-only view


















