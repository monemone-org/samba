#!/bin/sh

echo ""
echo ""
echo "################################################################################"
echo ""
echo "#  Creating fluihome groups ..."
# mhsieh:x:1000:
# fluihome:x:1001:mhsieh,flui,tjlui
# flui:x:1002:
# tjlui:x:1003:
# homelab:x:1005:
# nvr:x:1006

addgroup -g "1000" mhsieh
addgroup -g "1002" flui
addgroup -g "1003" tjlui
addgroup -g "1001" fluihome
addgroup -g "1005" homelab
addgroup -g "1006" nvr

echo "#   Done"


echo ""
echo "#  Creating fluihome users ..."
# mhsieh:x:1000
# flui:x:1001
# tjlui:x:1002
# homelab:x:1005:
# nvr:x:1006
adduser -D -H -s /bin/false -u 1000 -G mhsieh  mhsieh
adduser -D -H -s /bin/false -u 1001 -G flui flui
adduser -D -H -s /bin/false -u 1002 -G tjlui tjlui
adduser -D -H -s /bin/false -u 1005 -G homelab homelab
adduser -D -H -s /bin/false -u 1006 -G nvr nvr


echo "#   Done"
echo ""
echo ""

# addgroup mhsieh fluihome
# addgroup flui fluihome
# addgroup tjlui fluihome


