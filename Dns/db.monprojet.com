;
; BIND data file for monprojet.com
;
$TTL	604800
@	IN	SOA	ns.monprojet.com. root.monprojet.com. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	ns.monprojet.com.
ns      IN      A       192.168.1.34
ldap 	IN	A	192.168.1.34
@      IN      AAAA    ::1

