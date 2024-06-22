#!/bin/bash

FRONTEND_BASE_URL="http://localhost:8000"
API_BASE_URL="http://localhost:4000/api/status"

frontend_test() {
  echo "Testing frontend page..."
  response=$(curl -s -o /dev/null -w "%{http_code}" $FRONTEND_BASE_URL)
  if [ "$response" -eq 200 ]; then
    echo "Frontend test passed."
  else
    echo "Frontend test failed. HTTP status code: $response"
    exit 1
  fi
}

api_test() {
  echo "Testing api server"
  response=$(curl -s -o /dev/null -w "%{http_code}" $API_BASE_URL)
  if [ "$response" -eq 200 ]; then
    echo "API server test passed."
  else
    echo "API server test failed. HTTP status code: $response"
    exit 1
  fi
}

# Run the tests
frontend_test
api_test

echo "All tests passed."
