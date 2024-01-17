;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	ns.monprojetapache.com. root.monprojetapache.com. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	ns.monprojetapache.com.
ns	IN	A	127.0.1.1
apache	IN	A	127.0.1.1
@	IN	AAAA	::1
