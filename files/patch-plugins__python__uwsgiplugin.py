--- plugins/python/uwsgiplugin.py.orig	2013-10-17 02:58:20.000000000 +0800
+++ plugins/python/uwsgiplugin.py	2013-10-18 08:52:07.000000000 +0800
@@ -18,45 +18,13 @@
 
 if not 'UWSGI_PYTHON_NOLIB' in os.environ:
     LIBS = sysconfig.get_config_var('LIBS').split() + sysconfig.get_config_var('SYSLIBS').split()
-    # check if it is a non-shared build (but please, add --enable-shared to your python's ./configure script)
-    if not sysconfig.get_config_var('Py_ENABLE_SHARED'):
-        libdir = sysconfig.get_config_var('LIBPL')
-        # libdir does not exists, try to get it from the venv
-        version = get_python_version()
-        if not os.path.exists(libdir):
-            libdir = '%s/lib/python%s/config' % (sys.prefix, version)
-        # try skipping abiflag
-        if not os.path.exists(libdir) and version.endswith('m'):
-            version = version[:-1]
-            libdir = '%s/lib/python%s/config' % (sys.prefix, version)
-        # try 3.x style config dir
-        if not os.path.exists(libdir):
-            libdir = '%s/lib/python%s/config-%s' % (sys.prefix, version, get_python_version())
-
-        # get cpu type
-        uname = os.uname()
-        if uname[4].startswith('arm'):
-            libpath = '%s/%s' % (libdir, sysconfig.get_config_var('LIBRARY'))
-            if not os.path.exists(libpath): 
-                libpath = '%s/%s' % (libdir, sysconfig.get_config_var('LDLIBRARY'))
-        else:
-            libpath = '%s/%s' % (libdir, sysconfig.get_config_var('LDLIBRARY'))
-            if not os.path.exists(libpath): 
-                libpath = '%s/%s' % (libdir, sysconfig.get_config_var('LIBRARY'))
-        if not os.path.exists(libpath): 
-            libpath = '%s/libpython%s.a' % (libdir, version)
-        LIBS.append(libpath)
-        # hack for messy linkers/compilers
-        if '-lutil' in LIBS:
-            LIBS.append('-lutil')
-    else:
-        try:
-            LDFLAGS.append("-L%s" % sysconfig.get_config_var('LIBDIR'))
-            os.environ['LD_RUN_PATH'] = "%s" % (sysconfig.get_config_var('LIBDIR'))
-        except:
-            LDFLAGS.append("-L%s/lib" % sysconfig.PREFIX)
-            os.environ['LD_RUN_PATH'] = "%s/lib" % sysconfig.PREFIX
-
-        LIBS.append('-lpython%s' % get_python_version())
+    try:
+        LDFLAGS.append("-L%s" % sysconfig.get_config_var('LIBDIR'))
+        os.environ['LD_RUN_PATH'] = "%s" % (sysconfig.get_config_var('LIBDIR'))
+    except:
+        LDFLAGS.append("-L%s/lib" % sysconfig.PREFIX)
+        os.environ['LD_RUN_PATH'] = "%s/lib" % sysconfig.PREFIX
+  
+    LIBS.append('-lpython%s' % get_python_version())
 else:
     LIBS = []
