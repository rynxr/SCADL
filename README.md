# SCADL

This depot includes Symmetric Cryptographic Algorithm Description Language(SCADL) implementation source and evaluation results.

SCADL is a Domain Specific Language to accelerate symmetric cipher explorations by enabling ciphers designers draw a cipher algorithm based on its data flow.

## Environment

### Tool List
+ OS: RedHat Enterprise Linux 6.6 x86
+ GCC: 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC)
+ OCaml: 4.02.1
+ cryptol: 2.2.5

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

#### cryptol
```
cd $SCADLDIR
wget https://github.com/GaloisInc/cryptol/archive/v2.2.5.tar.gz
tar -zxvf v2.2.5.tar.gz && cd cd cryptol-2.2.5
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

### SCADL description coverter

Please refer to CADL.js and gen.

### Cipher implementation

Please refer to ciphers for DES/AES/RC4 SCADL implementations.

## Evaluation

### Completeness

A publice **Turning Machine** is implemented purely in SCADL implementation which indicates it's **Turing Completeness**.

It proves SCADL can handle problems if they are computable.

Pleaser refer to eval/turing_completeness for more details.

### Usability

Effective code line number is chosen for implementation complexity metric.

Pleaser refer to eval/complexity_results.txt for more details.

### Performance

The SCADL implementations for DES/AES-128/RC4 encryption are run on linux server with settings as:

|Env |Settings|
|:--:|:-------|
|OS|RedHat Enterprise Linux 6.6 final, x86|
|Hardware|CPU(X2):Xeon E5-2690 3GHz, RAM: 8GB|
|OCamle Compiler|ocamlopt 4.2.01|
|C Compiler|gcc 4.4.7|
|Crypto|2.2.5|
|mbed TLS|2.1.1|

And all tool and library compilations are with default compiler flags.

Pleaser refer to eval/performance_results.txt for more details.

## License

This project is free for edcution and research.

Welcome your requirments and suggestions.

JLR <ary.xsnow@gmail.com>

## References

## ChangeLog

Mon Nov 21 06:05:03 PST 2016

1. Update Turing Machine Model
2. Minor updates of CADL.g4 

Fri Oct  2 08:28:31 PDT 2015

1. Initial version
