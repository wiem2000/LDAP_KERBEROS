;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	ns.monprojetvpn.com. root.monprojetvpn.com. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	ns.monprojetvpn.com.
ns	IN	A	10.8.0.1
openvpn	IN	A	10.8.0.1
@	IN	AAAA	::1
