#!/bin/bash

# V2 Decision Tree API Test Script
API_URL="https://sme-chat-test.vercel.app/api/chat"

# Helper function to call API
call_api() {
    local message="$1"
    echo "📤 Sending: $message"
    echo ""

    response=$(curl -s -X POST "$API_URL" \
        -H 'Content-Type: application/json' \
        -d "{\"messages\":[{\"role\":\"user\",\"content\":\"$message\"}]}")

    # Extract text using jq
    text=$(echo "$response" | jq -r '.content[0].text')

    echo "📥 Response:"
    echo "$text"
    echo ""
    echo "---"
    echo ""
}

# Test 1: Greeting
echo "=== TEST 1: GREETING ==="
call_api "Hello"

# Test 2: Weak Position - Timeline Pressure
echo "=== TEST 2: WEAK POSITION - TIMELINE PRESSURE ==="
call_api "I need help with a software vendor renewal. They're demanding a 25% increase and our contract expires in 2 months. It would take us 6 months to switch to an alternative vendor."

sleep 2

# Test 3: Bargaining - Simple Price with Alternatives
echo "=== TEST 3: BARGAINING - SIMPLE PRICE + ALTERNATIVES ==="
call_api "I'm negotiating office supply pricing. We have 3 other vendors we can switch to easily. It's mainly about getting the best price per unit."

sleep 2

# Test 4: Trading - Multiple Terms, Medium Trust
echo "=== TEST 4: TRADING - MULTIPLE TERMS + MEDIUM TRUST ==="
call_api "I'm renewing with our logistics partner. We've worked together for 2 years with okay performance. I need to negotiate price, delivery times, payment terms, and insurance coverage."

sleep 2

# Test 5: Creating - High Trust, Stable Performance
echo "=== TEST 5: CREATING - HIGH TRUST + STABLE PERFORMANCE ==="
call_api "I'm working with our long-term technology partner (4 years, excellent performance). I want to explore expanding our partnership into new service areas and co-development opportunities."

sleep 2

# Test 6: Partnering - Long-term Relationship
echo "=== TEST 6: PARTNERING - LONG-TERM RELATIONSHIP (5+ YEARS) ==="
call_api "I'm meeting with our strategic manufacturing partner of 7 years. We want to discuss long-term alignment, joint R&D investment, and deepening our partnership for the next 5 years."

echo "=== TESTING COMPLETE ==="
