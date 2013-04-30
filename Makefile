# New ports collection makefile for:	uwsgi
#1;2602;0c Date created:				23 May 2010
# Whom:					Daniel Gerzo <danger@FreeBSD.org>
#
# $FreeBSD: www/uwsgi/Makefile 313879 2013-03-11 12:50:46Z demon $
#

PORTNAME=	uwsgi
PORTVERSION=	1.9.8
CATEGORIES=	www python
MASTER_SITES=	http://projects.unbit.it/downloads/

MAINTAINER=	demon@FreeBSD.org
COMMENT=	Developer-friendly WSGI server which uses uwsgi protocol

LICENSE=	GPLv2
LICENSE_FILE=	${WRKSRC}/LICENSE

MAKE_JOBS_SAFE=	yes

USE_GNOME=	libxml2
USE_PYTHON=	yes
USE_RC_SUBR=	uwsgi

OPTIONS_DEFINE= CACHE CARBON CGI CHEAPER_BUSYNESS FASTROUTER GEVENT GREENLET HTTP LOGFILE LOGSOCKET NAGIOS PHP PING PSGI PYTHON RACK RRDTOOL SYSLOG UGREEN ZERGPOOL

CACHE_DESC= uwsgi internal cache plugin
CARBON_DESC= uwsgi plugin to report stats to carbon backend
CHEAPER_BUSYNESS_DESC= Alternative uwsgi algorithm for auto-scaling number of workers
CGI_DESC= uwsgi plugin to run basic cgi scripts
FASTROUTER_DESC= a uwsgi load-balancer plugin
GEVENT_DESC= add python gevent to uwsgi
GREENLET_DESC= add python greenlet to uwsgi
HTTP_DESC= add ability to talk to uwsgi processes via http
LOGFILE_DESC= add ability to log uwsgi events to a file
LOGSOCKET_DESC= add ability to log uwsgi events to a socket
NAGIOS_DESC= add nagios integration to uwsgi
PHP_DESC= uwsgi php plugin, use embedded option to build php for best performance
PING_DESC= uwsgi ping plugin
PSGI_DESC= uwsgi psgi plugin for perl
PYTHON_DESC= uwsgi python plugin
RACK_DESC= uwsgi ruby plugin
RRDTOOL_DESC= uwsgi plugin to report stats to an rrd backend
SYSLOG_DESC= add ability to log uwsgi events to syslog
UGREEN_DESC= uwsgi async plugin inspired by python greenlet
ZERGPOOL_DESC= a uwsgi method of auto-scaling workers

OPTIONS_DEFAULT=PYTHON SYSLOG HTTP

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MCACHE}
UWSGI_PLUGINS+= cache,
PLIST_SUB+=	CACHE=""
.else
PLIST_SUB+=	CACHE="@comment "
.endif

.if ${PORT_OPTIONS:MCARBON}
UWSGI_PLUGINS+= carbon,
PLIST_SUB+=	CARBON=""
.else
PLIST_SUB+=	CARBON="@comment "
.endif


.if ${PORT_OPTIONS:MCGI}
UWSGI_PLUGINS+= cgi,
PLIST_SUB+=	CGI=""
.else
PLIST_SUB+=	CGI="@comment "
.endif


.if ${PORT_OPTIONS:MCHEAPER_BUSYNESS}
UWSGI_PLUGINS+= cheaper_busyness,
PLIST_SUB+=	CHEAPER_BUSYNESS=""
.else
PLIST_SUB+=	CHEAPER_BUSYNESS="@comment "
.endif

.if ${PORT_OPTIONS:MFASTROUTER}
UWSGI_PLUGINS+= fastrouter,
PLIST_SUB+=	FASTROUTER=""
.else
PLIST_SUB+=	FASTROUTER="@comment "
.endif

.if ${PORT_OPTIONS:MGEVENT}
UWSGI_PLUGINS+= gevent,
PLIST_SUB+=	GEVENT=""
.else
PLIST_SUB+=	GEVENT="@comment "
.endif

.if ${PORT_OPTIONS:MGREENLET}
UWSGI_PLUGINS+= greenlet,
PLIST_SUB+=	GREENLET=""
.else
PLIST_SUB+=	GREENLET="@comment "
.endif

.if ${PORT_OPTIONS:MHTTP}
UWSGI_PLUGINS+= http,
PLIST_SUB+=	HTTP=""
.else
PLIST_SUB+=	HTTP="@comment "
.endif

.if ${PORT_OPTIONS:MLOGFILE}
UWSGI_PLUGINS+= logfile,
PLIST_SUB+=	LOGFILE=""
.else
PLIST_SUB+=	LOGFILE="@comment "
.endif

.if ${PORT_OPTIONS:MLOGSOCKET}
UWSGI_PLUGINS+= logsocket,
PLIST_SUB+=	LOGSOCKET=""
.else
PLIST_SUB+=	LOGSOCKET="@comment "
.endif

.if ${PORT_OPTIONS:MNAGIOS}
UWSGI_PLUGINS+= nagios,
PLIST_SUB+=	NAGIOS=""
.else
PLIST_SUB+=	NAGIOS="@comment "
.endif

.if ${PORT_OPTIONS:MPHP}
UWSGI_PLUGINS+= php,
PLIST_SUB+=	PHP=""
.else
PLIST_SUB+=	PHP="@comment "
.endif

.if ${PORT_OPTIONS:MPING}
UWSGI_PLUGINS+= ping,
PLIST_SUB+=	PING=""
.else	
PLIST_SUB+=	PING="@comment "
.endif

.if ${PORT_OPTIONS:MPSGI}
UWSGI_PLUGINS+= psgi,
PLIST_SUB+=	PSGI=""
.else
PLIST_SUB+=	PSGI="@comment "
.endif

.if ${PORT_OPTIONS:MPYTHON}
UWSGI_PLUGINS+= python,
PLIST_SUB+=	PYTHON=""
.else
PLIST_SUB+=	PYTHON="@comment "
.endif

.if ${PORT_OPTIONS:MRACK}
UWSGI_PLUGINS+= rack,
PLIST_SUB+=	RACK=""
.else
PLIST_SUB+=	RACK="@comment "
.endif

.if ${PORT_OPTIONS:MRRDTOOL}
UWSGI_PLUGINS+= rrdtool,
PLIST_SUB+=	RRDTOOL=""
.else
PLIST_SUB+=	RRDTOOL="@comment "
.endif

.if ${PORT_OPTIONS:MSYSLOG}
UWSGI_PLUGINS+= syslog,
PLIST_SUB+=	SYSLOG=""
.else
PLIST_SUB+=	SYSLOG="@comment "
.endif

.if ${PORT_OPTIONS:MUGREEN}
UWSGI_PLUGINS+= ugreen,
PLIST_SUB+=	UGREEN=""
.else
PLIST_SUB+=	UGREEN="@comment "
.endif

.if ${PORT_OPTIONS:MZERGPOOL}
UWSGI_PLUGINS+= zergpool,
PLIST_SUB+= ZERGPOOL=""
.else
PLIST_SUB+=	ZERGPOOL="@comment "
.endif

post-patch:
	${REINPLACE_CMD} -e 's|python|${PYTHON_CMD}|' ${WRKSRC}/Makefile 
	${REINPLACE_CMD} -e 's|--build|--build modular|' ${WRKSRC}/Makefile
	${REINPLACE_CMD} -e 's|^plugins = |plugins = ${UWSGI_PLUGINS}|' ${WRKSRC}/buildconf/modular.ini
	${REINPLACE_CMD} -e 's|,$$||g' ${WRKSRC}/buildconf/modular.ini
do-install:
	${MKDIR} /usr/local/lib/uwsgi
	@${INSTALL_PROGRAM} ${WRKSRC}/${PORTNAME} ${PREFIX}/bin/
	@${INSTALL_DATA}  ${WRKSRC}/uwsgidecorators.py ${PYTHON_SITELIBDIR}
	@${INSTALL_LIB} ${WRKSRC}/plugins/*.so ${PREFIX}/lib/${PORTNAME}

.include <bsd.port.mk>
