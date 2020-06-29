defaults
	mode                	http
	log                 	global
	option              	httplog
	option              	dontlognull
	option forwardfor   	except 127.0.0.0/8
	option              	redispatch
	retries             	3
	timeout http-request	10s
	timeout queue       	1m
	timeout connect     	10s
	timeout client      	300s
	timeout server      	300s
	timeout http-keep-alive 10s
	timeout check       	10s
	maxconn             	20000

# Useful for debugging, dangerous for production
listen stats
	bind :9000
	mode http
	stats enable
	stats uri /

frontend openshift-api-server
	bind *:6443
	default_backend openshift-api-server
	mode tcp
	option tcplog

backend openshift-api-server
	balance source
	mode tcp
	server master-0 ${master0_ip}:6443 check
	server master-1 ${master1_ip}:6443 check
	server master-2 ${master2_ip}:6443 check
	server bootstrap ${bootstrap_ip}:6443 check

frontend machine-config-server
	bind *:22623
	default_backend machine-config-server
	mode tcp
	option tcplog

backend machine-config-server
	balance source
	mode tcp
        server master-0 ${master0_ip}:22623 check
        server master-1 ${master1_ip}:22623 check
        server master-2 ${master2_ip}:22623 check
        server bootstrap ${bootstrap_ip}:22623 check

frontend ingress-http
	bind *:80
	default_backend ingress-http
	mode tcp
	option tcplog

backend ingress-http
	balance source
	mode tcp
	server worker-0 ${worker0_ip}:80 check
	server worker-1 ${worker1_ip}:80 check

frontend ingress-https
	bind *:443
	default_backend ingress-https
	mode tcp
	option tcplog

backend ingress-https
	balance source
	mode tcp
	server worker-0 ${worker0_ip}:443 check
	server worker-1 ${worker1_ip}:443 check