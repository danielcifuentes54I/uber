/**************************** PUNTO 2 ****************************/
--Create 3 Tablespaces:
--a. first one with 2 Gb and 1 datafile, tablespace should be named " uber "
CREATE TABLESPACE uber 
DATAFILE 'datafile_uber' SIZE 2G;

--b. Undo tablespace with 25Mb of space and 1 datafile
CREATE UNDO TABLESPACE  undo_uber 
DATAFILE 'datafile_undo_uber' SIZE 25M;

--c. Bigfile tablespace of 5Gb
CREATE BIGFILE TABLESPACE  bigfile_uber 
DATAFILE 'datafile_bigfile_uber' SIZE 5G;

--d. Set the undo tablespace to be used in the system
ALTER SYSTEM SET UNDO_TABLESPACE = undo_uber;


/**************************** PUNTO 3 ****************************/
--Create a DBA user (with the role DBA) and assign it to the tablespace called " uber ", this user has
--unlimited space on the tablespace (The user should have permission to connect) (0.1)

CREATE USER dba_uber
IDENTIFIED BY dba_uber
DEFAULT TABLESPACE uber
QUOTA UNLIMITED ON uber;

--DBA ROLE CONTAIN THE PERMISSION TO CONNECT
GRANT dba to dba_uber;


/**************************** PUNTO 4 ****************************/
--Create 2 profiles
--a. Profile 1: "clerk" password life 40 days, one session per user, 10 minutes idle, 4 failed login attempts
CREATE PROFILE clerk LIMIT
PASSWORD_LIFE_TIME 40
SESSIONS_PER_USER 1
IDLE_TIME  10
FAILED_LOGIN_ATTEMPTS 4;

--b. Profile 3: "development " password life 100 days, two session per user, 30 minutes idle, no failed login attempts
CREATE PROFILE development LIMIT
PASSWORD_LIFE_TIME 100
SESSIONS_PER_USER 2
IDLE_TIME  30
FAILED_LOGIN_ATTEMPTS UNLIMITED;


/**************************** PUNTO 5 ****************************/
--Create 4 users, assign them the tablespace " uber ":
--a. 2 of them should have the clerk profile and the remaining the development profile, all the users 
--should be allow to connect to the database.

CREATE USER usuario_uber1
IDENTIFIED BY usuario_uber1
DEFAULT TABLESPACE uber
PROFILE clerk;

GRANT CONNECT TO usuario_uber1;

CREATE USER usuario_uber2
IDENTIFIED BY usuario_uber2
DEFAULT TABLESPACE uber
PROFILE clerk;

GRANT CONNECT TO usuario_uber2;

CREATE USER usuario_uber3
IDENTIFIED BY usuario_uber3
DEFAULT TABLESPACE uber
PROFILE development;

GRANT CONNECT TO usuario_uber3;

CREATE USER usuario_uber4
IDENTIFIED BY usuario_uber4
DEFAULT TABLESPACE uber
PROFILE development;

GRANT CONNECT TO usuario_uber4;

--b. Lock one user associate with clerk profile (0.1)
ALTER USER usuario_uber2 ACCOUNT LOCK;

