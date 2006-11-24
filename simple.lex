<?php # vim:ft=php
include 'jlex.php';

%%

%{
//<YYINITIAL> L? \" (\\.|[^\\\"])* \"	{ $this->createToken(CParser::TK_STRING_LITERAL); }
	/* blah */
%}

%function nextToken
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
	  throw new Exception("bah!");
}
