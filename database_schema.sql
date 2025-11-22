-- MMM 2027 Conference Database Schema
-- PostgreSQL DDL for DrawSQL
-- Generated from Laravel migrations

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    affiliation VARCHAR(255) NULL,
    country VARCHAR(255) NULL,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- ============================================
-- SPECIAL SESSIONS TABLE
-- ============================================
CREATE TABLE special_sessions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    page_limit INTEGER NOT NULL DEFAULT 12,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- ============================================
-- PAPERS TABLE
-- ============================================
CREATE TABLE papers (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    abstract TEXT NOT NULL,
    paper_type VARCHAR(50) NOT NULL CHECK (paper_type IN ('regular', 'special_session', 'demo', 'vbs')),
    submission_type VARCHAR(255) NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'submitted' CHECK (status IN ('submitted', 'under_review', 'accepted', 'rejected')),
    file_path VARCHAR(255) NULL,
    source_zip_path VARCHAR(255) NULL,
    copyright_form_path VARCHAR(255) NULL,
    special_session_id BIGINT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_papers_special_session FOREIGN KEY (special_session_id) REFERENCES special_sessions(id) ON DELETE SET NULL
);

-- ============================================
-- PAPER AUTHORS TABLE (Many-to-Many)
-- ============================================
CREATE TABLE paper_authors (
    id BIGSERIAL PRIMARY KEY,
    paper_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    is_corresponding_author BOOLEAN NOT NULL DEFAULT FALSE,
    author_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_paper_authors_paper FOREIGN KEY (paper_id) REFERENCES papers(id) ON DELETE CASCADE,
    CONSTRAINT fk_paper_authors_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uk_paper_authors UNIQUE (paper_id, user_id)
);

-- ============================================
-- REGISTRATIONS TABLE
-- ============================================
CREATE TABLE registrations (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    registration_type VARCHAR(50) NOT NULL CHECK (registration_type IN ('student', 'standard', 'early_bird', 'group')),
    amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'refunded')),
    dietary_restrictions TEXT NULL,
    terms_accepted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_registrations_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- COMMITTEE MEMBERS TABLE
-- ============================================
CREATE TABLE committee_members (
    id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    affiliation VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN (
        'honorary_chair',
        'general_chair',
        'program_chair',
        'program_coordinator',
        'technical_program_chair',
        'video_browser_showdown_chair',
        'web_chair',
        'publication_chair',
        'financial_chair',
        'registration_chair',
        'local_arrangement_chair'
    )),
    photo_path VARCHAR(255) NULL,
    bio TEXT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- ============================================
-- NEWS TABLE
-- ============================================
CREATE TABLE news (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    published_at TIMESTAMP NULL,
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- ============================================
-- IMPORTANT DATES TABLE
-- ============================================
CREATE TABLE important_dates (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    category VARCHAR(255) NULL,
    description TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- ============================================
-- KEYNOTES TABLE
-- ============================================
CREATE TABLE keynotes (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    biography TEXT NULL,
    speaker_name VARCHAR(255) NOT NULL,
    speaker_affiliation VARCHAR(255) NOT NULL,
    photo_path VARCHAR(255) NULL,
    scheduled_date DATE NOT NULL,
    scheduled_time_start TIME NOT NULL,
    scheduled_time_end TIME NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- ============================================
-- CONFERENCE PROGRAM TABLE
-- ============================================
CREATE TABLE conference_program (
    id BIGSERIAL PRIMARY KEY,
    day DATE NOT NULL,
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    session_type VARCHAR(50) NOT NULL DEFAULT 'other' CHECK (session_type IN ('oral', 'poster', 'break', 'keynote', 'workshop', 'other')),
    location VARCHAR(255) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- ============================================
-- SOCIAL EVENTS TABLE
-- ============================================
CREATE TABLE social_events (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    date DATE NOT NULL,
    time_start TIME NULL,
    time_end TIME NULL,
    location VARCHAR(255) NULL,
    map_coordinates VARCHAR(255) NULL,
    image_path VARCHAR(255) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- ============================================
-- VISA SUPPORT LETTERS TABLE
-- ============================================
CREATE TABLE visa_support_letters (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    registration_id BIGINT NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    place_of_birth VARCHAR(255) NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    passport_number VARCHAR(255) NOT NULL,
    passport_expiry DATE NOT NULL,
    paper_id BIGINT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'sent')),
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_visa_support_letters_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_visa_support_letters_registration FOREIGN KEY (registration_id) REFERENCES registrations(id) ON DELETE CASCADE,
    CONSTRAINT fk_visa_support_letters_paper FOREIGN KEY (paper_id) REFERENCES papers(id) ON DELETE SET NULL
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_papers_special_session_id ON papers(special_session_id);
CREATE INDEX idx_papers_status ON papers(status);
CREATE INDEX idx_paper_authors_paper_id ON paper_authors(paper_id);
CREATE INDEX idx_paper_authors_user_id ON paper_authors(user_id);
CREATE INDEX idx_registrations_user_id ON registrations(user_id);
CREATE INDEX idx_registrations_payment_status ON registrations(payment_status);
CREATE INDEX idx_visa_support_letters_user_id ON visa_support_letters(user_id);
CREATE INDEX idx_visa_support_letters_registration_id ON visa_support_letters(registration_id);
CREATE INDEX idx_visa_support_letters_paper_id ON visa_support_letters(paper_id);
CREATE INDEX idx_news_published_at ON news(published_at);
CREATE INDEX idx_news_is_featured ON news(is_featured);
CREATE INDEX idx_important_dates_date ON important_dates(date);
CREATE INDEX idx_keynotes_scheduled_date ON keynotes(scheduled_date);
CREATE INDEX idx_conference_program_day ON conference_program(day);
CREATE INDEX idx_social_events_date ON social_events(date);

