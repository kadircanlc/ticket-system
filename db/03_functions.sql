-- ============================================================
-- TICKET SYSTEM - Functions
-- ============================================================

-- GET_AVAILABLE_SEATS
-- Returns the number of available seats for a given event
CREATE OR REPLACE FUNCTION get_available_seats(p_event_id IN NUMBER) RETURN NUMBER AS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM seats
  WHERE event_id = p_event_id AND status = 'available';
  RETURN v_count;
EXCEPTION
  WHEN OTHERS THEN RETURN -1;
END get_available_seats;
/
