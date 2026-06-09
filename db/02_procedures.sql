-- ============================================================
-- TICKET SYSTEM - Stored Procedures
-- ============================================================

-- 1. RESERVE_SEAT
-- Locks the seat and creates a reservation (10 min expiry)
CREATE OR REPLACE PROCEDURE reserve_seat (
  p_seat_id  IN  NUMBER,
  p_user_id  IN  NUMBER,
  p_res_id   OUT NUMBER
)
IS
  v_status VARCHAR2(20);
BEGIN
  SELECT status INTO v_status
  FROM seats
  WHERE id = p_seat_id
  FOR UPDATE NOWAIT;

  IF v_status != 'available' THEN
    RAISE_APPLICATION_ERROR(-20001, 'Seat is not available');
  END IF;

  UPDATE seats SET status = 'reserved' WHERE id = p_seat_id;

  INSERT INTO reservations (id, user_id, seat_id, expires_at, status)
  VALUES (reservations_seq.NEXTVAL, p_user_id, p_seat_id, SYSDATE + 10/1440, 'active')
  RETURNING id INTO p_res_id;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END reserve_seat;
/

-- 2. CONFIRM_TICKET
-- Validates reservation and issues a ticket
CREATE OR REPLACE PROCEDURE confirm_ticket (
  p_res_id    IN  NUMBER,
  p_price     IN  NUMBER,
  p_ticket_id OUT NUMBER
)
IS
  v_status   VARCHAR2(20);
  v_expires  DATE;
  v_seat_id  NUMBER;
  v_user_id  NUMBER;
  v_event_id NUMBER;
BEGIN
  SELECT status, expires_at, seat_id, user_id
  INTO v_status, v_expires, v_seat_id, v_user_id
  FROM reservations
  WHERE id = p_res_id;

  IF v_status != 'active' THEN
    RAISE_APPLICATION_ERROR(-20002, 'Reservation is not active');
  END IF;

  IF v_expires < SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20003, 'Reservation has expired');
  END IF;

  SELECT event_id INTO v_event_id FROM seats WHERE id = v_seat_id;

  UPDATE reservations SET status = 'completed' WHERE id = p_res_id;
  UPDATE seats SET status = 'sold' WHERE id = v_seat_id;

  INSERT INTO tickets (id, reservation_id, user_id, seat_id, event_id, price)
  VALUES (tickets_seq.NEXTVAL, p_res_id, v_user_id, v_seat_id, v_event_id, p_price)
  RETURNING id INTO p_ticket_id;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END confirm_ticket;
/

-- 3. CANCEL_RESERVATION
-- Cancels an active reservation and frees the seat
CREATE OR REPLACE PROCEDURE cancel_reservation (
  p_res_id IN NUMBER
)
IS
  v_status  VARCHAR2(20);
  v_seat_id NUMBER;
BEGIN
  SELECT status, seat_id INTO v_status, v_seat_id
  FROM reservations WHERE id = p_res_id;

  IF v_status != 'active' THEN
    RAISE_APPLICATION_ERROR(-20004, 'Reservation is not active');
  END IF;

  UPDATE reservations SET status = 'expired' WHERE id = p_res_id;
  UPDATE seats SET status = 'available' WHERE id = v_seat_id;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END cancel_reservation;
/

-- 4. EXPIRE_RESERVATIONS
-- Called by scheduler every minute to expire timed-out reservations
CREATE OR REPLACE PROCEDURE expire_reservations
IS
BEGIN
  UPDATE reservations
  SET status = 'expired'
  WHERE status = 'active'
  AND expires_at < SYSDATE;

  UPDATE seats
  SET status = 'available'
  WHERE id IN (
    SELECT seat_id FROM reservations
    WHERE status = 'expired'
    AND expires_at < SYSDATE
  );

  COMMIT;
END expire_reservations;
/
