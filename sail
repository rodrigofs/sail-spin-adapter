#!/usr/bin/env bash

# Sail to Spin Adapter v1.0.0
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

VERSION="1.0.0"
REPO_URL="https://github.com/rodrigofs/sail-spin-adapter"
RAW_URL="https://raw.githubusercontent.com/rodrigofs/sail-spin-adapter/main"

check_environment() {
    # Auto-detect environment and suggest appropriate action
    if [ -f "./docker-compose.yml" ] || [ -f "./compose.yml" ]; then
        if grep -q "laravel.test" docker-compose.yml 2>/dev/null || grep -q "laravel.test" compose.yml 2>/dev/null; then
            echo -e "${YELLOW}Laravel Sail project detected!${NC}"
            echo -e "${YELLOW}Consider using: sail --deactivate${NC}"
            echo ""
        fi
    fi
    
    if [ -d "./.infrastructure" ]; then
        echo -e "${GREEN}Spin project detected - using Spin commands${NC}"
        return 0
    fi
}

check_spin() {
    if ! command -v spin &> /dev/null; then
        echo -e "${RED}Error: Spin not installed${NC}"
        echo "Install at: https://serversideup.net/open-source/spin/"
        exit 1
    fi
    check_environment
}

execute_spin() {
    echo -e "${GREEN}→${NC} spin $*"
    spin "$@"
}

update_adapter() {
    echo -e "${YELLOW}Updating...${NC}"
    curl -fsSL "$RAW_URL/install.sh" | bash
    echo -e "${GREEN}✓ Updated!${NC}"
}

show_migration_notice() {
    echo -e "${YELLOW}⚠️  DEPRECATION NOTICE${NC}"
    echo ""
    echo "This version of the sail script is deprecated."
    echo "Please use the new alias-based approach:"
    echo ""
    echo "1. Install the manager:"
    echo "   curl -fsSL https://raw.githubusercontent.com/rodrigofs/sail-spin-adapter/main/install.sh | bash"
    echo ""
    echo "2. Use the manager:"
    echo "   sail-manager activate   # Use Spin adapter"
    echo "   sail-manager deactivate # Use Laravel Sail"
    echo ""
    echo "This avoids conflicts with Laravel Sail and is easier to manage."
    echo ""
}

star_repo() {
    echo -e "${YELLOW}⭐ Repository: $REPO_URL${NC}"
    if command -v xdg-open &> /dev/null; then
        xdg-open "$REPO_URL"
    elif command -v open &> /dev/null; then
        open "$REPO_URL"
    else
        echo "Open: $REPO_URL"
    fi
}

show_help() {
    echo "Sail to Spin Adapter v$VERSION"
    echo ""
    echo "Container:"
    echo "  sail up -d              Start containers"
    echo "  sail down               Stop containers"
    echo "  sail ps                 List containers"
    echo ""
    echo "Laravel:"
    echo "  sail art migrate        Run migrations"
    echo "  sail art make:model     Create model"
    echo "  sail composer install   Install dependencies"
    echo "  sail tinker             Laravel tinker"
    echo "  sail test               Run tests"
    echo ""
    echo "Node:"
    echo "  sail npm run dev        Vite dev server"
    echo "  sail npm install        Install packages"
    echo ""
    echo "Database:"
    echo "  sail mysql              Connect MySQL"
    echo "  sail postgres           Connect PostgreSQL"
    echo "  sail redis              Redis CLI"
    echo ""
    echo "Shell:"
    echo "  sail bash               Access container"
    echo ""
    echo "Adapter:"
    echo "  sail --migrate          Show migration instructions"
    echo "  sail --update           Update"
    echo "  sail --star             ⭐ Give star"
    echo "  sail --version          Show version"
}

main() {
    case "${1:-help}" in
        "--migrate") show_migration_notice ;;
        "--update") update_adapter ;;
        "--star") star_repo ;;
        "--version") echo "v$VERSION" ;;
        "help"|"-h"|"--help") show_help ;;
        "up"|"down"|"stop"|"ps"|"logs") check_spin && execute_spin "$@" ;;
        "art"|"artisan") check_spin && execute_spin exec php php artisan "${@:2}" ;;
        "php") check_spin && execute_spin exec php php "${@:2}" ;;
        "composer") check_spin && execute_spin exec php composer "${@:2}" ;;
        "tinker") check_spin && execute_spin exec php php artisan tinker ;;
        "test") check_spin && execute_spin exec php php artisan test "${@:2}" ;;
        "npm") check_spin && execute_spin run node npm "${@:2}" ;;
        "yarn") check_spin && execute_spin run node yarn "${@:2}" ;;
        "mysql") check_spin && execute_spin exec mysql mysql -u root -p ;;
        "postgres"|"psql") check_spin && execute_spin exec postgres psql -U postgres ;;
        "redis") check_spin && execute_spin exec redis redis-cli ;;
        "bash") check_spin && execute_spin exec php bash ;;
        "exec") check_spin && execute_spin exec "${@:2}" ;;
        *)
            echo -e "${RED}Invalid command: $1${NC}"
            echo "Use: sail help"
            exit 1
            ;;
    esac
}

main "$@"