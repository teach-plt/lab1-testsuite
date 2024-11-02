# Andreas, 2014-01-19 Makefile for lab1 testsuite

.PHONY: suite
suite : lab1-testsuite.tar.gz

lab1-testsuite.tar.gz : build-tarball.sh plt-test-lab1.cabal plt-test-lab1.hs Makefile-test good/*.cc bad/*.cc
	./build-tarball.sh

.PHONY: test
test: test-stack test-cabal

.PHONY: test-cabal
test-cabal:
	cabal build all

.PHONY: test-stack
test-stack:
	stack build

# EOF
