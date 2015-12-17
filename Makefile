# Created by: Daniel Gerzo <danger@FreeBSD.org>
# $FreeBSD: head/www/uwsgi/Makefile 400449 2015-10-29 09:36:52Z koobs $

PORTNAME=	uwsgi
PORTVERSION=	2.0.11.2
PORTREVISION=	2
CATEGORIES=	www python
MASTER_SITES=	http://projects.unbit.it/downloads/

MAINTAINER=	demon@FreeBSD.org
COMMENT=	Developer-friendly WSGI server which uses uwsgi protocol

LICENSE=	GPLv2
LICENSE_FILE=	${WRKSRC}/LICENSE

USES=		python
USE_PYTHON=	concurrent distutils
USE_RC_SUBR=	uwsgi

LDFLAGS+=	"-L${LOCALBASE}/lib"
MAKE_ENV+=	CPUCOUNT=${MAKE_JOBS_NUMBER}
#MAKE_ARGS+=	UWSGI_EMBED_PLUGINS=cgi

PYSETUP=			uwsgiconfig.py
PYDISTUTILS_BUILD_TARGET=	--build modular
PYDISTUTILS_BUILDARGS=		--verbose

OPTIONS_DEFINE= CACHE CARBON CGI CHEAPER_BUSYNESS FASTROUTER HTTP LOGFILE LOGSOCKET  PYTHON SYSLOG  ZERGPOOL

CACHE_DESC= uwsgi internal cache plugin
CARBON_DESC= uwsgi plugin to report stats to carbon backend
CHEAPER_BUSYNESS_DESC= Alternative uwsgi algorithm for auto-scaling number of workers
CGI_DESC= uwsgi plugin to run basic cgi scripts
FASTROUTER_DESC= a uwsgi load-balancer plugin
HTTP_DESC= add ability to talk to uwsgi processes via http
LOGFILE_DESC= add ability to log uwsgi events to a file
LOGSOCKET_DESC= add ability to log uwsgi events to a socket
PYTHON_DESC= uwsgi python plugin
SYSLOG_DESC= add ability to log uwsgi events to syslog
ZERGPOOL_DESC= a uwsgi method of auto-scaling workers

OPTIONS_DEFAULT=PYTHON SYSLOG HTTP

.include <bsd.port.options.mk>

#CONFLICTS=	uwsgi-1.[0-9]*

.if ${PORT_OPTIONS:MCACHE}
UWSGI_PLUGINS+=cache,
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
PHP_USE=  php= session
PHP_LIB_DEPENDS= php5.so:${PORTSDIR}/lang/php5
#LDFLAGS+= "-Wl,-rpath,${PREFIX}/lib/php/20131226"
#LDFLAGS+= "-lphp5"
#LDFLAGS+= "-L${PREFIX}/lib/php/20131226"
#LDFLAGS+= "${PREFIX}/lib/php/20131226/session.so"
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
PERL_USE=	perl=yes
UWSGI_PLUGINS+= psgi,
PLIST_SUB+=	PSGI=""
.else
PLIST_SUB+=	PSGI="@comment "
.endif

.if ${PORT_OPTIONS:MPYTHON}
PYTHON_USE=	python=yes
UWSGI_PLUGINS+= python,
PLIST_SUB+=	PYTHON=""
.else
PLIST_SUB+=	PYTHON="@comment "
.endif

.if ${PORT_OPTIONS:MRACK}
RACK_USE= _ruby=yes
UWSGI_PLUGINS+= rack,
PLIST_SUB+=	RACK=""
.else
PLIST_SUB+=	RACK="@comment "
.endif

.if ${PORT_OPTIONS:MRRDTOOL}
RRDTOOL_LIB_DEPENDS= rrd.so:${PORTSDIR}/databases/rrdtool
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
	${REINPLACE_CMD} -e 's|^plugins = |plugins = ${UWSGI_PLUGINS}|' ${WRKSRC}/buildconf/modular.ini
	${REINPLACE_CMD} -e 's|,$$||g' ${WRKSRC}/buildconf/modular.ini

do-configure:
	@${DO_NADA}

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/${PORTNAME} ${STAGEDIR}${PREFIX}/bin/
	${MKDIR} ${STAGEDIR}${PREFIX}/lib/${PORTNAME}
	${MKDIR} ${STAGEDIR}${PYTHONPREFIX_SITELIBDIR}
	${INSTALL_DATA}  ${WRKSRC}/uwsgidecorators.py ${STAGEDIR}${PYTHONPREFIX_SITELIBDIR}
	${INSTALL_LIB} ${WRKSRC}/plugins/*.so ${STAGEDIR}${PREFIX}/lib/${PORTNAME}

.include <bsd.port.mk>
