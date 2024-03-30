#!/bin/sh

# replace original smb config
grep '# This is the main Samba configuration file.' /etc/samba/smb.conf 2>/dev/null >/dev/null && cp /container/config/samba/smb.conf /etc/samba/smb.conf

echo -n '>> Enter username: ' 1>&2
read USERNAME
echo -n '>> New password: ' 1>&2
read -s PASSWORD_1
echo
echo -n '>> Retype password: ' 1>&2
read -s PASSWORD_2
echo

USERNAME=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]')

if [ "$PASSWORD_1" == "$PASSWORD_2" ] && [ "$PASSWORD_1" != "" ] && [ "$USERNAME" != "" ]
then
  #adduser -D -H -s /bin/false "$USERNAME" 2> /dev/null >/dev/null
  smbpasswd -a -n "$USERNAME" || exit 1
  echo -e "$PASSWORD_1\n$PASSWORD_1" | passwd "$USERNAME"  || exit 1
  echo -e "$PASSWORD_1\n$PASSWORD_1" | smbpasswd "$USERNAME"  || exit 1
  cat /var/lib/samba/private/smbpasswd | grep ':$' | grep '^'"$USERNAME"':[0-9]*:'
  exit 0
fi

exit 1
