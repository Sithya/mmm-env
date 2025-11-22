# MMM2027 - Monorepo Full-Stack Application

Monorepo containing Next.js frontend, Laravel backend API, and Docker orchestration environment.

## 🏗️ Repository Structure

```
mmm2027/
├── apps/
│   ├── frontend/      → Next.js (TypeScript) Frontend
│   └── backend/       → Laravel API Backend
├── nginx/             → Nginx configuration files
├── docker-compose.yml → Docker orchestration (starts all services)
├── .env.example       → Environment variables template
└── README.md          → This file
```

## 🚀 Quick Start

### Prerequisites

- Docker (v20.10+)
- Docker Compose (v2.0+)

### Setup & Run

1. **Navigate to the project directory**:

   ```bash
   cd mmm2027
   ```

2. **Create environment file**:

   ```bash
   cp .env.example .env
   ```

3. **Edit `.env` file** and set your database credentials:

   ```env
   MYSQL_ROOT_PASSWORD=your_secure_password
   MYSQL_DATABASE=mmm2027_db
   MYSQL_USER=mmm2027_user
   MYSQL_PASSWORD=mmm2027_password
   ```

4. **Start all services** (backend + frontend + database):

   ```bash
   docker-compose up -d
   ```

   This single command will start:

   - ✅ MySQL 8.0 database
   - ✅ Laravel backend (PHP-FPM + Nginx)
   - ✅ Next.js frontend development server

5. **Initial Setup** (first time only):

   **Generate Laravel application key:**

   ```bash
   docker-compose exec backend-php php artisan key:generate
   ```

   **Install Laravel dependencies:**

   ```bash
   docker-compose exec backend-php composer install
   ```

   **Install Next.js dependencies:**

   ```bash
   docker-compose exec frontend npm install
   ```

6. **Access the application:**
   - **Frontend**: http://localhost:3000
   - **Backend API**: http://localhost:8000
   - **API Health Check**: http://localhost:8000/api/v1/health
   - **MySQL**: localhost:3307

## 📋 Available Commands

### Start all services

```bash
docker-compose up -d
```

### Stop all services

```bash
docker-compose down
```

### View logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f frontend
docker-compose logs -f backend-php
docker-compose logs -f db
```

### Rebuild containers

```bash
docker-compose build --no-cache
docker-compose up -d
```

### Execute commands in containers

**Laravel Artisan:**

```bash
docker-compose exec backend-php php artisan migrate
docker-compose exec backend-php php artisan key:generate
docker-compose exec backend-php php artisan make:controller UserController
```

**Node/NPM:**

```bash
docker-compose exec frontend npm install
docker-compose exec frontend npm run build
```

**MySQL:**

```bash
docker-compose exec db mysql -u mmm2027_user -p mmm2027_db
```

## 🏛️ Architecture

### Services

1. **db** - MySQL 8.0

   - Port: `3307:3306`
   - Data persisted in `mysql_data` volume

2. **backend-php** - PHP-FPM for Laravel

   - Processes PHP requests
   - Mounts `apps/backend/` for live code changes

3. **backend-nginx** - Nginx reverse proxy

   - Port: `8000:80`
   - Serves Laravel API
   - Proxies PHP requests to `backend-php:9000`

4. **frontend** - Next.js development server
   - Port: `3000:3000`
   - Hot reload enabled
   - Mounts `apps/frontend/` for live changes

### Networking

All containers communicate via `app-net` bridge network:

- Frontend → Backend: `http://backend-nginx/api/v1`
- Backend → MySQL: `db:3306`

## 📁 Project Structure

### Frontend (`apps/frontend/`)

- Next.js 14 with App Router
- TypeScript
- API client library (`lib/api.ts`)
- Component structure

### Backend (`apps/backend/`)

- Laravel 10 API
- RESTful endpoints at `/api/v1/`
- Database migrations
- Eloquent models

## 🔧 Development Workflow

1. **Make code changes** in `apps/frontend/` or `apps/backend/`
2. **Changes are hot-reloaded** automatically (no container restart needed)
3. **View logs** to debug: `docker-compose logs -f [service]`
4. **Run migrations** as needed: `docker-compose exec backend-php php artisan migrate`

## 🐛 Troubleshooting

### Port conflicts

Edit `.env` to change ports:

```env
FRONTEND_PORT=3001
BACKEND_PORT=8001
DB_PORT=3308
```

### Permission issues (Laravel storage)

```bash
docker-compose exec backend-php chown -R www-data:www-data /var/www/html/storage
docker-compose exec backend-php chmod -R 755 /var/www/html/storage
```

### Rebuild everything

```bash
docker-compose down -v  # Removes volumes too
docker-compose build --no-cache
docker-compose up -d
```

### Check service status

```bash
docker-compose ps
```

## 📚 Documentation

- **Frontend**: See `apps/frontend/README.md`
- **Backend**: See `apps/backend/README.md`
- **Architecture**: See `ARCHITECTURE_PLAN.md` (if available)

## 🎯 Key Features

- ✅ **One command to rule them all**: `docker-compose up -d` starts everything
- ✅ **Hot reload**: Code changes reflect immediately
- ✅ **Monorepo structure**: All code in one repository
- ✅ **Separated services**: Clean architecture with frontend/backend separation
- ✅ **Production-ready base**: Easy to extend and deploy

---

**Ready to develop! 🚀**
