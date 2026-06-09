# Ticket System - Learning Notes

## Goal
Build a concert/event ticket booking system using Oracle PL/SQL + C# Web API.
Purpose: Learn enterprise backend development, build a strong GitHub portfolio.

## Tech Stack
- Oracle XE 21c (Docker container)
- PL/SQL (stored procedures, triggers, functions, packages)
- C# Web API (.NET)
- Docker + docker-compose

## Setup
- docker-compose.yml: port 1522 (local Oracle uses 1521)
- Container name: ticket_db
- DB user: ticket_user / Ticket1234
- Service name: XEPDB1
- SQL Developer connection: localhost:1522, service name XEPDB1

## Module Plan
- [x] Module 1: Docker + Oracle setup + SQL Developer connection
- [x] Module 2: Schema design — tables, sequences, constraints
- [x] Module 3: PL/SQL basics — procedure, function, exception handling
- [x] Module 4: Triggers — timeout, audit log, capacity check
- [ ] Module 5: Package — grouping business logic
- [ ] Module 6: SELECT FOR UPDATE — concurrency, seat locking
- [ ] Module 7: Cursor + Bulk Collect — batch processing
- [ ] Module 8: C# connection — OracleConnection, repository pattern
- [ ] Module 9: C# transaction management — commit/rollback
- [ ] Module 10: REF CURSOR — reading Oracle lists in C#
- [ ] Module 11: API endpoints — putting it all together
- [ ] Module 12: Testing + error scenarios

## Progress Log

### Session 3
- Wrote procedures: reserve_seat, confirm_ticket, cancel_reservation
- Wrote function: get_available_seats
- Wrote trigger: audit_seats_trigger (auto logs seats changes)
- Wrote procedure: expire_reservations
- Created scheduler job: EXPIRE_RESERVATIONS_JOB (runs every minute)
- Next: Module 5 — Package

### Session 2
- Created all tables: roles, venues, events, users, seats, reservations, tickets, audit_log
- Created all sequences
- Added FK, CHECK, NOT NULL constraints
- Next: Module 3 — PL/SQL basics (procedure, function, exception handling)

### Session 1
- Set up Docker with Oracle XE 21-slim image
- Resolved port conflict (1521 taken by local Oracle, switched to 1522)
- Connected SQL Developer successfully
- Decided on project: event ticket booking system
- Reason for Oracle PL/SQL + C#: high demand in banking, insurance, telecom sectors
