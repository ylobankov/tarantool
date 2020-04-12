#ifndef TARANTOOL_CONFIG_H_INCLUDED
#define TARANTOOL_CONFIG_H_INCLUDED
/*
 * This file is generated by CMake. The original file is called
 * config.h.cmake. Please do not modify.
 */
/** \cond public */

/**
 * Package major version - 1 for 1.6.7
 */
#define PACKAGE_VERSION_MAJOR @CPACK_PACKAGE_VERSION_MAJOR@
/**
 * Package minor version - 6 for 1.6.7
 */
#define PACKAGE_VERSION_MINOR @CPACK_PACKAGE_VERSION_MINOR@
/**
 * Package patch version - 7 for 1.6.7
 */
#define PACKAGE_VERSION_PATCH @CPACK_PACKAGE_VERSION_PATCH@
/**
 * A string with major-minor-patch-commit-id identifier of the
 * release, e.g. 1.6.6-113-g8399d0e.
 */
#define PACKAGE_VERSION "@TARANTOOL_VERSION@"

/** \endcond public */

#define PACKAGE "@PACKAGE@"
/*  Defined if building for Linux */
#cmakedefine TARGET_OS_LINUX 1
/*  Defined if building for FreeBSD */
#cmakedefine TARGET_OS_FREEBSD 1
/*  Defined if building for NetBSD */
#cmakedefine TARGET_OS_NETBSD 1
/*  Defined if building for Darwin */
#cmakedefine TARGET_OS_DARWIN 1

#ifdef TARGET_OS_DARWIN
#define TARANTOOL_LIBEXT "dylib"
#else
#define TARANTOOL_LIBEXT "so"
#endif

/**
 * Defined if cpuid() instruction is available.
 */
#cmakedefine HAVE_CPUID 1

/*
 * Defined if gcov instrumentation should be enabled.
 */
#cmakedefine ENABLE_GCOV 1
/*
 * Defined if configured with ENABLE_BACKTRACE ('show fiber'
 * showing fiber call stack.
 */
#cmakedefine ENABLE_BACKTRACE 1
/*
 * Set if the system has bfd.h header and GNU bfd library.
 */
#cmakedefine HAVE_BFD 1
#cmakedefine HAVE_MAP_ANON 1
#cmakedefine HAVE_MAP_ANONYMOUS 1
#if !defined(HAVE_MAP_ANONYMOUS) && defined(HAVE_MAP_ANON)
/*
 * MAP_ANON is deprecated, MAP_ANONYMOUS should be used instead.
 * Unfortunately, it's not universally present (e.g. not present
 * on FreeBSD.
 */
#define MAP_ANONYMOUS MAP_ANON
#endif
#cmakedefine HAVE_MADV_DONTNEED 1
/*
 * Defined if O_DSYNC mode exists for open(2).
 */
#cmakedefine HAVE_O_DSYNC 1
#if defined(HAVE_O_DSYNC)
    #define WAL_SYNC_FLAG O_DSYNC
#else
    #define WAL_SYNC_FLAG O_SYNC
#endif
/*
 * Defined if fdatasync(2) call is present.
 */
#cmakedefine HAVE_FDATASYNC 1

#ifndef HAVE_FDATASYNC
#if defined(__APPLE__)
#include <fcntl.h>
#define fdatasync(fd) fcntl(fd, F_FULLFSYNC)
#else
#define fdatasync fsync
#endif
#endif

/*
 * Defined if this platform has GNU specific memmem().
 */
#cmakedefine HAVE_MEMMEM 1
/*
 * Defined if this platform has GNU specific memrchr().
 */
#cmakedefine HAVE_MEMRCHR 1
/*
 * Defined if this platform has sendfile(..).
 */
#cmakedefine HAVE_SENDFILE 1
/*
 * Defined if this platform has Linux specific sendfile(..).
 */
#cmakedefine HAVE_SENDFILE_LINUX 1
/*
 * Defined if this platform has BSD specific sendfile(..).
 */
#cmakedefine HAVE_SENDFILE_BSD 1
/*
 * Set if this is a GNU system and libc has __libc_stack_end.
 */
#cmakedefine HAVE_LIBC_STACK_END 1
/*
 * Defined if this is a big-endian system.
 */
#cmakedefine HAVE_BYTE_ORDER_BIG_ENDIAN 1
/*
 * Defined if this platform supports openmp and it is enabled
 */
#cmakedefine HAVE_OPENMP 1
/*
*  Defined if compatible with GNU readline installed.
*/
#cmakedefine HAVE_GNU_READLINE 1

/*
 * Defined if `st_mtim' is a member of `struct stat'.
 */
#cmakedefine HAVE_STRUCT_STAT_ST_MTIM 1

/*
 * Defined if `st_mtimensec' is a member of `struct stat'.
 */
#cmakedefine HAVE_STRUCT_STAT_ST_MTIMENSEC 1

/*
 * Set if compiler has __builtin_XXX methods.
 */
#cmakedefine HAVE_BUILTIN_CTZ 1
#cmakedefine HAVE_BUILTIN_CTZLL 1
#cmakedefine HAVE_BUILTIN_CLZ 1
#cmakedefine HAVE_BUILTIN_CLZLL 1
#cmakedefine HAVE_BUILTIN_POPCOUNT 1
#cmakedefine HAVE_BUILTIN_POPCOUNTLL 1
#cmakedefine HAVE_BUILTIN_BSWAP32 1
#cmakedefine HAVE_BUILTIN_BSWAP64 1
#cmakedefine HAVE_FFSL 1
#cmakedefine HAVE_FFSLL 1

/*
 * pthread have problems with -std=c99
 */
#cmakedefine HAVE_NON_C99_PTHREAD_H 1

#cmakedefine ENABLE_BUNDLED_LIBEV 1
#cmakedefine ENABLE_BUNDLED_LIBEIO 1
#cmakedefine ENABLE_BUNDLED_LIBCORO 1

#cmakedefine HAVE_PTHREAD_YIELD 1
#cmakedefine HAVE_SCHED_YIELD 1
#cmakedefine HAVE_POSIX_FADVISE 1
#cmakedefine HAVE_FALLOCATE 1
#cmakedefine HAVE_MREMAP 1
#cmakedefine HAVE_SYNC_FILE_RANGE 1

#cmakedefine HAVE_MSG_NOSIGNAL 1
#cmakedefine HAVE_SO_NOSIGPIPE 1

#cmakedefine HAVE_PRCTL_H 1

#cmakedefine HAVE_UUIDGEN 1
#cmakedefine HAVE_CLOCK_GETTIME 1
#cmakedefine HAVE_CLOCK_GETTIME_DECL 1

/** pthread_np.h - non-portable stuff */
#cmakedefine HAVE_PTHREAD_NP_H 1
/** pthread_setname_np(pthread_self(), "") - Linux */
#cmakedefine HAVE_PTHREAD_SETNAME_NP 1
/** pthread_setname_np("") - OSX */
#cmakedefine HAVE_PTHREAD_SETNAME_NP_1 1
/** pthread_set_name_np(pthread_self(), "") - *BSD */
#cmakedefine HAVE_PTHREAD_SET_NAME_NP 1

#cmakedefine HAVE_PTHREAD_GETATTR_NP 1
#cmakedefine HAVE_PTHREAD_ATTR_GET_NP 1

#cmakedefine HAVE_PTHREAD_GET_STACKSIZE_NP 1
#cmakedefine HAVE_PTHREAD_GET_STACKADDR_NP 1

#cmakedefine HAVE_SETPROCTITLE 1
#cmakedefine HAVE_SETPROGNAME 1
#cmakedefine HAVE_GETPROGNAME 1

/*
 * Defined if ICU library has ucol_strcollUTF8 method.
 */
#cmakedefine HAVE_ICU_STRCOLLUTF8 1

/*
* Defined if notifications on NOTIFY_SOCKET are enabled
 */
#cmakedefine WITH_NOTIFY_SOCKET 1

/** \cond public */

/** System configuration dir (e.g /etc) */
#define SYSCONF_DIR "@CMAKE_INSTALL_SYSCONFDIR@"
/** Install prefix (e.g. /usr) */
#define INSTALL_PREFIX "@CMAKE_INSTALL_PREFIX@"
/** Build type, e.g. Debug or Release */
#define BUILD_TYPE "@CMAKE_BUILD_TYPE@"
/** CMake build type signature, e.g. Linux-x86_64-Debug */
#define BUILD_INFO "@TARANTOOL_BUILD@"
/** Command line used to run CMake */
#define BUILD_OPTIONS "cmake . @TARANTOOL_OPTIONS@"
/** Pathes to C and CXX compilers */
#define COMPILER_INFO "@CMAKE_C_COMPILER@ @CMAKE_CXX_COMPILER@"
/** C compile flags used to build Tarantool */
#define TARANTOOL_C_FLAGS "@TARANTOOL_C_FLAGS@"
/** CXX compile flags used to build Tarantool */
#define TARANTOOL_CXX_FLAGS "@TARANTOOL_CXX_FLAGS@"

/** A path to install *.lua module files */
#define MODULE_LIBDIR "@MODULE_FULL_LIBDIR@"
/** A path to install *.so / *.dylib module files */
#define MODULE_LUADIR "@MODULE_FULL_LUADIR@"
/** A path to Lua includes (the same directory where this file is contained) */
#define MODULE_INCLUDEDIR "@MODULE_FULL_INCLUDEDIR@"
/** A constant added to package.path in Lua to find *.lua module files */
#define MODULE_LUAPATH "@MODULE_LUAPATH@"
/** A constant added to package.cpath in Lua to find *.so module files */
#define MODULE_LIBPATH "@MODULE_LIBPATH@"
/** Shared library suffix - ".so" on Linux, ".dylib" on Mac */
#define MODULE_LIBSUFFIX "@MODULE_LIBSUFFIX@"

/** \endcond public */

#define DEFAULT_CFG_FILENAME "tarantool.cfg"
#define DEFAULT_CFG SYSCONF_DIR "/" DEFAULT_CFG_FILENAME

#cmakedefine ENABLE_ASAN 1

/* Cacheline size to calculate alignments */
#define CACHELINE_SIZE 64

#cmakedefine ENABLE_FEEDBACK_DAEMON 1

/*
 * vim: syntax=c
 */
#endif /* TARANTOOL_CONFIG_H_INCLUDED */
