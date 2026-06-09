-- ============================================================
-- TICKET SYSTEM - Triggers
-- ============================================================

-- AUDIT_SEATS_TRIGGER
-- Automatically logs every status change on the seats table
CREATE OR REPLACE TRIGGER audit_seats_trigger
AFTER UPDATE ON seats
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (id, table_name, operation, record_id, old_status, new_status, changed_at)
  VALUES (audit_log_seq.NEXTVAL, 'SEATS', 'UPDATE', :OLD.id, :OLD.status, :NEW.status, SYSDATE);
END audit_seats_trigger;
