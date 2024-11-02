PLT Lab 1 Test Suite
====================

Programming Language Technology (PLT, Chalmers DAT151, University of Gothenburg DIT231)

This is the Test for PLT lab 1: Engineering a BNFC grammar for a fragment of C++.

Prerequisites
-------------

To run this testsuite, recent versions of the following Haskell tools need to be installed.

- [Haskell Stack](https://docs.haskellstack.org/en/stable/), e.g. version 3.1.1
- [GHC](https://www.haskell.org/ghc/) version 9.4.8
- [BNFC](https://bnfc.digitalgrammars.com/), e.g. version 2.9.5
- [Alex](https://haskell-alex.readthedocs.io/en/stable/)
- [Happy](https://haskell-happy.readthedocs.io/en/stable/)

These tools need to be in the [`PATH`](https://en.wikipedia.org/wiki/PATH_(variable))
in your [command shell](https://en.wikipedia.org/wiki/Shell_(computing)).

Running the testsuite
---------------------

Invoke the test runner with the path to your `.cf` BNFC grammar file:
```
stack run -- path/to/your/file.cf
```

**NOTE:** The start category (entry point) of your grammar must be called `Program`.

Installing the prerequisites
----------------------------

Here is a suggestion how to install the prerequisites, if needed.

First install [GHCup](https://www.haskell.org/ghcup/).
Then use it to install Stack and GHC.
```
ghcup install stack latest
ghcup install ghc 9.4.8
```
If needed, add to your system `PATH` the location where GHCup installs tools.

Finally, use Stack to install the remaining tools.
```
stack install alex happy BNFC
```
If needed, add to your system `PATH` the location where Stack installs tools.

Verify that these tools are working by querying their version:
```
stack --version
ghc   --version
bnfc  --version
alex  --version
happy --version
```
