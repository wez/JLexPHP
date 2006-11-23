<?php # vim:ft=php
include 'jlex.php';

%%

%{
	/* blah */
%}

%line
%char
%state COMMENTS

ALPHA=[A-Za-z_]
DIGIT=[0-9]
ALPHA_NUMERIC={ALPHA}|{DIGIT}
IDENT={ALPHA}({ALPHA_NUMERIC})*
NUMBER=({DIGIT})+
WHITE_SPACE=([\ \n\r\t\f])+

%%

<YYINITIAL> {NUMBER} { 
	  return $this->createToken();
}
<YYINITIAL> {WHITE_SPACE} { }

<YYINITIAL> "+" { 
	  return $this->createToken();
} 
<YYINITIAL> "-" { 
	  return $this->createToken();
} 
<YYINITIAL> "*" { 
	  return $this->createToken();
} 
<YYINITIAL> "/" { 
	  return $this->createToken();
} 
<YYINITIAL> ";" { 
	  return $this->createToken();
} 
<YYINITIAL> "//" {
	  $this->yybegin(self::COMMENTS);
}
<COMMENTS> [^\n] {
}
<COMMENTS> [\n] {
	  $this->yybegin(self::YYINITIAL);
}
<YYINITIAL> . {
	  return new Symbol(sym.error, null);
}
