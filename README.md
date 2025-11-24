# MMM2027 - Monorepo Full-Stack Application

Monorepo containing Next.js frontend, Laravel backend API, and Docker orchestration environment.

## 🏗️ Repository Structure

```
mmm-env/
├── apps/
│   ├── mmm-frontend/  → Next.js (TypeScript) Frontend
│   └── mmm-backend/   → Laravel API Backend
├── nginx/             → Nginx configuration files
├── docker-compose.yml → Docker orchestration (starts all services)
├── .env.example       → Environment variables template
├── database_schema.sql → Database schema DDL file
└── README.md          → This file
```

## 🚀 Quick Start

### Prerequisites

- Docker (v20.10+)
- Docker Compose (v2.0+)

### Setup & Run

1. **Clone the repositories**:

   ```bash
   # Clone the main environment repository
   git clone <mmm-env-repository-url>
   cd mmm-env
   
   # Clone the frontend repository
   git clone <mmm-frontend-repository-url> apps/mmm-frontend
   
   # Clone the backend repository
   git clone <mmm-backend-repository-url> apps/mmm-backend
   ```

   **Note:** Since `apps/` contains separate Git repositories, you need to clone them into the `apps/` directory.

2. **Create environment file**:

   ```bash
   cp .env.example .env
   ```

   The `.env.example` file contains default values that work out of the box. You can customize them if needed.

3. **Start all services** (backend + frontend + database):

   ```bash
   docker compose up -d
   ```

   This single command will:

   - ✅ Pull/build Docker images
   - ✅ Start PostgreSQL 16 database
   - ✅ Start Laravel backend (PHP-FPM + Nginx)
   - ✅ Start Next.js frontend development server
   - ✅ Run database migrations automatically
   - ✅ Install dependencies automatically

   **Note:** Everything is automated! Dependencies are installed and migrations run automatically on first startup.

4. **Access the application:**
   - **Frontend**: http://localhost:3000
   - **Backend API**: http://localhost:8000
   - **PostgreSQL**: localhost:5432
   - **Database credentials**: See `.env` file

## 📋 Available Commands

### Start all services

```bash
docker compose up -d
```

### Stop all services

```bash
docker compose down
```

### Stop and remove volumes (fresh start)

```bash
docker compose down -v
```

### View logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f frontend
docker compose logs -f backend-php
docker compose logs -f db
```

### Rebuild containers

```bash
docker compose build --no-cache
docker compose up -d
```

### Execute commands in containers

**Laravel Artisan:**

```bash
docker compose exec backend-php php artisan migrate
docker compose exec backend-php php artisan key:generate
docker compose exec backend-php php artisan make:controller UserController
docker compose exec backend-php php artisan tinker
```

**Node/NPM:**

```bash
docker compose exec frontend npm install
docker compose exec frontend npm run build
docker compose exec frontend npm run dev
```

**PostgreSQL:**

```bash
docker compose exec db psql -U mmm2027_user -d mmm2027_db
```

**Access database with psql:**

```bash
docker compose exec db psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}
```

## 🏛️ Architecture

### Services

1. **db** - PostgreSQL 16

   - Port: `5432:5432` (configurable via `DB_PORT` in `.env`)
   - Data persisted in `mmm2027_postgres_data` volume
   - Health checks enabled
   - Automatic migrations on startup

2. **backend-php** - PHP-FPM for Laravel

   - Processes PHP requests
   - Mounts `apps/mmm-backend/` for live code changes
   - Automatically installs dependencies and runs migrations
   - Laravel 11 with latest features

3. **backend-nginx** - Nginx reverse proxy

   - Port: `8000:80` (configurable via `BACKEND_PORT` in `.env`)
   - Serves Laravel API
   - Proxies PHP requests to `backend-php:9000`

4. **frontend** - Next.js development server
   - Port: `3000:3000` (configurable via `FRONTEND_PORT` in `.env`)
   - Hot reload enabled
   - Mounts `apps/mmm-frontend/` for live changes
   - Next.js with TypeScript

### Networking

All containers communicate via `app-net` bridge network:

- Frontend → Backend: `http://backend-nginx/api/v1`
- Backend → PostgreSQL: `db:5432`

## 📁 Project Structure

### Frontend (`apps/mmm-frontend/`)

- Next.js (latest) with App Router
- TypeScript
- Tailwind CSS
- API client library (`lib/api.ts`)
- Component structure

### Backend (`apps/mmm-backend/`)

- Laravel 11 API (latest)
- RESTful endpoints at `/api/v1/`
- Database migrations (auto-run on startup)
- Eloquent models
- PostgreSQL database

## 🔧 Development Workflow

1. **Make code changes** in `apps/mmm-frontend/` or `apps/mmm-backend/`
2. **Changes are hot-reloaded** automatically (no container restart needed)
3. **View logs** to debug: `docker compose logs -f [service]`
4. **Migrations run automatically** on container startup
5. **Manual migration** (if needed): `docker compose exec backend-php php artisan migrate`

## 🐛 Troubleshooting

### Port conflicts

Edit `.env` to change ports:

```env
FRONTEND_PORT=3001
BACKEND_PORT=8001
DB_PORT=5433
```

### Permission issues (Laravel storage)

```bash
docker-compose exec backend-php chown -R www-data:www-data /var/www/html/storage
docker-compose exec backend-php chmod -R 755 /var/www/html/storage
```

### Rebuild everything

```bash
docker compose down -v  # Removes volumes too
docker compose build --no-cache
docker compose up -d
```

### Check service status

```bash
docker compose ps
```

### Database version mismatch

If you see "database files are incompatible" error, ensure `docker-compose.yml` uses the same PostgreSQL version as your data volume, or remove the volume:

```bash
docker compose down -v
docker compose up -d
```

## 📚 Documentation

- **Frontend**: See `apps/mmm-frontend/README.md`
- **Backend**: See `apps/mmm-backend/README.md`
- **Database Schema**: See `database_schema.sql`
- **Environment Variables**: See `.env.example`

## 🎯 Key Features

- ✅ **One command setup**: `docker compose up -d` starts everything
- ✅ **Zero configuration**: Works out of the box with default `.env.example`
- ✅ **Automatic migrations**: Database tables created automatically
- ✅ **Hot reload**: Code changes reflect immediately
- ✅ **Latest versions**: Laravel 11, Next.js latest, PostgreSQL 16
- ✅ **Easy collaboration**: Simple setup for team members
- ✅ **Separated services**: Clean architecture with frontend/backend separation
- ✅ **Production-ready base**: Easy to extend and deploy

## 👥 For Team Members

**First time setup:**

1. Clone the repository
2. Copy `.env.example` to `.env` (or use defaults)
3. Run `docker compose up -d`
4. Done! Everything is automated.

**No need to:**

- Install PHP, Node.js, or PostgreSQL locally
- Run `composer install` or `npm install` manually
- Run migrations manually
- Configure database connections

Everything is handled by Docker!

---

**Ready to develop! 🚀**
