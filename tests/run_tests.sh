#!/bin/sh
# Run tests for aggregateCIDR.pl
# Exit 0 on success, 1 on failure
set -e

SCRIPT="$(dirname "$0")/../aggregateCIDR.pl"
TESTDIR="$(dirname "$0")"

fail=0

# Test 1: baseline output matches expected (quiet mode, no stderr)
actual=$(perl "$SCRIPT" --quiet < "$TESTDIR/networks" 2>/dev/null)
expected=$(grep -v '^#' "$TESTDIR/example.output")
if [ "$actual" = "$expected" ]; then
    echo "PASS: baseline output matches expected"
else
    echo "FAIL: baseline output differs"
    diff <(echo "$actual") <(echo "$expected")
    fail=1
fi

# Test 2: invalid CIDR mask /33 is rejected
out=$(echo "192.168.8.0/33" | perl "$SCRIPT" --quiet 2>&1)
if [ -z "$out" ]; then
    echo "PASS: /33 mask rejected"
else
    echo "FAIL: /33 mask should produce no output, got: $out"
    fail=1
fi

# Test 3: bare IP gets /32 stripped in output
out=$(echo "1.2.3.4" | perl "$SCRIPT" --quiet 2>/dev/null)
if [ "$out" = "1.2.3.4" ]; then
    echo "PASS: bare IP output without /32"
else
    echo "FAIL: expected '1.2.3.4', got '$out'"
    fail=1
fi

# Test 4: SPF mode round-trips correctly
out=$(echo "ip4:10.0.0.0/24" | perl "$SCRIPT" --quiet --spf 2>/dev/null)
if [ "$out" = "ip4:10.0.0.0/24" ]; then
    echo "PASS: SPF mode round-trip"
else
    echo "FAIL: SPF mode expected 'ip4:10.0.0.0/24', got '$out'"
    fail=1
fi

exit $fail
