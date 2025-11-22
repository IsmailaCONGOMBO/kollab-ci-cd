#!/bin/bash

# Script de test pour vérifier le repository dispatch
# Usage: ./test-dispatch.sh [backend|frontend] [YOUR_GITHUB_TOKEN]

set -e

EVENT_TYPE=${1:-"backend_updated"}
TOKEN=${2:-$GITHUB_TOKEN}

if [ -z "$TOKEN" ]; then
    echo "❌ Token GitHub requis"
    echo "Usage: $0 [backend_updated|frontend_updated] [TOKEN]"
    echo "Ou définir GITHUB_TOKEN en variable d'environnement"
    exit 1
fi

echo "🧪 Test du repository dispatch..."
echo "📡 Event type: $EVENT_TYPE"
echo "🎯 Target: IsmailaCONGOMBO/kollab-ci-cd"

# Envoyer le dispatch
curl -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Content-Type: application/json" \
  https://api.github.com/repos/IsmailaCONGOMBO/kollab-ci-cd/dispatches \
  -d "{
    \"event_type\": \"$EVENT_TYPE\",
    \"client_payload\": {
      \"test\": true,
      \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",
      \"trigger\": \"manual_test\"
    }
  }"

echo ""
echo "✅ Repository dispatch envoyé!"
echo "🔗 Vérifier les Actions: https://github.com/IsmailaCONGOMBO/kollab-ci-cd/actions"
echo "⏱️ Le workflow devrait se déclencher dans quelques secondes..."