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

# Test 3: IPv6 host address without prefix is accepted
out=$(echo "2001:db8::1" | perl "$SCRIPT" --quiet 2>/dev/null)
if [ "$out" = "2001:db8::1/128" ]; then
    echo "PASS: bare IPv6 host address accepted as /128"
else
    echo "FAIL: bare IPv6 host address, got: $out"
    fail=1
fi

# Test 4: compressed and expanded IPv6 forms deduplicate
out=$(printf "2a00:1450:4010::/48\n2a00:1450:4010:0000::/48\n" | perl "$SCRIPT" --quiet 2>/dev/null)
count=$(echo "$out" | wc -l)
if [ "$count" -eq 1 ]; then
    echo "PASS: compressed/expanded IPv6 forms deduplicated"
else
    echo "FAIL: expected 1 entry, got $count"
    fail=1
fi

# Test 5: --spf flag strips and restores ip4:/ip6: prefixes
out=$(printf "ip4:192.0.2.0/24\nip6:2001:db8::/32\n" | perl "$SCRIPT" --quiet --spf 2>/dev/null)
if echo "$out" | grep -q "^ip4:192.0.2.0/24$" && echo "$out" | grep -q "^ip6:2001:db8::/32$"; then
    echo "PASS: --spf prefixes handled correctly"
else
    echo "FAIL: --spf output unexpected: $out"
    fail=1
fi

exit $fail
