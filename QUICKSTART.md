# 🚀 Quick Start Guide

Get up and running in 3 steps!

## Step 1: Clone & Navigate

```bash
git clone <repository-url>
cd mmm-env
```

## Step 2: Create Environment File

```bash
cp .env.example .env
```

*(Optional: Edit `.env` if you need custom ports or database credentials)*

## Step 3: Start Everything

```bash
docker compose up -d
```

**That's it!** 🎉

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

