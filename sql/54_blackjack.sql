-- Blackjack clásico: configuración por juego y estado privado de una partida.
alter table juegos add column if not exists blackjack_cfg jsonb not null default '{}'::jsonb;

create table if not exists blackjack_partidas (
  id uuid primary key,
  juego_id uuid not null references juegos(id) on delete cascade,
  jugador_id text not null,
  apuesta numeric(14,2) not null check (apuesta > 0),
  apuesta_total numeric(14,2) not null check (apuesta_total > 0),
  mazo jsonb not null,
  mano_jugador jsonb not null,
  mano_dealer jsonb not null,
  estado text not null default 'en_curso' check (estado in ('en_curso','gano','perdio','empate')),
  ganancia_final numeric(14,2),
  version integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists blackjack_una_partida_activa
  on blackjack_partidas (juego_id, jugador_id) where estado = 'en_curso';
create index if not exists blackjack_partidas_jugador on blackjack_partidas (jugador_id, created_at desc);
