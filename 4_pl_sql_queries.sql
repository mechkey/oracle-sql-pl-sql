REM - q1)	Display names of students, details of the track they study, details of the subjects they have studied and their marks for all high (not junior-high) students.
SET ECHO ON
SET VERIFY ON
SET SERVEROUTPUT ON FORMAT WRAPPED

CREATE OR REPLACE PROCEDURE HIGH_STU
AS
	CURSOR HSTUCURSOR IS 
		SELECT S.PID, S.TITLE, FNAME, MNAME, LNAME, C.TRACK_ID, 
			C.C_TITLE, DEREF(MM.SUBJECT_ID).SUBJECT_ID AS MOD_ID, M.M_TITLE, MM.GRADE, MM.ID, C.C_Level, M.M_LEVEL
		FROM STUDENT S
		JOIN TUTORING T 
			ON REF (S) = T.STUDENT_ID
		JOIN TRACK_STUDENT CS 
			ON S.PID = DEREF(CS.STUDENT_ID).PID
		JOIN TRACK C 
			ON C.TRACK_ID = DEREF(CS.TRACK_ID).TRACK_ID
		JOIN BRANCH D 
			ON C.UNDER_BRANCH_ID = REF (D)
		JOIN MOD_MARK MM 
			ON MM.STUDENT_ID = REF (S) 
		JOIN SUBJECT M 
			ON MM.SUBJECT_ID = REF (M)
		WHERE C.C_LEVEL = 'H'
		AND M.M_LEVEL = 'H'
		;
	P1		HSTUCURSOR%ROWTYPE;
BEGIN

	OPEN HSTUCURSOR;
    	DBMS_OUTPUT.PUT_LINE( '                   |   FIRST   |  MIDDLE  |    LAST     | TRACK  | TRACK |                                                  | SUBJECT |');
        DBMS_OUTPUT.PUT_LINE( '|     ID   | TITLE |    NAME   |   NAME   |    NAME     |   ID   | LEVEL |     T_TITLE      | SUBJ_ID|    SUBJ_TITLE  |GRADE| LEVEL  |');
        DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------------------------------------------------------------------------------------------');
	LOOP
		FETCH HSTUCURSOR INTO P1;
      
		DBMS_OUTPUT.PUT_LINE('| '||P1.PID||'|  '|| RPAD(P1.TITLE,5,' ') ||'| '|| RPAD(P1.FNAME,10,' ') ||'| '|| RPAD(P1.MNAME,9,' ') ||'| '|| RPAD(P1.LNAME,12,' ') ||'| '
            ||  RPAD(P1.TRACK_ID,6,' ')||' | '|| LPAD(P1.C_Level,3,' ')||'   | '|| RPAD(P1.C_TITLE,17,' ') ||'| '|| RPAD(P1.MOD_ID,7,' ') ||'| '|| RPAD(P1.M_TITLE,15,' ') 
            ||'|  '|| RPAD(P1.GRADE,3,' ')  ||'| '|| LPAD(P1.M_LEVEL,3,' ')||'    |');
		EXIT WHEN HSTUCURSOR%NOTFOUND;
	END LOOP;
        DBMS_OUTPUT.PUT_LINE( '--------------------------------------------------------------------------------------------------------------------------------------');

	CLOSE HSTUCURSOR;
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE( 'ERROR! REASON UNKNOWN');

END;
/

SHO ERR

SQL> EXEC HIGH_STU;
                   |   FIRST   |  MIDDLE  |    LAST     | TRACK  | TRACK |                                                  | SUBJECT |      
|     ID   | TITLE |    NAME   |   NAME   |    NAME     |   ID   | LEVEL |     T_TITLE      | SUBJ_ID|    SUBJ_TITLE  |GRADE| LEVEL  |      
--------------------------------------------------------------------------------------------------------------------------------------      
| S0000001 |  MISS | JENNIE    | DELIS    | KIM         | CIS001 |   H   | COMPUTER SCIENCE | SAD5   | SYSTEM ANALYSIS|  55 |   H    |      
| S0000001 |  MISS | JENNIE    | DELIS    | KIM         | CIS001 |   H   | COMPUTER SCIENCE | DBM5   | DATABASE MAN 5 |  74 |   H    |      
| S0000002 |  MISS | HYEJEONG  | BAE      | SHIN        | CIS001 |   H   | COMPUTER SCIENCE | SAD5   | SYSTEM ANALYSIS|  75 |   H    |      
| S0000002 |  MISS | HYEJEONG  | BAE      | SHIN        | CIS001 |   H   | COMPUTER SCIENCE | DBM5   | DATABASE MAN 5 |  77 |   H    |      
| S0000003 |  MISS | SEOLHYUN  | CRAE     | KIM         | CIS001 |   H   | COMPUTER SCIENCE | SAD5   | SYSTEM ANALYSIS|  78 |   H    |      
| S0000003 |  MISS | SEOLHYUN  | CRAE     | KIM         | CIS001 |   H   | COMPUTER SCIENCE | DBM5   | DATABASE MAN 5 |  79 |   H    |      
| S0000006 |  MISS | ARIANNA   | THE      | BANANA      | GEO001 |   H   | HOW TO ID ROCKS  | ROCK5  | ROCKSMASHING 5 |  76 |   H    |      
| S0000008 |  DR   | DANIEL    | BENJAMIN | FINLAY      | CIS001 |   H   | COMPUTER SCIENCE | SAD5   | SYSTEM ANALYSIS|  41 |   H    |      
| S0000008 |  DR   | DANIEL    | BENJAMIN | FINLAY      | CIS001 |   H   | COMPUTER SCIENCE | DBM5   | DATABASE MAN 5 |  37 |   H    |      
| S0000009 |  MR   | LUKE      | ISA      | LEON        | CIS001 |   H   | COMPUTER SCIENCE | SAD5   | SYSTEM ANALYSIS|  63 |   H    |      
| S0000009 |  MR   | LUKE      | ISA      | LEON        | CIS001 |   H   | COMPUTER SCIENCE | SAD5   | SYSTEM ANALYSIS|  63 |   H    |      
--------------------------------------------------------------------------------------------------------------------------------------      

PL/SQL procedure successfully completed.

SQL> SPOOL OFF


REM
REM - q2)	Display details of all people (students and teaching staff), e.g., their names, their home addresses and name of the branch where they work or study.

SET ECHO ON
SET VERIFY ON
SET SERVEROUTPUT ON FORMAT WRAPPED
SET LINESIZE 200
 
COLUMN BRANCH_NAME HEADING 'BRANCH|NAME'
COLUMN BRANCH_NAME FORMAT A20 WORD_WRAPPED 
COLUMN CITY FORMAT A10 WORD_WRAPPED 
COLUMN REGION FORMAT A10 WORD_WRAPPED 
COLUMN COUNTRY FORMAT A10 WORD_WRAPPED 
COLUMN STREET FORMAT A10 WORD_WRAPPED 
COLUMN FNAME FORMAT A10 WORD_WRAPPED
COLUMN MNAME FORMAT A10 WORD_WRAPPED 
COLUMN LNAME FORMAT A10 WORD_WRAPPED 
 

CREATE OR REPLACE PROCEDURE DISPLAY_ALL
AS
	CURSOR PCURSOR IS	
		SELECT S.PID, S.TITLE, S.FNAME, S.MNAME, S.LNAME, 
			D.D_NAME, OA.NUM, OA.STREET    , 
			OA.CITY    , OA.REGION    , OA.POSTCODE    , OA.COUNTRY
		FROM STUDENT S
		JOIN TUTORING T 
			ON REF (S) = T.STUDENT_ID
		JOIN TRACK_STUDENT CS 
			ON S.PID = DEREF(CS.STUDENT_ID).PID
		JOIN TRACK C 
			ON C.TRACK_ID = DEREF(CS.TRACK_ID).TRACK_ID
		JOIN BRANCH D 
			ON C.UNDER_BRANCH_ID = REF (D) 
		JOIN OFF_CAMP OA
			ON DEREF(S.HOME_ADDR).OFF_CAMP_AD_ID = OA.OFF_CAMP_AD_ID
		UNION
		SELECT S.PID AS ID, S.TITLE AS TITLE, S.FNAME AS FNAME, S.MNAME AS MNAME, S.LNAME AS LNAME, 								D.D_NAME AS BRANCH_NAME, OA.NUM AS HOME_NUM, OA.STREET    , 
			OA.CITY    , OA.REGION    , OA.POSTCODE    , OA.COUNTRY
		FROM STAFF S
		JOIN BRANCH D
			ON DEREF(S.WORKS_FOR_BRANCH_ID).BRANCH_ID = D.BRANCH_ID
		JOIN OFF_CAMP OA
			ON DEREF(S.HOME_ADDR).OFF_CAMP_AD_ID = OA.OFF_CAMP_AD_ID
		ORDER BY FNAME
		;
	
	P1		PCURSOR%ROWTYPE;
BEGIN
	OPEN PCURSOR;
	DBMS_OUTPUT.PUT_LINE(       '                   |   FIRST   |  MIDDLE  |    LAST     |                     |PROPERTY|                                             |  POST   |');
	DBMS_OUTPUT.PUT_LINE(       '|    ID    | TITLE |    NAME   |   NAME   |    NAME     |      BRANCH NAME      | NUMBER |     STREET     |   CITY    |     REGION     |  CODE   |  COUNTRY  |');
	DBMS_OUTPUT.PUT_LINE(       '------------------------------------------------------------------------------------------------------------------------------------------------------------');
				
	LOOP
		FETCH PCURSOR INTO P1;
		
		DBMS_OUTPUT.PUT_LINE('| '||P1.PID||'|  '|| RPAD(P1.TITLE,5,' ') ||'| '|| RPAD(P1.FNAME,10,' ') ||'| '|| RPAD(P1.MNAME,9,' ') ||'| '|| RPAD(P1.LNAME,12,' ') ||'| '||  
								RPAD(P1.D_NAME,20,' ') ||'| '|| RPAD(P1.NUM,7,' ') ||'| '||RPAD(P1.STREET,15,' ') ||'| '|| 
								RPAD(P1.CITY,10,' ') ||'| '|| RPAD(P1.REGION,15, ' ') ||'| '|| RPAD(P1.POSTCODE,8,' ')||'| '|| RPAD(P1.COUNTRY,10,' ')||'|');
		EXIT WHEN PCURSOR%NOTFOUND;
	END LOOP;
    DBMS_OUTPUT.PUT_LINE(       '------------------------------------------------------------------------------------------------------------------------------------------------------------');
	EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE( 'ERROR! REASON UNKNOWN');
    CLOSE PCURSOR;
END;
/

SHO ERR

SPOOL U:\DBM2\A4BOUT.TXT

EXEC DISPLAY_ALL_AIS;

SPOOL OFF

SQL> 
SQL> EXEC DISPLAY_ALL;
                   |   FIRST   |  MIDDLE  |    LAST     |                     |PROPERTY|                                             |  POST   |                                                        
|    ID    | TITLE |    NAME   |   NAME   |    NAME     |      DEPT NAME      | NUMBER |     STREET     |   CITY    |     REGION     |  CODE   |  COUNTRY  |                                            
------------------------------------------------------------------------------------------------------------------------------------------------------------                                            
| S0000006 |  MISS | ARIANNA   | THE      | BANANA      | GEOGRAPHY           | 11     | ACACIA STREET  | NEWCASTLE | TYNE AND WEAR  | NE31AB  | UK        |                                            
| F0000004 |  DR   | BOATY     | B        | MCBOATFACE  | COMPUTER AND INFORMA| 254    | ACORN STREET   | NEWCASTLE | TYNE AND WEAR  | NE31AU  | UK        |                                            
| F0000003 |  DR   | BOB       | B        | MCBURPY     | COMPUTER AND INFORMA| 254    | ACORN STREET   | NEWCASTLE | TYNE AND WEAR  | NE31AU  | UK        |                                            
| S0000007 |  MX   | CHARLI    | EES      | ANGELS      | GEOGRAPHY           | 55     | ACACIA ROAD    | NEWCASTLE | TYNE AND WEAR  | NE31AK  | UK        |                                            
| S0000008 |  DR   | DANIEL    | BENJAMIN | FINLAY      | COMPUTER AND INFORMA| 239    | ACORN STREET   | NEWCASTLE | TYNE AND WEAR  | NE31AW  | UK        |                                            
| S0000004 |  DR   | HARRY     | ARCEE    | BEN         | COMPUTER AND INFORMA| 11     | ACACIA STREET  | NEWCASTLE | TYNE AND WEAR  | NE31AB  | UK        |                                            
| S0000002 |  MISS | HYEJEONG  | BAE      | SHIN        | COMPUTER AND INFORMA| 55     | ACACIA ROAD    | NEWCASTLE | TYNE AND WEAR  | NE31AK  | UK        |                                            
| S0000001 |  MISS | JENNIE    | DELIS    | KIM         | COMPUTER AND INFORMA| 11     | ACACIA STREET  | NEWCASTLE | TYNE AND WEAR  | NE31AB  | UK        |                                            
| F0000001 |  MR   | JOE       | K        | MCSWEENY    | COMPUTER AND INFORMA| 4546   | PEACH STREET   | BOULDER   | COLORADO       | BO11AF  | USA       |                                            
| S0000005 |  MR   | JOSHUA    | BEEN     | THEO        | GEOGRAPHY           | 4546   | PEACH STREET   | BOULDER   | COLORADO       | BO11AF  | USA       |                                            
| S0000009 |  MR   | LUKE      | ISA      | LEON        | COMPUTER AND INFORMA| 254    | ACORN STREET   | NEWCASTLE | TYNE AND WEAR  | NE31AU  | UK        |                                            
| F0000002 |  MRS  | ROCK      | S        | COOKING     | GEOGRAPHY           | 4546   | PEACH STREET   | BOULDER   | COLORADO       | BO11AF  | USA       |                                            
| S0000003 |  MISS | SEOLHYUN  | CRAE     | KIM         | COMPUTER AND INFORMA| 239    | ACORN STREET   | NEWCASTLE | TYNE AND WEAR  | NE31AW  | UK        |                                            
| S0000003 |  MISS | SEOLHYUN  | CRAE     | KIM         | COMPUTER AND INFORMA| 239    | ACORN STREET   | NEWCASTLE | TYNE AND WEAR  | NE31AW  | UK        |                                            
------------------------------------------------------------------------------------------------------------------------------------------------------------                                            

PL/SQL procedure successfully completed.

SQL> 
SQL> SPOOL OFF
