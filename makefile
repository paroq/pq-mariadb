include $(PQ_FACTORY)/factory.mk

pq_part_name := mariadb-10.0.17
pq_part_file := $(pq_part_name).tar.gz

pq_mariadb_configuration_flags += --prefix=$(part_dir)
pq_mariadb_configuration_flags += --enable-assembler
pq_mariadb_configuration_flags += --with-extra-charsets=complex
pq_mariadb_configuration_flags += --enable-thread-safe-client
pq_mariadb_configuration_flags += --with-big-tables
pq_mariadb_configuration_flags += --with-plugin-maria
pq_mariadb_configuration_flags += --with-aria-tmp-tables
pq_mariadb_configuration_flags += --without-plugin-innodb_plugin
pq_mariadb_configuration_flags += --with-mysqld-ldflags=-static
pq_mariadb_configuration_flags += --with-client-ldflags=-static
pq_mariadb_configuration_flags += --with-readline
pq_mariadb_configuration_flags += --with-plugins=max-no-ndb
pq_mariadb_configuration_flags += --with-embedded-server
pq_mariadb_configuration_flags += --with-libevent
pq_mariadb_configuration_flags += --with-mysqld-ldflags=-all-static
pq_mariadb_configuration_flags += --with-client-ldflags=-all-static
pq_mariadb_configuration_flags += --with-zlib-dir=bundled
pq_mariadb_configuration_flags += --enable-local-infile

pq_mariadb_cmake_flags += -DCMAKE_INSTALL_PREFIX=$(part_dir)
pq_mariadb_cmake_flags += -DWITH_EXTRA_CHARSETS=complex
pq_mariadb_cmake_flags += -DENABLE_THREAD_SAFE_CLIENT=YES
pq_mariadb_cmake_flags += -DWITH_PLUGIN_MARIA=YES
pq_mariadb_cmake_flags += -DUSE_ARIA_FOR_TMP_TABLES=YES
pq_mariadb_cmake_flags += -DWITHOUT_PLUGIN_INNODB_PLUGIN=YES
pq_mariadb_cmake_flags += -DWITH_READLINE=YES
pq_mariadb_cmake_flags += -DWITH_MAX_NO_NDB=YES
pq_mariadb_cmake_flags += -DWITH_EMBEDDED_SERVER=1
pq_mariadb_cmake_flags += -DWITH_LIBEVENT=system
pq_mariadb_cmake_flags += -DWITH_ZLIB=system
pq_mariadb_cmake_flags += -DENABLED_LOCAL_INFILE=YES
pq_mariadb_cmake_flags += -DCURSES_LIBRARY=$(pq-ncurses-dir)/lib/libncurses.so
pq_mariadb_cmake_flags += -DCURSES_INCLUDE_PATH=$(pq-ncurses-dir)/include
pq_mariadb_cmake_flags += -DCURSES_NCURSES_LIBRARY=$(pq-ncurses-dir)/lib/libncurses.so
pq_mariadb_cmake_flags += -DCURSES_CURSES_LIBRARY=$(pq-ncurses-dir)/lib/libncurses.so
pq_mariadb_cmake_flags += -DCURSES_HAVE_CURSES_H=1
pq_mariadb_cmake_flags += -DHAVE_NCURSES_H=1

CFLAGS += -I$(pq-ncurses-dir)/include/ncurses/
CPPFLAGS += -I$(pq-ncurses-dir)/include/ncurses/

build-stamp: stage-stamp
	$(MAKE) -C $(pq_part_name) mkinstalldirs=$(part_dir) VERBOSE=1
	$(MAKE) -C $(pq_part_name) mkinstalldirs=$(part_dir) DESTDIR=$(stage_dir) install
	touch $@

stage-stamp: configure-stamp

configure-stamp: patch-stamp
	cd $(pq_part_name) && BUILD/autorun.sh
	#cd $(pq_part_name) && ./configure $(pq_mariadb_configuration_flags)
	cd $(pq_part_name) && cmake . $(pq_mariadb_cmake_flags)
	touch $@

patch-stamp: unpack-stamp
	touch $@

unpack-stamp: $(pq_part_file)
	tar xf $(source_dir)/$(pq_part_file)
	touch $@
