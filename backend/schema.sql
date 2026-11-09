CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  full_name text NOT NULL,
  email_verified boolean NOT NULL DEFAULT false,
  mfa_enabled boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE admin_profiles (
  user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE client_profiles (
  user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  address text
);

CREATE TABLE worker_profiles (
  user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  bio text,
  service_area text,
  years_experience int
);

CREATE TABLE categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL
);

INSERT INTO categories (name) VALUES
  ('Home repair'), ('Car repair'), ('Landscaping'), ('Art'), ('Event planning');
