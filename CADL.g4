grammar CADL;

tokens {
}

@header {
  String.prototype.times = function(n) { return (n > 0) ? Array.prototype.join.call({length:n+1}, this) : ""; };
}

@members {
	this.svar_table = new Object();
	this.vvar_table = new Object();
	this.func_table = new Object();
	this.func_level = 0;
	this.line_no = 0;
	this.indent_level = 0;
	this.indent_str = "  ";
	this.line_indent = function() { return this.indent_str.times(this.indent_level); };
	this.indent = function(s) { return this.line_indent()+s; };
	this.indentN = function(s,n) { return this.indent_str.times(n)+s; };
	//this.indent = function(s) { return s.replace("@", this.line_indent()); };
	this.z_msb = 63;
	this.z_lsb = 0;
	this.y_msb = 63;
	this.y_lsb = 0;
	this.x_msb = 63;
	this.x_lsb = 0;
	this.value = 0;
	this.pfx   ="u_";
	this.pfxu   ="u_";
	this.gf = {'a': "", 'A':"", 'o': "<", 'O':"<", 'd':"(", 'D':"(", 'h':"[", 'H':"[", 'w': "{", 'W':"{"};

	this.sprintf  = require("sprintf-js").sprintf;
	this.vsprintf = require("sprintf-js").vsprintf;
	this.print = console.log;
}

program
			: (definition {this.print($definition.r_codes+"\n");}
			   | comments {}
			   | evaluation {this.print($evaluation.r_codes+"\n");}
			   )*
			;

comments
    : SLINE_COMMENTS
    | MLINE_COMMENTS
    ;

evaluation returns [var r_codes]
    : KEYWD_EVAL output_stmt SEMICOLON
      {
		var str;
        if (this.func_level > 0) {
		  str = this.indent($output_stmt.r_codes+";");
        } else {
          str = "\nlet _= " + $output_stmt.r_codes + ((this.func_level > 0) ? ";" : ";;");
        }
		$r_codes = str;
      }
     | KEYWD_EVAL print_stmt  SEMICOLON
      {
		var str;
        str = "\nlet _= " + $print_stmt.r_codes + ((this.func_level > 0) ? ";" : ";;");
		$r_codes = str;
      }
    ;

definition returns [var r_codes]
@init {var str = ""; var tmp = ""}
@after {$r_codes = str;}
			: svar_def
			  {
				  tmp = $svar_def.r_codes;
				  tmp = tmp.replace(/;\s*$/g, '');
				  str = tmp+((this.func_level > 0) ? " in\n" : ";;");
			  }
			| mvar_def
			  {
				  tmp = $mvar_def.r_codes;
				  tmp = tmp.replace(/;\s*$/g, '');
				  str = tmp+((this.func_level > 0) ? " in\n" : ";;");
			  }
			| mvar_set
			  {
				  str = $mvar_set.r_codes+"\n";
			  }
			| func_def 
			  {
				  tmp = $func_def.r_codes;
				  tmp = tmp.replace(/;\s*$/g, '');
				  str= tmp+((this.func_level > 0) ? " in\n" : ";;");
			  }
			;

svar_def returns [var r_codes]
@after {$r_codes = this.indent($r_codes);}
	:	KEYWD_LET SVAR_ID ASSIGN svar_expr SEMICOLON  {$r_codes = this.indent("let "+this.pfx+$SVAR_ID.text+" = "+$svar_expr.r_codes+";");}
	|	KEYWD_LET SVAR_ID ASSIGN block_stmt SEMICOLON  {$r_codes = this.indent("let "+this.pfx+$SVAR_ID.text+" = "+$block_stmt.r_codes+";");}
	|	INPUT LPARENT SVAR_ID LPARENT SEMICOLON {$r_codes = this.indent("let "+this.pfx+$SVAR_ID.text+' = cInputSvar "'+$SVAR_ID.text+'";');}
	;

svar_expr returns [var r_codes]
	: fst=svar_expr MULGF snd=svar_expr {$r_codes = $fst.r_codes+" *^"+this.gf['o']+" "+$snd.r_codes;}
	| fst=svar_expr MUL snd=svar_expr   {$r_codes = $fst.r_codes+" * "+$snd.r_codes;}
	| fst=svar_expr DIV snd=svar_expr   {$r_codes = $fst.r_codes+" / "+$snd.r_codes;}
	| fst=svar_expr MOD snd=svar_expr   {$r_codes = $fst.r_codes+" mod "+$snd.r_codes;}
	| fst=svar_expr ADD snd=svar_expr   {$r_codes = $fst.r_codes+" + "+$snd.r_codes;}
	| fst=svar_expr SUB snd=svar_expr   {$r_codes = $fst.r_codes+" - "+$snd.r_codes;}
	| fst=svar_expr EQ  snd=svar_expr   {$r_codes = $fst.r_codes+" == "+$snd.r_codes;}
	| fst=svar_expr NE  snd=svar_expr   {$r_codes = $fst.r_codes+" != "+$snd.r_codes;}
	| fst=svar_expr LT  snd=svar_expr   {$r_codes = $fst.r_codes+" < "+$snd.r_codes;}
	| fst=svar_expr LE  snd=svar_expr   {$r_codes = $fst.r_codes+" <= "+$snd.r_codes;}
	| fst=svar_expr GE  snd=svar_expr   {$r_codes = $fst.r_codes+" >= "+$snd.r_codes;}
	| fst=svar_expr GT  snd=svar_expr   {$r_codes = $fst.r_codes+" > "+$snd.r_codes;}
	| fst=svar_expr LS   snd=svar_expr  {$r_codes = $fst.r_codes+" lsl "+$snd.r_codes;}
	| fst=svar_expr RS   snd=svar_expr  {$r_codes = $fst.r_codes+" lsr "+$snd.r_codes;}
	| fst=svar_expr BAND snd=svar_expr  {$r_codes = $fst.r_codes+" land "+$snd.r_codes;}
	| fst=svar_expr BOR  snd=svar_expr  {$r_codes = $fst.r_codes+" lor "+$snd.r_codes;}
	| fst=svar_expr BXOR snd=svar_expr  {$r_codes = $fst.r_codes+" lxor "+$snd.r_codes;}
	| <assoc=right> BNOT fst=svar_expr  {$r_codes = "~"+$fst.r_codes;}
	| fst=svar_expr LAND snd=svar_expr  {$r_codes = $fst.r_codes+" && "+$snd.r_codes;}
	| fst=svar_expr LOR  snd=svar_expr  {$r_codes = $fst.r_codes+" || "+$snd.r_codes;}
	| <assoc=right> LNOT fst=svar_expr  {$r_codes = "(not "+$fst.r_codes+")";}
	| LPARENT fst=svar_expr RPARENT     {$r_codes = "("+$fst.r_codes+")";}
	| SVAR_ID                           {$r_codes = this.pfx+$SVAR_ID.text;}
	| mvar_item_single                  {$r_codes = $mvar_item_single.r_codes;}
	| mvar_dimension                    {$r_codes = $mvar_dimension.r_codes;}
	| svar_func_ref                     {$r_codes = $svar_func_ref.r_codes;}
	| constant                          {$r_codes = $constant.r_codes;}
	;

mvar_def returns [var r_codes]
@after {$r_codes = this.indent($r_codes);}
	:	KEYWD_LET MVAR_ID ASSIGN mvar_expr SEMICOLON  {$r_codes = "let "+this.pfx+$MVAR_ID.text+" = "+$mvar_expr.r_codes+";";}
	|	KEYWD_LET MVAR_ID ASSIGN block_stmt SEMICOLON  {$r_codes = "let "+this.pfx+$MVAR_ID.text+" = "+$block_stmt.r_codes+";";}
	|	INPUT LPARENT MVAR_ID LPARENT SEMICOLON {$r_codes = "let "+this.pfx+$MVAR_ID.text+' = cInputMvar "'+$MVAR_ID.text+'";';}
	;

mvar_set returns [var r_codes]
@after {$r_codes = this.indent($r_codes);}
	:	KEYWD_SET m=mvar_item_single {$r_codes = this.pfx+$m.name+".("+$m.x_msb+").("+$m.y_msb+")";}
	    ASSIGN {$r_codes += " <- ";}
		svar_expr {$r_codes += $svar_expr.r_codes;}
		(SEMICOLON {$r_codes += ";";})?
	;

mvar_dimension returns [var r_codes]
    : MVAR_ID MVAR_X { $r_codes = "(cX "+this.pfx+$MVAR_ID.text+")"; }
    | MVAR_ID MVAR_Y { $r_codes = "(cY "+this.pfx+$MVAR_ID.text+")"; }
    | MVAR_ID MVAR_Z { $r_codes = "(cZ "+this.pfx+$MVAR_ID.text+")"; }
    ;

mvar_item_single returns [var r_codes, var name, var x_msb, var x_lsb, var y_msb, var y_lsb, var z_msb, var z_lsb]
@init {$r_codes = "";}
    : MVAR_ID LBRACKET x=svar_expr COMMA y=svar_expr COMMA z=var_item_range RBRACKET
      {
        $name  = $MVAR_ID.text;
        $x_msb = $x.r_codes;
        $x_lsb = $x_msb;
        $y_msb = $y.r_codes;
        $y_lsb = $y_msb;
        $z_msb = $z.msb;
        $z_lsb = $z.lsb;
        $r_codes = "(cMatrixSingle "+this.pfx+$name+" ("+$x_msb+", "+$y_msb+", "+$z_msb+", "+$z_lsb+"))";
      }
    ;

var_expr returns [var r_codes]
    : svar_expr {$r_codes = $svar_expr.r_codes;}
    | mvar_expr {$r_codes = $mvar_expr.r_codes;}
    ;
mvar_func_ref returns [var r_codes]
    : name=MFUNC_ID {$r_codes = "("+this.pfxu+$name.text;}
      LPARENT {$r_codes += " ";}
      arg0=var_expr {$r_codes += "("+$arg0.r_codes+")";}
      (COMMA arg=var_expr {$r_codes += " ("+$arg.r_codes+")";})*
      RPARENT {$r_codes += ")";}
    | name=MFUNC_ID LPARENT RPARENT {$r_codes = "("+this.pfx+$name.text+" ())";}
    ;

svar_func_ref returns [var r_codes]
    : name=SFUNC_ID {$r_codes = "("+this.pfxu+$name.text;}
      LPARENT {$r_codes += " ";}
      arg0=var_expr {$r_codes += "("+$arg0.r_codes+")";}
      (COMMA arg=var_expr {$r_codes += " ("+$arg.r_codes+")";})*
      RPARENT {$r_codes += ")";}
    | name=SFUNC_ID LPARENT RPARENT {$r_codes = "("+this.pfx+$name.text+" ())";}
    ;
mvar_item_block returns [var r_codes, var name, var x_msb, var x_lsb, var y_msb, var y_lsb, var z_msb, var z_lsb]
@init {$r_codes = "";}
    : MVAR_ID LBRACKET x=var_item_range COMMA y=var_item_range COMMA z=var_item_range RBRACKET
      {
        $name  = $MVAR_ID.text;
        $x_msb = $x.msb;
        $x_lsb = $x.lsb;
        $y_msb = $y.msb;
        $y_lsb = $y.lsb;
        $z_msb = $z.msb;
        $z_lsb = $z.lsb;
        $r_codes = "(cMatrixBlock "+this.pfx+$name+" ("+$x_msb+", "+$x_lsb+", "+$y_msb+", "+$y_lsb+", "+$z_msb+", "+$z_lsb+"))";
      }
    ;

mvar_item_list returns [var r_codes, var name, var x_msb, var x_lsb, var y_msb, var y_lsb, var z_msb, var z_lsb]
    @init {$r_codes = "";}
    @after {
              var i, j;
              if ($x_msb > $x_lsb) {
                for (i=$x_msb; i>=$x_lsb; i--) {
                  if ($y_msb > $y_lsb) {
                    for (j=$y_msb; j>=$y_lsb; j--) {
                      $r_codes += this.pfx+$name+".("+i+").("+j+"); ";
                    }
                  } else {
                    for (j=$y_msb; j<=$y_lsb; j++) {
                      $r_codes += this.pfx+$name+".("+i+").("+j+"); ";
                    }
                  }
                }
              } else {
				for (i=$x_lsb; i<=$x_lsb; i++) {
                  if ($y_msb > $y_lsb) {
                    for (j=$y_msb; j>=$y_lsb; j--) {
                      $r_codes += this.pfx+$name+".("+i+").("+j+"); ";
                    }
                  } else {
                    for (j=$y_msb; j<=$y_lsb; j++) {
                      $r_codes += this.pfx+$name+".("+i+").("+j+"); ";
                    }
                  }
                }
			  }
			  var str  = $r_codes.replace(/;\s*$/g, '');
			  $r_codes = str;
            }
        : MVAR_ID LBRACKET x=var_item_fromto COMMA y=var_item_fromto COMMA z=var_item_range RBRACKET
          {
            $name  = $MVAR_ID.text;
            $x_msb = $x.msb;
            $x_lsb = $x.lsb;
            $y_msb = $y.msb;
            $y_lsb = $y.lsb;
            $z_msb = $z.msb;
            $z_lsb = $z.lsb;
          }
        ;

svar_list returns [var r_codes, var name, var x_msb var_x_lsb, var y_msb, var y_lsb, var z_msb, var z_lsb]
@init  {$r_codes = "[|"; }
@after {
          var str = $r_codes.replace(/;\s*$/g, '');
          $r_codes = str+"|]";
        }
    :(
       s=svar_expr {$r_codes += $svar_expr.r_codes+"; ";}
       | l=mvar_item_list {$r_codes += $l.r_codes+"; ";}
     )
     (
       COMMA
       (s=svar_expr {$r_codes += $svar_expr.r_codes+"; ";}
       | l=mvar_item_list {$r_codes += $l.r_codes+"; ";})
     )*
    ;

mvar_expr returns [var r_codes, var name, var x_msb, var x_lsb, var y_msb, var y_lsb, var z_msb, var z_lsb]
@init { name = ""; x_msb=x_lsb=y_msb=y_lsb=z_msb=z_lsb=-1;}
	: fst=mvar_expr SMMULGF snd=mvar_expr          {$r_codes = $fst.r_codes+" *-^ "+$snd.r_codes;}
	| fst=mvar_expr MULGF snd=mvar_expr            {$r_codes = $fst.r_codes+" *|^ "+$snd.r_codes;}
	| fst=mvar_expr MMMULGF snd=mvar_expr          {$r_codes = $fst.r_codes+" *@^ "+$snd.r_codes;}
	| fst=mvar_expr SMMUL snd=mvar_expr            {$r_codes = $fst.r_codes+" *- "+$snd.r_codes;}
	| fst=mvar_expr MUL snd=mvar_expr              {$r_codes = $fst.r_codes+" *| "+$snd.r_codes;}
	| fst=mvar_expr MMMUL snd=mvar_expr            {$r_codes = $fst.r_codes+" *@ "+$snd.r_codes;}
	| fst=mvar_expr ADD snd=mvar_expr              {$r_codes = $fst.r_codes+" +@ "+$snd.r_codes;}
	| fst=mvar_expr SUB snd=mvar_expr              {$r_codes = $fst.r_codes+" -@ "+$snd.r_codes;}
	| fst=mvar_expr BAND snd=mvar_expr             {$r_codes = $fst.r_codes+" &@ "+$snd.r_codes;}
	| fst=mvar_expr BOR  snd=mvar_expr             {$r_codes = $fst.r_codes+" |@ "+$snd.r_codes;}
	| fst=mvar_expr BXOR snd=mvar_expr             {$r_codes = $fst.r_codes+" ^@ "+$snd.r_codes;}
	| <assoc=right> BNOT  fst=mvar_expr            {$r_codes = "\%~"+$fst.r_codes;}
	| fst=mvar_expr MPERM snd=mvar_expr            {$r_codes = $fst.r_codes+" \%@> "+$snd.r_codes;}
	| fst=mvar_expr MSUBST snd=mvar_expr           {$r_codes = $fst.r_codes+" \%@< "+$snd.r_codes;}
	| fst=mvar_expr MMAP   fn=SFUNC_ID             {$r_codes = $fst.r_codes+" \%@|> "+this.pfx+$fn.text;}
	| fst=mvar_expr MFOLD  fn=SFUNC_ID             {$r_codes = $fst.r_codes+" \%@|< "+this.pfx+$fn.text;}
	| fst=mvar_expr MHCON snd=mvar_expr            {$r_codes = $fst.r_codes+" \%@- "+$snd.r_codes;}
	| fst=mvar_expr MVCON snd=mvar_expr            {$r_codes = $fst.r_codes+" \%@| "+$snd.r_codes;}
	| <assoc=right> MTRAN fst=mvar_expr            {$r_codes = "\%@-|"+$fst.r_codes;}
	| LPARENT fst=mvar_expr RPARENT                {$r_codes = "("+$fst.r_codes+")";}
	| n=MVAR_ID                                    {$r_codes = this.pfx+$n.text;}
	| mvar_func_ref                                {$r_codes = $mvar_func_ref.r_codes;}
	| mvar_item_block                              {$r_codes = $mvar_item_block.r_codes;}
	| MATRIX_T LBRACKET dx=svar_expr COMMA dy=svar_expr COMMA dz=svar_expr RBRACKET '.' LBRACKET v=svar_list RBRACKET
	  {
	    $r_codes = "(cMatrixMake ("+$dx.r_codes+", "+$dy.r_codes+", "+$dz.r_codes+") "+$v.r_codes+")";
	  }
	;

block_stmt returns [var r_codes]
@init  {$r_codes = ""}
//@after {$r_codes = $r_codes.replace(/;\s*\n*$/, '\n');}
    : KEYWD_BEGIN
      (stmt {$r_codes += $stmt.r_codes;})+
      KEYWD_END
    ;

stmt returns [var r_codes]
    : definition   {$r_codes = $definition.r_codes;}
    | ctrl_stmt    {$r_codes = $ctrl_stmt.r_codes;}
    | output_stmt  {$r_codes = $output_stmt.r_codes;}
    | print_stmt   {$r_codes = $print_stmt.r_codes;}
    | if_stmt      {$r_codes = $if_stmt.r_codes;}
    | loop_stmt    {$r_codes = $loop_stmt.r_codes;}
    | svar_expr    {$r_codes = this.indent($svar_expr.r_codes+";\n");}
    | mvar_expr    {$r_codes = this.indent($mvar_expr.r_codes+";\n");}
    | block_stmt   {$r_codes = $block_stmt.r_codes;}
    | SEMICOLON    {$r_codes = this.indent(";;\n");}
    ;

ctrl_stmt returns [var r_codes]
    : KEYWD_BREAK {$r_codes = this.indent("break;\n");}
    ;

output_stmt returns [var r_codes]
    : OUTPUT LPARENT SVAR_ID RPARENT {$r_codes = this.indent("cOutputSvar "+this.pfx+$SVAR_ID.text+' "'+$SVAR_ID.text+'"');}
    | OUTPUT LPARENT MVAR_ID RPARENT {$r_codes = this.indent("cOutputMvar "+this.pfx+$MVAR_ID.text+' "'+$MVAR_ID.text+'"');}
    ;

print_stmt returns [var r_codes]
    : PRINT LPARENT SVAR_ID RPARENT {$r_codes = this.indent("cPrintSvar "+this.pfx+$SVAR_ID.text+' "'+$SVAR_ID.text+'"');}
    | PRINT LPARENT MVAR_ID RPARENT {$r_codes = this.indent("cPrintMvar "+this.pfx+$MVAR_ID.text+' "'+$MVAR_ID.text+'"');}
    ;

if_stmt returns [var r_codes]
@init  {
          $r_codes = "";
          this.indent_level++;
        }
@after {
          this.indent_level--;
        }
    : KEYWD_IF {$r_codes += this.indentN("if ", this.indent_level-1);}
      svar_expr {$r_codes += "("+$svar_expr.r_codes+") then begin\n";}
      ifb=block_stmt {
                         $r_codes += $ifb.r_codes;
                         $r_codes += this.indentN("end\n", this.indent_level-1);
                       }
      (KEYWD_ELSE {
                      $r_codes = $r_codes.replace(/\s*\n$/, "");
                      $r_codes += " else begin\n";
                      //this.indent_level++;
                    }
       elb=block_stmt {
                          $r_codes += $elb.r_codes;
                          //this.indent_level--;
                          $r_codes += this.indentN("end\n", this.indent_level-1);
                        }
       )?
      ;

loop_stmt returns [var r_codes]
@init {this.indent_level++; }
@after {this.indent_level--;}
    : KEYWD_LOOPUP LPARENT SVAR_ID '=' svar_expr RPARENT block_stmt {
                                 $r_codes = this.indentN("for "+this.pfx+$SVAR_ID.text+"=0 to "+$svar_expr.r_codes+" do\n", this.indent_level-1);
                                 $r_codes += $block_stmt.r_codes;
                                 $r_codes += this.indentN("done\n", this.indent_level-1);
                                }
    | KEYWD_LOOPDOWN LPARENT SVAR_ID '=' svar_expr RPARENT block_stmt {
                                 $r_codes = this.indentN("for "+this.pfx+$SVAR_ID.text+"="+$svar_expr.r_codes+" downto 0 do\n", this.indent_level-1);
                                 $r_codes += $block_stmt.r_codes;
                                 $r_codes += this.indentN("done\n", this.indent_level-1);
                                }
    ;

func_def returns [var r_codes]
@init {
        this.func_level++;
        this.indent_level++;
       }
@after{
        this.func_level--;
        this.indent_level--;
       }
	:	KEYWD_LET name=(SFUNC_ID|MFUNC_ID) {$r_codes = "let rec "+this.pfxu+$name.text;}
	    LPARENT {$r_codes += " ";}
	    arg0=(SVAR_ID|MVAR_ID) {$r_codes += this.pfx+$arg0.text;}
	    (COMMA arg=(SVAR_ID|MVAR_ID) {$r_codes += " "+this.pfx+$arg.text;})*
	    RPARENT ASSIGN sts=block_stmt
	    {
	      $r_codes = $r_codes.replace(/\s*,$/g, '');
	      $r_codes += " = begin\n";
	      $r_codes = this.indentN($r_codes, this.indent_level-1);
	      $r_codes += $sts.r_codes;
	      $r_codes += this.indentN("end", this.indent_level-1);
	    }
	|	KEYWD_LET name=(SFUNC_ID|MFUNC_ID) LPARENT RPARENT ASSIGN sts=block_stmt
	    {
	      $r_codes = "let rec "+this.pfxu+$name.text+"() = begin\n";
	      $r_codes = this.indentN($r_codes, this.indent_level-1);
	      $r_codes += $sts.r_codes;
	      $r_codes += this.indentN("end", this.indent_level-1);
	    }
	;

var_item_range returns [var r_codes, var msb, var lsb]
	: imsb=svar_expr RANGE ilsb=svar_expr
	  {
	    $msb = $imsb.r_codes;
	    $lsb = $ilsb.r_codes;
	    $r_codes = $msb+":"+$lsb;
	  }
	;

var_item_fromto returns [var r_codes, var msb, var lsb]
	: imsb=svar_expr FROMTO ilsb=svar_expr
	  {
	    $msb = $imsb.r_codes;
	    $lsb = $ilsb.r_codes;
	    $r_codes = $msb+".."+$lsb;
	  }
	;

constant returns [var r_codes]
			: HEX_LITERAL {$r_codes = $HEX_LITERAL.text}
			| DEC_LITERAL {$r_codes = $DEC_LITERAL.text}
			;

ASSIGN      : '='  ;
RANGE       : ':' ;
FROMTO      : '..' ;
COMMA       : ',' ;
SEMICOLON	: ';'  ;

LPARENT     : '('  ;
RPARENT     : ')'  ;
LBRACKET    : '['  ;
RBRACKET    : ']'  ;
LBRACE      : '{'  ;
RBRACE      : '}'  ;
//LCONCAT     : '{|';
//RCONCAT     : '|}' ;
//MLPARENT     : '(|'  ;
//MRPARENT     : '|)'  ;
NEWLINE 	: ('\r'? '\n')+ -> skip;
WS      	: (' '|'\t')+   ->skip;

ADD         : '+'  ;
SUB         : '-'  ;
MUL         : '*'  ;
MULGF       : '*^';
DIV         : '/'  ;
MOD         : '%'  ;
SMMUL       : '*|' ;
SMMULGF     : '*|^';
MMMUL       : '*@' ;
MMMULGF     : '*@^';

EQ          : '==' ;
NE          : '!=' ;
GT          : '>'  ;
GE          : '>='  ;
LT          : '<'  ;
LE          : '<='  ;

LAND        : '&&'  ;
LOR         : '||'  ;
LNOT        : '!'  ;

BAND        : '&'  ;
BOR         : '|'  ;
BNOT        : '~'  ;
BXOR        : '^'  ;
LS          : '<<'  ;
RS          : '>>'  ;
RLS         : '<<<'  ;

MTRAN       : '@-|' ;
MSUBST      : '@<';
MPERM       : '@>';
MMAP        : '@|>';
MFOLD       : '@|<';
MHCON       : '@-';
MVCON       : '@|';

KEYWD_LET       :	'let';
KEYWD_SET       :	'set';
KEYWD_LOOPDOWN  :	'loopdown';
KEYWD_LOOPUP    :	'loopup';
KEYWD_BREAK     :	'break';
KEYWD_IF        :	'if';
KEYWD_ELSE      :	'else';
KEYWD_EVAL      :	'eval';
KEYWD_BEGIN     :	'begin';
KEYWD_END       :	'end';
//KEYWD_RETURN  :	'return';

INPUT        :	'$input';
OUTPUT       :	'$output';
PRINT        :	'$print';
MATRIX_T     :	'M'|'C';
SVAR_ID      :	'v' (LETTER|DEC_LITERAL)+;
MVAR_ID      :	'V' (LETTER|DEC_LITERAL)+;
MVAR_X       :	'.x';
MVAR_Y       :	'.y';
MVAR_Z       :	'.z';
FUNC_ID      :	'x' (LETTER|DEC_LITERAL)+;
SFUNC_ID     :	'f' (LETTER|DEC_LITERAL)+;
MFUNC_ID     :	'F' (LETTER|DEC_LITERAL)+;

HEX_LITERAL : '0' ('x'|'X') ('0'..'9'|'a'..'f'|'A'..'F')+ ;
DEC_LITERAL : ('0'|'1'..'9' '0'..'9'*) ;
RADIX       : 'a'|'Z'|'o'|'O'|'d'|'D'|'h'|'H';
LETTER	     : 'A'..'Z' | 'a'..'z' | '_';
MLINE_COMMENTS : '/*' .*? '*/'        -> skip;
SLINE_COMMENTS : '//' .*?   NEWLINE  -> skip;
