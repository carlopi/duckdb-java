.PHONY: build test clean

SEP=
JARS=

ifeq ($(OS),Windows_NT)
	# windows is weird
	SEP=";"
	JARS=build/release
else
	SEP=":"
	JARS=build/release
endif

ARCH_OVERRIDE=
ifneq ($(OVERRIDE_JDBC_OS_ARCH),)
	ARCH_OVERRIDE=-DOVERRIDE_JDBC_OS_ARCH=$(OVERRIDE_JDBC_OS_ARCH)
endif


GENERATOR=
ifeq ($(GEN),ninja)
	GENERATOR=-G "Ninja"
	FORCE_COLOR=-DFORCE_COLORED_OUTPUT=1
endif

JAR=$(JARS)/duckdb_jdbc.jar
TEST_JAR=$(JARS)/duckdb_jdbc_tests.jar
CP=$(JAR)$(SEP)$(TEST_JAR)

test: 
	java -cp $(CP) org.duckdb.TestDuckDBJDBC

release:
	mkdir -p build/release
	cd build/release && cmake -DCMAKE_BUILD_TYPE=Release $(GENERATOR) $(ARCH_OVERRIDE) ../.. && cmake --build . --config Release

clean:
	rm -rf build