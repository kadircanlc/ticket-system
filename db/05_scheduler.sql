-- ============================================================
-- TICKET SYSTEM - Scheduler Job
-- Requires: GRANT CREATE JOB TO ticket_user (run as SYS)
-- ============================================================

-- EXPIRE_RESERVATIONS_JOB
-- Runs every minute to expire timed-out reservations
BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'EXPIRE_RESERVATIONS_JOB',
    job_type        => 'STORED_PROCEDURE',
    job_action      => 'EXPIRE_RESERVATIONS',
    start_date      => SYSDATE,
    repeat_interval => 'FREQ=MINUTELY;INTERVAL=1',
    enabled         => TRUE
  );
END;
/
