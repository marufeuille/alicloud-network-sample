#!/bin/bash
echo "cache_peer ${PROXY_A_IP} parent 8080 0 no-query"
echo "http_port 8080"
echo "icp_port 0"
echo "visible_hostname proxy-b"
echo "http_access allow all"

echo "acl transfer dstdomain ${DEST_DOMAINS}"
echo "cache_peer_access ${PROXY_A_IP} allow transfer"
echo "never_direct allow transfer"
