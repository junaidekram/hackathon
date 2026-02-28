-- =============================================================
-- ICN Hackathon — Sponsor Application Schema for Cloudflare D1
-- Run this in your Cloudflare D1 dashboard under "Console"
-- =============================================================

-- ─────────────────────────────────────────────────────────────
-- TABLE: sponsor_applications
-- Stores every sponsor form submission (Sections A–L)
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sponsor_applications (
  id                      INTEGER PRIMARY KEY AUTOINCREMENT,

  -- SECTION A — Sponsor Information
  company_name            TEXT    NOT NULL,
  primary_contact_name    TEXT    NOT NULL,
  job_title               TEXT,
  email                   TEXT    NOT NULL,
  phone                   TEXT,
  company_website         TEXT,
  headquarters_location   TEXT,

  -- SECTION B — Sponsorship Level
  -- values: 'title' | 'gold' | 'silver' | 'bronze' | 'community'
  sponsorship_level       TEXT    NOT NULL,

  -- SECTION C — Sponsorship Goals
  -- Stored as a JSON array of goal key strings, e.g.:
  -- ["recruit_interns","build_talent_pipeline","support_stem"]
  -- Also supports repeatable custom goals stored as JSON array of strings
  sponsorship_goals       TEXT    DEFAULT '[]',
  goals_custom            TEXT    DEFAULT '[]',

  -- SECTION D — Event Participation Options
  -- JSON array, e.g.: ["host_workshop","provide_mentors","judge_projects"]
  event_participation     TEXT    DEFAULT '[]',

  -- SECTION E — Challenge Prize Sponsorship
  prize_category_name     TEXT,
  prize_description       TEXT,
  prize_value             TEXT,
  prize_judging_requirements TEXT,

  -- SECTION F — Recruiting Participation
  resume_book_access      INTEGER DEFAULT 0,   -- 0 = No, 1 = Yes
  recruiting_interested   INTEGER DEFAULT 0,
  booth_requested         INTEGER DEFAULT 0,

  -- SECTION G — Branding + Marketing
  company_logo_url        TEXT,
  company_description     TEXT,
  social_media_handles    TEXT,
  allow_public_tag        INTEGER DEFAULT 1,   -- 0 = No, 1 = Yes

  -- SECTION H — Payment Details
  sponsorship_amount      TEXT,
  invoice_required        INTEGER DEFAULT 0,
  billing_contact         TEXT,
  billing_email           TEXT,

  -- SECTION I — Swag + Materials
  -- JSON array, e.g.: ["swag_bags","api_credits","hardware_prizes"]
  swag_options            TEXT    DEFAULT '[]',
  swag_custom             TEXT,
  shipping_address        TEXT,

  -- SECTION J — Representative Attendance
  reps_attending          INTEGER DEFAULT 0,
  rep_names               TEXT,
  rep_emails              TEXT,
  rep_dietary             TEXT,

  -- SECTION K — Legal Agreement
  agree_terms             INTEGER DEFAULT 0,
  allow_logo_usage        INTEGER DEFAULT 0,
  payment_agreement       INTEGER DEFAULT 0,

  -- SECTION L — Additional Notes
  additional_notes        TEXT,

  -- Metadata
  status                  TEXT    DEFAULT 'pending',  -- pending | approved | rejected
  created_at              TEXT    DEFAULT (datetime('now'))
);

-- ─────────────────────────────────────────────────────────────
-- TABLE: sponsor_form_config
-- Each row controls one field/section on the sponsor form.
-- Admin can toggle enabled and update the label text.
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sponsor_form_config (
  field_key   TEXT    PRIMARY KEY,
  label       TEXT    NOT NULL,
  enabled     INTEGER DEFAULT 1,   -- 0 = hidden on public form, 1 = visible
  updated_at  TEXT    DEFAULT (datetime('now'))
);

-- ─────────────────────────────────────────────────────────────
-- DEFAULT CONFIGURATION ROWS
-- One row per section header + one row per notable field.
-- Admin can disable entire sections or individual fields.
-- ─────────────────────────────────────────────────────────────
INSERT OR IGNORE INTO sponsor_form_config (field_key, label, enabled) VALUES
  -- Section A
  ('sec_a',                   'Section A — Sponsor Information',          1),
  ('sec_a_company_name',      'Company Name',                             1),
  ('sec_a_contact_name',      'Primary Contact Name',                     1),
  ('sec_a_job_title',         'Job Title',                                1),
  ('sec_a_email',             'Email Address',                            1),
  ('sec_a_phone',             'Phone Number',                             1),
  ('sec_a_website',           'Company Website',                          1),
  ('sec_a_hq_location',       'Headquarters Location',                    1),

  -- Section B
  ('sec_b',                   'Section B — Sponsorship Selection',        1),
  ('sec_b_title',             '⭐ Title Sponsor — $2,000–$3,500',          1),
  ('sec_b_gold',              '🥇 Gold Sponsor — $1,000–$1,500',           1),
  ('sec_b_silver',            '🥈 Silver Sponsor — $500–$750',             1),
  ('sec_b_bronze',            '🥉 Bronze Sponsor — $200–$400',             1),
  ('sec_b_community',         '❤️ Community Sponsor — $50–$150',           1),

  -- Section C
  ('sec_c',                   'Section C — Sponsorship Goals',            1),
  ('sec_c_talent',            '🧑‍💻 Talent & Recruiting Goals',              1),
  ('sec_c_product',           '🚀 Product & Technology Adoption',          1),
  ('sec_c_brand',             '📣 Brand Awareness & Marketing',            1),
  ('sec_c_community',         '🤝 Community & Education Support',          1),
  ('sec_c_innovation',        '🧠 Innovation & Research',                  1),
  ('sec_c_bizdev',            '💼 Business Development',                   1),
  ('sec_c_event',             '🎤 Event Presence & Engagement',            1),
  ('sec_c_data',              '📊 Data & Insights',                        1),
  ('sec_c_custom',            'Custom Goal (add your own)',                1),

  -- Section D
  ('sec_d',                   'Section D — Event Participation Options',  1),
  ('sec_d_workshop',          'Host a Workshop',                          1),
  ('sec_d_mentors',           'Provide Mentors',                          1),
  ('sec_d_judge',             'Judge Projects',                           1),
  ('sec_d_prize',             'Sponsor a Prize',                          1),
  ('sec_d_keynote',           'Give Keynote Remarks',                     1),

  -- Section E
  ('sec_e',                   'Section E — Challenge Prize Sponsorship',  1),
  ('sec_e_category_name',     'Prize Category Name',                      1),
  ('sec_e_description',       'Prize Description',                        1),
  ('sec_e_value',             'Prize Value ($ or item)',                   1),
  ('sec_e_judging_req',       'Judging Requirements',                     1),

  -- Section F
  ('sec_f',                   'Section F — Recruiting Participation',     1),
  ('sec_f_resume_book',       'Resume Book Access Requested',             1),
  ('sec_f_recruiting',        'Interested in Recruiting',                 1),
  ('sec_f_booth',             'Booth Requested',                          1),

  -- Section G
  ('sec_g',                   'Section G — Branding + Marketing',        1),
  ('sec_g_logo',              'Company Logo (URL)',                        1),
  ('sec_g_description',       'Preferred Company Description',            1),
  ('sec_g_social',            'Social Media Handles',                     1),
  ('sec_g_public_tag',        'Can we tag your company publicly?',        1),

  -- Section H
  ('sec_h',                   'Section H — Payment Details',              1),
  ('sec_h_amount',            'Sponsorship Amount',                       1),
  ('sec_h_invoice',           'Invoice Required',                         1),
  ('sec_h_billing_contact',   'Billing Contact',                          1),
  ('sec_h_billing_email',     'Billing Email',                            1),

  -- Section I
  ('sec_i',                   'Section I — Swag + Materials',            1),
  ('sec_i_swag_bags',         'Include Swag in Bags',                     1),
  ('sec_i_api_credits',       'Provide API Credits',                      1),
  ('sec_i_cloud_credits',     'Provide Cloud Credits',                    1),
  ('sec_i_hardware',          'Provide Hardware Prizes',                  1),
  ('sec_i_custom',            'Custom Swag / Materials',                  1),
  ('sec_i_shipping',          'Shipping Address',                         1),

  -- Section J
  ('sec_j',                   'Section J — Representative Attendance',   1),
  ('sec_j_attending',         'Representatives Attending',               1),
  ('sec_j_names',             'Representative Names',                    1),
  ('sec_j_emails',            'Representative Emails',                   1),
  ('sec_j_dietary',           'Dietary Restrictions',                    1),

  -- Section K
  ('sec_k',                   'Section K — Legal Agreement',             1),
  ('sec_k_terms',             'I agree to the sponsorship terms',        1),
  ('sec_k_logo',              'I allow logo usage on event materials',   1),
  ('sec_k_payment',           'I agree to the payment terms',           1),

  -- Section L
  ('sec_l',                   'Section L — Additional Notes',            1),
  ('sec_l_notes',             'Additional Notes / Custom Requests',      1);
