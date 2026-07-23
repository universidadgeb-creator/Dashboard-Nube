-- ============================================================
--  Configuración de Supabase para el Dashboard Acton Academy
--  Ejecuta TODO este script en: Supabase → SQL Editor → New query → Run
-- ============================================================

-- 1) Tabla que guarda TODO el estado del tablero como un JSON (una sola fila, id=1)
create table if not exists public.dashboard_state (
  id         int primary key,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

-- 2) Activar seguridad por filas (Row Level Security)
alter table public.dashboard_state enable row level security;

-- 3) Reglas de acceso
--    - Cualquiera puede LEER el tablero (lectura pública)
--    - Solo usuarios con sesión iniciada pueden GUARDAR (insertar/actualizar)

drop policy if exists "lectura publica"        on public.dashboard_state;
drop policy if exists "escritura autenticada u" on public.dashboard_state;
drop policy if exists "escritura autenticada i" on public.dashboard_state;

create policy "lectura publica"
  on public.dashboard_state
  for select
  to anon, authenticated
  using (true);

create policy "escritura autenticada i"
  on public.dashboard_state
  for insert
  to authenticated
  with check (true);

create policy "escritura autenticada u"
  on public.dashboard_state
  for update
  to authenticated
  using (true)
  with check (true);

-- ============================================================
--  DESPUÉS de correr esto:
--
--  a) Crea tu usuario editor:
--     Authentication → Users → Add user → escribe correo y contraseña.
--     (Marca el correo como confirmado / "Auto Confirm User".)
--
--  b) Desactiva los registros públicos para que nadie más pueda crear cuenta:
--     Authentication → Providers → Email → apaga "Enable Sign Ups".
--
--  c) Copia en index.html (bloque SUPABASE / NUBE):
--     - Project URL  →  const SUPABASE_URL   = 'https://....supabase.co';
--     - anon public  →  const SUPABASE_ANON_KEY = 'eyJ....';
--     (Los encuentras en: Project Settings → API)
-- ============================================================
