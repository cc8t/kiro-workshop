# Sudoku Web App - Docker Deployment

## Quick Start

### Build and Run
```bash
# Build the Docker image
docker build -t sudoku-app .

# Run the container
docker run -d -p 8080:80 --name sudoku-game sudoku-app
```

### Access Application
- **Local**: http://localhost:8080
- **Architecture Diagram**: http://localhost:8080/sudoku-architecture.drawio
- **Documentation**: http://localhost:8080/README.md

### Docker Commands
```bash
# Stop container
docker stop sudoku-game

# Remove container
docker rm sudoku-game

# Remove image
docker rmi sudoku-app

# View logs
docker logs sudoku-game
```

## Container Details
- **Base Image**: nginx:alpine (~6MB)
- **Web Server**: Nginx
- **Port**: 80 (mapped to 8080)
- **Files**: Sudoku game, README, architecture diagram
