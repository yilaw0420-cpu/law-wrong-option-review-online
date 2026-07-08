create extension if not exists pgcrypto;

create table if not exists public.wrong_questions (
  id uuid primary key default gen_random_uuid(),
  group_id text not null default 'couple-law-review',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  subject text not null default '',
  source text not null default '',
  question text not null default '',
  options jsonb not null default '{}'::jsonb,
  wrong_letters jsonb not null default '[]'::jsonb,
  note text not null default '',
  raw text not null default '',
  mastered boolean not null default false,
  reviewed integer not null default 0 check (reviewed >= 0),
  image_url text not null default '',
  image_data text not null default '',
  image_name text not null default ''
);

alter table public.wrong_questions
  add column if not exists group_id text not null default 'couple-law-review',
  add column if not exists created_at timestamptz not null default now(),
  add column if not exists updated_at timestamptz not null default now(),
  add column if not exists subject text not null default '',
  add column if not exists source text not null default '',
  add column if not exists question text not null default '',
  add column if not exists options jsonb not null default '{}'::jsonb,
  add column if not exists wrong_letters jsonb not null default '[]'::jsonb,
  add column if not exists note text not null default '',
  add column if not exists raw text not null default '',
  add column if not exists mastered boolean not null default false,
  add column if not exists reviewed integer not null default 0,
  add column if not exists image_url text not null default '',
  add column if not exists image_data text not null default '',
  add column if not exists image_name text not null default '';

create index if not exists wrong_questions_group_created_idx
  on public.wrong_questions (group_id, created_at desc);

create or replace function public.set_wrong_questions_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_wrong_questions_updated_at on public.wrong_questions;
create trigger set_wrong_questions_updated_at
before update on public.wrong_questions
for each row
execute function public.set_wrong_questions_updated_at();

alter table public.wrong_questions enable row level security;

grant usage on schema public to anon;
revoke all on table public.wrong_questions from anon;
grant select, insert, update, delete on table public.wrong_questions to anon;

drop policy if exists "couple can read wrong questions" on public.wrong_questions;
drop policy if exists "couple can insert wrong questions" on public.wrong_questions;
drop policy if exists "couple can update wrong questions" on public.wrong_questions;
drop policy if exists "couple can delete wrong questions" on public.wrong_questions;

create policy "couple can read wrong questions"
on public.wrong_questions
for select
to anon
using (group_id = 'couple-law-review');

create policy "couple can insert wrong questions"
on public.wrong_questions
for insert
to anon
with check (group_id = 'couple-law-review');

create policy "couple can update wrong questions"
on public.wrong_questions
for update
to anon
using (group_id = 'couple-law-review')
with check (group_id = 'couple-law-review');

create policy "couple can delete wrong questions"
on public.wrong_questions
for delete
to anon
using (group_id = 'couple-law-review');
