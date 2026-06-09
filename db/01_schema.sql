-- ============================================================
-- TICKET SYSTEM - Schema
-- Tables, Sequences, Constraints
-- ============================================================

-- SEQUENCES
CREATE SEQUENCE roles_seq         START WITH 1      INCREMENT BY 1 CACHE 20 NOCYCLE;
CREATE SEQUENCE venues_seq        START WITH 1      INCREMENT BY 1 CACHE 20 NOCYCLE;
CREATE SEQUENCE events_seq        START WITH 100000 INCREMENT BY 1 CACHE 20 NOCYCLE;
CREATE SEQUENCE users_seq         START WITH 100000 INCREMENT BY 1 CACHE 20 NOCYCLE;
CREATE SEQUENCE seats_seq         START WITH 100000 INCREMENT BY 1 CACHE 20 NOCYCLE;
CREATE SEQUENCE reservations_seq  START WITH 100000 INCREMENT BY 1 CACHE 20 NOCYCLE;
CREATE SEQUENCE tickets_seq       START WITH 100000 INCREMENT BY 1 CACHE 20 NOCYCLE;
CREATE SEQUENCE audit_log_seq     START WITH 1      INCREMENT BY 1 CACHE 20 NOCYCLE;

-- ROLES
CREATE TABLE roles (
  id   NUMBER(2)    PRIMARY KEY,
  name VARCHAR2(50) NOT NULL,
  CONSTRAINT chk_role_name
    CHECK (name IN ('admin', 'user', 'sales_rep'))
);

-- VENUES
CREATE TABLE venues (
  id             NUMBER        PRIMARY KEY,
  name           VARCHAR2(200) NOT NULL,
  address        VARCHAR2(500) NOT NULL,
  total_capacity NUMBER        NOT NULL
);

-- EVENTS
CREATE TABLE events (
  id         NUMBER        PRIMARY KEY,
  venue_id   NUMBER        NOT NULL,
  name       VARCHAR2(200) NOT NULL,
  event_date DATE          NOT NULL,
  event_time VARCHAR2(10)  NOT NULL,
  capacity   NUMBER        NOT NULL,
  created_at DATE          DEFAULT SYSDATE,
  CONSTRAINT fk_event_venue
    FOREIGN KEY (venue_id) REFERENCES venues(id)
);

-- USERS
CREATE TABLE users (
  id         NUMBER        PRIMARY KEY,
  role_id    NUMBER(2)     NOT NULL,
  first_name VARCHAR2(100) NOT NULL,
  last_name  VARCHAR2(100) NOT NULL,
  email      VARCHAR2(200) NOT NULL,
  phone      VARCHAR2(20),
  created_at DATE          DEFAULT SYSDATE,
  CONSTRAINT fk_user_role
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- SEATS
CREATE TABLE seats (
  id       NUMBER        PRIMARY KEY,
  event_id NUMBER        NOT NULL,
  row_num  VARCHAR2(5)   NOT NULL,
  seat_num NUMBER        NOT NULL,
  status   VARCHAR2(20)  DEFAULT 'available',
  CONSTRAINT fk_seat_event
    FOREIGN KEY (event_id) REFERENCES events(id),
  CONSTRAINT chk_seat_status
    CHECK (status IN ('available', 'reserved', 'sold'))
);

-- RESERVATIONS
CREATE TABLE reservations (
  id         NUMBER        PRIMARY KEY,
  user_id    NUMBER        NOT NULL,
  seat_id    NUMBER        NOT NULL,
  expires_at DATE          DEFAULT SYSDATE + 10/1440,
  status     VARCHAR2(20)  DEFAULT 'active',
  CONSTRAINT fk_res_user
    FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_res_seat
    FOREIGN KEY (seat_id) REFERENCES seats(id),
  CONSTRAINT chk_res_status
    CHECK (status IN ('active', 'expired', 'completed'))
);

-- TICKETS
CREATE TABLE tickets (
  id             NUMBER        PRIMARY KEY,
  reservation_id NUMBER        NOT NULL,
  user_id        NUMBER        NOT NULL,
  seat_id        NUMBER        NOT NULL,
  event_id       NUMBER        NOT NULL,
  price          NUMBER(10,2)  NOT NULL,
  purchased_at   DATE          DEFAULT SYSDATE,
  CONSTRAINT fk_ticket_reservation FOREIGN KEY (reservation_id) REFERENCES reservations(id),
  CONSTRAINT fk_ticket_user        FOREIGN KEY (user_id)        REFERENCES users(id),
  CONSTRAINT fk_ticket_seat        FOREIGN KEY (seat_id)        REFERENCES seats(id),
  CONSTRAINT fk_ticket_event       FOREIGN KEY (event_id)       REFERENCES events(id)
);

-- AUDIT_LOG
CREATE TABLE audit_log (
  id         NUMBER        PRIMARY KEY,
  table_name VARCHAR2(50)  NOT NULL,
  operation  VARCHAR2(10)  NOT NULL,
  record_id  NUMBER        NOT NULL,
  old_status VARCHAR2(20),
  new_status VARCHAR2(20),
  changed_at DATE          DEFAULT SYSDATE,
  changed_by NUMBER,
  CONSTRAINT chk_audit_operation
    CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'))
);
