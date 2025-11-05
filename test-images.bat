@echo off
echo Testing CI/CD images...

echo.
echo 1. Pulling images from registry...
docker pull ghcr.io/ismailacongombo/kollab-ci-cd/kollab-backend:latest
docker pull ghcr.io/ismailacongombo/kollab-ci-cd/kollab-frontend:latest

echo.
echo 2. Starting services...
docker-compose -f docker-compose.prod.yml up -d

echo.
echo 3. Waiting for services to start...
timeout /t 10

echo.
echo 4. Testing services...
echo Backend (Laravel): http://localhost:8000
curl -s -o nul -w "Backend Status: %%{http_code}\n" http://localhost:8000

echo Frontend (Nginx): http://localhost:3000
curl -s -o nul -w "Frontend Status: %%{http_code}\n" http://localhost:3000

echo.
echo 5. Container status:
docker-compose -f docker-compose.prod.yml ps

echo.
echo 6. Container logs (last 10 lines):
echo === Backend logs ===
docker logs kollab-backend-prod --tail 10
echo === Frontend logs ===
docker logs kollab-frontend-prod --tail 10

echo.
echo Test complete. Press any key to stop services...
pause
docker-compose -f docker-compose.prod.yml down