-- =============================================================
-- ICN Hackathon — Solo Hacker Registration Schema for Cloudflare D1
-- Run this in your Cloudflare D1 dashboard under "Console"
-- =============================================================

-- ─────────────────────────────────────────────────────────────
-- OPTION A: Full CREATE TABLE (use this for a fresh setup)
-- Creates the solo_hackers table with all fields including the
-- new optional "Advanced Information" section columns.
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS solo_hackers (
  id                INTEGER PRIMARY KEY AUTOINCREMENT,

  -- Basic Registration Info
  first_name        TEXT    NOT NULL,
  last_name         TEXT    NOT NULL,
  email             TEXT    NOT NULL,
  phone             TEXT,

  -- Guardian Info
  guardian_name     TEXT,
  guardian_phone    TEXT,
  guardian_email    TEXT,

  -- Participant Details
  grade_level       TEXT,
  coding_level      INTEGER DEFAULT 5,

  -- ── ADVANCED INFORMATION (Optional) ──────────────────────
  -- These fields are optional and help organizers recognize
  -- standout participants and award bonus prizes.
  github_url        TEXT,
  portfolio_url     TEXT,
  skills            TEXT,
  past_projects     TEXT,
  experience        TEXT,
  achievements      TEXT,
  bio               TEXT,

  -- Metadata
  status            TEXT    DEFAULT 'pending',  -- pending | approved | rejected
  created_at        TEXT    DEFAULT (datetime('now'))
);


-- ─────────────────────────────────────────────────────────────
-- OPTION B: ALTER TABLE (use this if the table already exists)
-- Adds the new Advanced Information columns to an existing
-- solo_hackers table.
-- ─────────────────────────────────────────────────────────────
ALTER TABLE solo_hackers ADD COLUMN github_url    TEXT;
ALTER TABLE solo_hackers ADD COLUMN portfolio_url TEXT;
ALTER TABLE solo_hackers ADD COLUMN skills        TEXT;
ALTER TABLE solo_hackers ADD COLUMN past_projects TEXT;
ALTER TABLE solo_hackers ADD COLUMN experience    TEXT;
ALTER TABLE solo_hackers ADD COLUMN achievements  TEXT;
ALTER TABLE solo_hackers ADD COLUMN bio           TEXT;
