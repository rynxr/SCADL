# SCADL

This depot includes Symmetric Cryptographic Algorithm Description Language(SCADL) implementation source and evaluation result.

## Environment

### Tool List
+ OS: RedHat Enterprise Linux 6.6 x86
+ GCC: 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC)
+ OCaml: 4.02.1
+ GMP: 4.2.4
+ yices 2.4.1
+ cryptol: 2.2.5
+ boost: 1.59.0
+ cvc4: 1.4

### Tool Installation

#### Pre-install
```
export SCADLDIR = pathToYourInstallation
mkidr -p $SCADLDIR && cd $SCADLDIR
```

#### OCaml
```
cd $SCADLDIR
wget https://raw.githubusercontent.com/ocaml/opam/master/shell/opam_installer.sh
mkdir bin
sh ./opam_installer.sh $SCADLDIR/bin 4.02.1
./bin/opam switch 4.02.1
eval $(./bin/opam config env)
which ocaml
```

#### ncurse
```
wget http://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz
tar -zxvf ncurses-6.0.tar.gz && cd ncurse-6.0
./configure --prefix=$SCADLDIR
make && make install
```

#### GMP
```
cd $SCADLDIR
wget http://ftp.gnu.org/gnu/gmp/gmp-4.2.4.tar.gz
tar -zxvf gmp-4.2.4.tar.gz && cd gmp-4.2.4
./configure --enable-shared=no --prefix=$SCADLDIR
make && make check && make install
```

#### GHC
```
wget https://www.haskell.org/ghc/dist/7.8.4/ghc-7.8.4-i386-unknown-linux-centos65.tar.bz2
tar -jxvf ghc-7.8.4-i386-unknown-linux-centos65.tar.bz2
cd ghc-7.8.4
./configure CPPFLAGS=$SCADLDIR/include LDFLAGS=$SCADLDIR/lib --prefix=$SCADLDIR
make install
```

#### cabal-install
```
wget http://hackage.haskell.org/package/cabal-install-1.22.0.0/cabal-install-1.22.0.0.tar.gz
tar -zxvf cabal-install-1.22.0.0.tar.gz
cd cabal-install-1.22.0.0
```
patch bootstrap.sh `Setup` compilation with following command
```
{GHC} -I$INSTDIR/include -L$INSTDIR/lib --make Setup -o Setup
```

```
PREFIX=$INSTDIR EXTRA_CONFIGURE_OPTS="--extra-include-dirs $INSTDIR/include --extra-lib-dirs $INSTDIR/lib" ./bootstrap.sh
cabal update
export PATH=~/.cabal/bin:$PATH
```

#### cryptol-src
```
cd $SCADLDIR
wget https://github.com/GaloisInc/cryptol/archive/v2.2.5.tar.gz
tar -zxvf v2.2.5.tar.gz && cd cd cryptol-2.2.5
```

#### gperf
```
wget http://ftp.gnu.org/pub/gnu/gperf/gperf-3.0.4.tar.gz
tar -zxvf gperf-3.0.4.tar.gz && cd gperf-3.0.4
./configure --prefix=$SCADLDIR
make && make install
```

#### yices
Get yices-2.4.1-src.tar.gz from http://yices.csl.sri.com/index.html
```
tar -zxvf yices-2.4.1-src.tar.gz && cd yices-2.4.1
./configure CPPFLAGS="-I$SCADLDIR/include" LDFLAGS="-L$SCADLDIR/lib" --prefix=$SCADLDIR
make && make install
```
#### boost
```
cd $SCADLDIR
wget http://superb-dca2.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2
tar -jxvf boost_1_59_0.tar.bz2 && cd boost_1_59_0
./bootstrap.sh --prefix=$SCADLDIR
./b2 link=static --prefix=$SCADLDIR install
```

#### cvc4
```
cd $SCADLDIR
wget http://cvc4.cs.nyu.edu/builds/src/cvc4-1.4.tar.gz
tar -zxvf cvc4-1.4.tar.gz && cd cvc4-1.4
contrib/get-antlr-3.4
./configure --with-antlr-dir=`pwd`/antlr-3.4 ANTLR=`pwd`/antlr-3.4/bin/antlr3 CPPFLAGS="-I$SCADLDIR/include" LDFLAGS="-L$SCADLDIR/lib" --best --enable-gpl --prefix=$SCADLDIR
make && make check && make install
```

#### cryptol-bin
```
cd $SCADLDIR
wget https://github.com/GaloisInc/cryptol/releases/download/v2.2.5/cryptol-2.2.5-CentOS6-32.tar.gz
tar -zxvf cryptol-2.2.5-CentOS6-32.tar.gz
mv cryptol-2.2.5-CentOS6-32/bin/* bin/
mv cryptol-2.2.5-CentOS6-32/share/cryptol share/
mv cryptol-2.2.5-CentOS6-32/share/doc/cryptol share/doc/
```

#### mbedTLS
```
cd $SCADLDIR
wget https://tls.mbed.org/download/mbedtls-2.1.1-apache.tgz
tar -zxvf mbedtls-2.1.1-apache.tgz && cd mbedtls-2.1.1
make DESTDIE=$SCADLDIR
make DESTDIE=$SCADLDIR test
make DESTDIE=$SCADLDIR install
```

#### JDK
```
cd $SCADLDIR
wget http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-8u51-linux-i586.tar.gz
tar -zxvf jdk-8u51-linux-i586.tar.gz
mv jdk1.8.0_51 jdk
```

#### NodeJS
```
cd $SCADLDIR
wget https://nodejs.org/dist/v0.10.33/node-v0.10.33-linux-x86.tar.gz
tar -zxvf node-v0.10.33-linux-x86.tar.gz
mv node-v0.10.33-linux-x86 node
cd node/lib && ../bin/npm install sprintf-js
```

#### ANTLR4
```
mkdir -p $SCADLDIR/antlr && cd $SCADLDIR/antlr
wget wget http://www.antlr.org/download/antlr-4.5.1-complete.jar
mv antlr-4.5.1-complete.jar antlr4.jar
wget http://www.antlr.org/download/antlr-javascript-runtime-4.5.1.zip
unzip antlr-javascript-runtime-4.5.1.zip
../node/bin/npm link antlr4
```

#### CLOC
```
npm install -g cloc
```
Note: npm CLOC latest version is 1.0.4

#### Post-install
1. setup
```
#!/bin/sh
export SCADLDIR=`pwd`
export JDK_HOME=$SCADLDIR/jdk
export NODE_HOME=$SCADLDIR/node
export ANTLR_HOME=$SCADLDIR/antlr
export LD_LIBRARY_PATH=$SCADLDIR/lib
export PATH=$SCADLDIR/bin:$JDK_HOME/bin:$NODE_HOME/bin:$ANTLR_HOME/bin:$PATH
if [ -z $CLASSPATH ]; then
  export CLASSPATH=".:$ANTLR_HOME/antlr4.jar:$CLASSPATH"
else
  export CLASSPATH=".:$ANTLR_HOME/antlr4.jar"
fi
opam switch 4.02.1
eval `opam config env`
alias at4='java -jar $ANTLR_HOME/antlr4.jar'
```

2. validation
```
source setup.sh 
cryptol -v
node -v
ocaml -version
at4
```

## Implementation

### SCADL grammar parser

### SCADL description coverter

### Cipher implementation

## Evaluation

### Usability

### Performance

## References

## ChangeLog

Fri Oct  2 08:28:31 PDT 2015
