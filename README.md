# Ticket System

Oracle PL/SQL ve C# Web API ile geliştirilmekte olan konser/etkinlik bilet satış sistemi.

## Proje Hakkında

Kullanıcıların etkinlik görüntüleyip koltuk seçebildiği, 10 dakikalık rezervasyon süresi içinde ödeme yapabildiği bir bilet sistemidir. Projenin amacı Oracle PL/SQL ile kurumsal düzeyde veritabanı katmanı tasarımı ve C# Web API entegrasyonu öğrenmektir.

Bankacılık, sigortacılık ve telekomünikasyon sektörlerinde yoğun kullanılan Oracle PL/SQL teknolojisi üzerine odaklanılmıştır.

## Kullanılan Teknolojiler

- Oracle XE 21c (Docker üzerinde)
- PL/SQL — stored procedure, function, trigger, scheduler
- C# Web API (.NET) — devam ediyor

## Kurulum

```bash
docker compose up -d
```

Bağlantı bilgileri için `docker-compose.yml` dosyasına bakın.

## Veritabanı Yapısı

Sistem 8 tablodan oluşmaktadır: `roles`, `venues`, `events`, `users`, `seats`, `reservations`, `tickets`, `audit_log`

Tüm tablolar `db/01_schema.sql` dosyasında tanımlanmıştır.

## İş Mantığı

Tüm iş mantığı veritabanı katmanında PL/SQL ile yazılmıştır. C# katmanı yalnızca bu procedure'leri çağırır.

- `reserve_seat` — Koltuğu kilitler, rezervasyon oluşturur
- `confirm_ticket` — Rezervasyonu doğrular, bilet keser
- `cancel_reservation` — Rezervasyonu iptal eder, koltuğu serbest bırakır
- `expire_reservations` — Süresi dolan rezervasyonları otomatik iptal eder
- `get_available_seats` — Etkinlikteki boş koltuk sayısını döndürür
- `audit_seats_trigger` — Koltuk değişikliklerini otomatik loglar
- `EXPIRE_RESERVATIONS_JOB` — Her dakika çalışarak süresi dolan rezervasyonları temizler

## Öne Çıkan Konular

- `SELECT FOR UPDATE NOWAIT` ile eş zamanlı koltuk seçimi yönetimi
- COMMIT/ROLLBACK ile transaction güvenliği
- Trigger ile otomatik audit log
- DBMS_SCHEDULER ile zamanlanmış görev
