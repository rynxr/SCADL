GRAM       = CADL
ANTLR_PATH = ${ANTLR_HOME}/antlr-4.5.1-complete.jar
RHINO_PATH =
#RHINO_PATH = <path_to_rhino_js_jar: this is legacy>
CP         = ',;$(ANTLR_PATH);${CLASSPATH}'
A4         = java -jar ${ANTLR_PATH}
A4R        = java -cp $(CP) org.antlr.v4.gui.TestRig
JSR        = node
#JSR        = java -jar ${RHINO_PATH}
JS         ?= 1
ifeq ($(JS),1)
LAN        = JavaScript
else
LAN        = Java
endif
INPUT      = $(GRAM).input
OUTPUT     = $(GRAM).output
TOPRULE    = program
DBGRULE    ?= debug
OUTPUT_D   ?= gen
OPTS       = -o $(OUTPUT_D) -visitor

.PHONY: all gen bld build run tst dbg clean bld mbedtls
all:
	@echo "INFO: please specify a target..."

gen:
	@$(A4) -Dlanguage=$(LAN) $(OPTS) $(GRAM).g4

run: gen
	@$(JSR) $(GRAM).js | tee > cadlProg.ml

#@dos2unix cadlProg.ml > /dev/null 2>&1

bld:
	@ocamlc -c cadlLib.ml
	@ocamlc -c cadlProg.ml
	@ocamlc -o cadlTest cadlLib.cmo cadlProg.cmo

build: run bld

tst: run
	@-rm -f cadlTest *.cmo
	@ocamlc -c cadlLib.ml
	@ocamlc -c cadlProg.ml
	@ocamlc -o cadlTest cadlLib.cmo cadlProg.cmo
	./cadlTest

mbedtls: mbedtls_clean AES_mbedtls DES_mbedtls RC4_mbedtls

AES_mbedtls: AES_mbedtls.c
	@gcc -I${MBEDTLS_HOME}/include -L${MBEDTLS_HOME}/lib -o $@ $^ -lmbedcrypto

DES_mbedtls: DES_mbedtls.c
	@gcc -I${MBEDTLS_HOME}/include -L${MBEDTLS_HOME}/lib -o $@ $^ -lmbedcrypto

RC4_mbedtls: RC4_mbedtls.c
	@gcc -I${MBEDTLS_HOME}/include -L${MBEDTLS_HOME}/lib -o $@ $^ -lmbedcrypto


dbg: gen
	@$(A4)  $(OPTS) $(GRAM).g4
	@javac -cp $(CP) gen/*.java
	@$(A4R) $(GRAM) $(DBGRULE) -tokens -tree -gui $(GRAM).input &

cadl_clean:
	@-rm -f cadlTest *.cmo *.cmi *_cadl.log *_patched.cad
	@-rm -rf cadlProg.ml gen *Lexer* *Listener* *Parser* *Visitor* *tokens

cryptol_clean:
	@-rm -f *_cryptol.log

mbedtls_clean:
	@-rm -f *_mbedtls.log
	@-rm -rf *_mbedtls *_mbedtls.log

clean: cryptol_clean cadl_clean mbedtls_clean
	@-rm -rf *.log
