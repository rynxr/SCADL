#!/bin/bash

# The project directory tree
#prj
# |--jdk-32  (JDK)
# |--node-32 (NodeJS
# |--at4     (Antlr4 JavaScript runtime)
# |--cadlc   (CADL compiler)
# Please refer to README.md for tools and libraries info.

# Note: Please change following path before sourcing...
export OS_BITS=32
export CADL_HOME=<path_to_your_prj_home>
export JAVA_HOME=$CADL_HOME/jdk-$OS_BITS
export NODEJS_HOME=$CADL_HOME/node-$OS_BITS
export ANTLR_HOME=$CADL_HOME/at4
export OPAM_HOME=<path_to_your_opam_bin>
export CRYTOL_HOME=<path_to_your_cryptol_installation>
export MBEDTLS_HOME=<path_to_your_mbedTLS_installation>

export PATH="$JAVA_HOME/bin:$NODEJS_HOME/bin:$CRYTOL_HOME/bin:$PATH"
if [ -z $CLASSPATH ]
then
	export CLASSPATH=".:$ANTLR_HOME/antlr-4.5.1-complete.jar:$CLASSPATH"
else
	export CLASSPATH=".:$ANTLR_HOME/antlr-4.5.1-complete.jar"
fi

$OPAM_HOME/opam switch 4.02.1 > /dev/null
eval `$OPAM_HOME/opam config env`

alias at4="java -jar $ANTLR_HOME/antlr-4.5.1-complete.jar"
alias at4g="java org.antlr.v4.gui.TestRig"
