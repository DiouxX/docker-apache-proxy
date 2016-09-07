# Apache Proxy on Docker

Apache web server like proxy to Docker.

Enable modules :
  * proxy
  * proxy_http

## Deploy

* First, create an data container to storage your web site configuration
```
docker create --name proxy-data --volume /opt/proxy-conf/:/opt/proxy-conf busybox /bin/true
```

* Then, create proxy container with link data volume. By default, the data volume is mountend in */opt/proxy-conf*.
All configurations of this website in this directory will be activated
```
docker run --name apache-proxy --volumes-from proxy-data -p 80:80 -d diouxx/apache-proxy
```

## Recommended

I recommanded to link also web site container. It's just my advice

```
docker run --name apache-proxy link sitecontainer:sitecontainer --volumes-from proxy-data -p 80:80 -d diouxx/apache-proxy
```

[And an exemple proxy configurations](https://httpd.apache.org/docs/current/en/mod/mod_proxy.html)

```html
<VirtualHost *:80>
	ServerName yoursite.domain.com

	ProxyPass "/" "http://sitecontainer/"
	ProxyPassReverse "/" "http://sitecontainer/"

</VirtualHost>
```
