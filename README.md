# Apache Proxy on Docker

# Table of Contents
1. [Introduction](#introduction)
2. [Deploy](#deploy)
3. [Recommended](#recommended)
4. [SSL Support](#ssl-support)

## Introduction
Apache web server like proxy to Docker.

Enable modules :
  * proxy
  * proxy_http
  * ssl

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
docker run --name apache-proxy --link sitecontainer:sitecontainer --volumes-from proxy-data -p 80:80 -d diouxx/apache-proxy
```

[And an exemple proxy configurations](https://httpd.apache.org/docs/current/en/mod/mod_proxy.html)

```html
<VirtualHost *:80>
	ServerName yoursite.domain.com

	ProxyPass "/" "http://sitecontainer/"
	ProxyPassReverse "/" "http://sitecontainer/"

</VirtualHost>
```
## SSL Support

To use Apache proxy with HTTPS :

* First, configure your virtual host with SSL support

If you can use together HTTP and HTTPS port
```html
<VirtualHost *:80>
        ServerName yoursite.domain.com

        ProxyPass "/" "http://sitecontainer/"
        ProxyPassReverse "/" "http://sitecontainer/"

</VirtualHost>

<VirtualHost *:443>
        ServerName yoursite.domain.com

        SSLEngine On

        SSLCertificateFile /opt/ssl/yourcertificate.crt
        SSLCertificateKeyFile /opt/ssl/yourcertificate.key

        SSLProxyEngine on

        <Location />
                ProxyPass / http://sitecontainer/
                ProxyPassReverse / http://sitecontainer/
        </Location>

</VirtualHost>
```

If you can user only HTTPS port and force redirect
```html
<VirtualHost *:80>
	ServerName yoursite.domain.com

	Redirect permanent / https://yoursite.domain.com/
</VirtualHost>

<VirtualHost *:443>
        ServerName yoursite.domain.com
	
        SSLEngine On

        SSLCertificateFile /opt/ssl/yourcertificate.crt
        SSLCertificateKeyFile /opt/ssl/yourcertificate.key

	SSLProxyEngine on
	
	<Location />
        	ProxyPass http://sitecontainer/
        	ProxyPassReverse http://sitecontainer/
	</Location>

</VirtualHost>
```

* Then, link your SSL certificate folder by volumes. Example :
```sh
docker run --name apache-proxy --volumes yourssldirectory:/opt/ssl/ --volumes-from proxy-data -p 80:80 -p 443:443 -d diouxx/apache-proxy
```
