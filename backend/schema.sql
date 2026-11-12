CREATE EXTENSION IF NOT EXISTS cube;
CREATE EXTENSION IF NOT EXISTS earthdistance;

-- ACCOUNTS (base table + one subtype table per user type)
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  first_name text NOT NULL,
  last_name text NOT NULL,
  phone text,
  email_verified boolean NOT NULL DEFAULT false,
  mfa_enabled boolean NOT NULL DEFAULT false,
  mfa_secret text,                       -- must be encrypted by the app before storing
  matching_limited boolean NOT NULL DEFAULT false,  -- set when a review is overdue
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE admin_profiles (
  user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE homeowner_profiles (
  user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  latitude double precision,
  longitude double precision,
  max_distance_miles int NOT NULL DEFAULT 25 CHECK (max_distance_miles > 0),
  preferred_repairer_gender text NOT NULL DEFAULT 'everyone'
    CHECK (preferred_repairer_gender IN ('men','women','other','everyone'))
);

CREATE TABLE repairer_profiles (
  user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  bio text,
  gender text CHECK (gender IN ('man','woman','other')),
  latitude double precision,
  longitude double precision,
  max_distance_miles int NOT NULL DEFAULT 25 CHECK (max_distance_miles > 0),
  years_experience int
);

-- CATEGORIES (with sub-categories)
CREATE TABLE categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id uuid REFERENCES categories(id),
  name text UNIQUE NOT NULL
);

CREATE TABLE repairer_categories (
  repairer_id uuid NOT NULL REFERENCES repairer_profiles(user_id) ON DELETE CASCADE,
  category_id uuid NOT NULL REFERENCES categories(id),
  PRIMARY KEY (repairer_id, category_id)
);

CREATE TABLE certifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  repairer_id uuid NOT NULL REFERENCES repairer_profiles(user_id) ON DELETE CASCADE,
  name text NOT NULL,
  issuer text,
  issued_on date,
  expires_on date
);

-- JOBS
CREATE TABLE jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  homeowner_id uuid NOT NULL REFERENCES homeowner_profiles(user_id),
  repairer_id uuid REFERENCES repairer_profiles(user_id),
  category_id uuid NOT NULL REFERENCES categories(id),
  description text NOT NULL,
  timeline text,
  initial_rate numeric(10,2) CHECK (initial_rate >= 0),
  latitude double precision,
  longitude double precision,
  status text NOT NULL DEFAULT 'open'
    CHECK (status IN ('open','pending','in_progress','completed')),
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz,
  CHECK ((status = 'open') = (repairer_id IS NULL)),
  CHECK ((status = 'completed') = (completed_at IS NOT NULL))
);
CREATE INDEX jobs_status_idx ON jobs (status);

CREATE TABLE job_media (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  media_type text NOT NULL CHECK (media_type IN ('image','video')),
  file_path text NOT NULL,
  uploaded_at timestamptz NOT NULL DEFAULT now()
);

-- SWIPE MATCHING
CREATE TABLE swipes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  repairer_id uuid NOT NULL REFERENCES repairer_profiles(user_id) ON DELETE CASCADE,
  swiper_role text NOT NULL CHECK (swiper_role IN ('homeowner','repairer')),
  direction text NOT NULL CHECK (direction IN ('left','right')),
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (job_id, repairer_id, swiper_role)
);

CREATE TABLE matches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  repairer_id uuid NOT NULL REFERENCES repairer_profiles(user_id) ON DELETE CASCADE,
  matched_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (job_id, repairer_id)
);

-- CHAT AND CONTACT SHARING (belong to a match)
CREATE TABLE messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id uuid NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL REFERENCES users(id),
  content text NOT NULL,
  sent_at timestamptz NOT NULL DEFAULT now(),
  read_at timestamptz
);
CREATE INDEX messages_match_idx ON messages (match_id, sent_at);

CREATE TABLE contact_shares (
  match_id uuid NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES users(id),
  shared_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (match_id, user_id)
);

-- COMPLETION PROOF AND REVIEWS
CREATE TABLE completion_proofs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  uploader_id uuid NOT NULL REFERENCES users(id),
  image_path text NOT NULL,
  uploaded_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (job_id, uploader_id)
);

CREATE TABLE reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  reviewer_id uuid NOT NULL REFERENCES users(id),
  reviewee_id uuid NOT NULL REFERENCES users(id),
  rating smallint NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment text,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (job_id, reviewer_id),
  CHECK (reviewer_id <> reviewee_id)
);

-- SEED CATEGORIES
INSERT INTO categories (name) VALUES
  ('Plumbing'), ('HVAC'), ('Landscaping'), ('Tiling'), ('Painting'),
  ('Cleaning Services'), ('Carpentry'), ('Electrical'),
  ('Household Appliance Repair'), ('Car Detailing');

INSERT INTO categories (name, parent_id)
SELECT v.name, p.id FROM (VALUES
  ('Carpet cleaning', 'Cleaning Services'),
  ('Fridge', 'Household Appliance Repair'),
  ('Oven', 'Household Appliance Repair'),
  ('Washer/Dryer', 'Household Appliance Repair'),
  ('Dishwasher', 'Household Appliance Repair')
) AS v(name, parent) JOIN categories p ON p.name = v.parent;
