# 🚀 Quick Start Guide

Get up and running in 3 steps!

## Step 1: Clone Repositories

```bash
# Clone the main environment repository
git clone <mmm-env-repository-url>
cd mmm-env

# Clone the frontend and backend repositories
git clone <mmm-frontend-repository-url> apps/mmm-frontend
git clone <mmm-backend-repository-url> apps/mmm-backend
```

**Note:** The `apps/` directory contains separate Git repositories that need to be cloned separately.

## Step 2: Create Environment File

```bash
cp .env.example .env
```

_(Optional: Edit `.env` if you need custom ports or database credentials)_

## Step 3: Start Everything

```bash
docker compose up -d --build
```

**That's it!** 🎉

**Note:** Use `--build` the first time to ensure all Docker images are built. After that, you can use just `docker compose up -d`.

## Access Your Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **PostgreSQL**: localhost:5432

## What Happens Automatically?

✅ Docker images are built/pulled  
✅ Dependencies are installed (Composer & npm)  
✅ Database is created and migrations run  
✅ All services start and connect

## Need Help?

- Check service status: `docker compose ps`
- View logs: `docker compose logs -f [service-name]`
- Stop services: `docker compose down`
- Full documentation: See `README.md`

---

**Happy coding!** 💻
