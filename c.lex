<?php # vim:ft=php
include 'jlex.php';
/* This is a lexer for the C language */

class CParser {
	const TK_AUTO = 0;
	const TK_STAR = 1;
	const TK_IDENTIFIER = 2;
	const TK_PRAGMA = 3;
	const TK_TYPEDEF = 4;
}

%%

%{
	/* blah */
%}

%function nextToken
%line
%char
%state COMMENT
%class CLexer

D	=	[0-9]
L	=	[a-zA-Z_]
H	=	[a-fA-F0-9]
E	=	[Ee][+-]?{D}+
FS	=	(f|F|l|L)
IS	=	(u|U|l|L)

%%

<YYINITIAL> "/*"			{ $this->yybegin(self::COMMENT); }
<YYINITIAL> "//[^\r\n]*"    { /* C++ comment */ }

<COMMENT>   "*/"            { $this->yybegin(self::YYINITIAL); }
<COMMENT>   [.\n]           { }

<YYINITIAL> #[^\r\n]*       { return $this->createToken(CParser::TK_PRAGMA); }

<YYINITIAL> "auto"			{ return $this->createToken(CParser::TK_AUTO); }
<YYINITIAL> "break"			{ return $this->createToken(CParser::TK_BREAK); }
<YYINITIAL> "case"			{ return $this->createToken(CParser::TK_CASE); }
<YYINITIAL> "char"			{ return $this->createToken(CParser::TK_CHAR); }
<YYINITIAL> "const"			{ return $this->createToken(CParser::TK_CONST); }
<YYINITIAL> "continue"		{ return $this->createToken(CParser::TK_CONTINUE); }
<YYINITIAL> "default"		{ return $this->createToken(CParser::TK_DEFAULT); }
<YYINITIAL> "do"			{ return $this->createToken(CParser::TK_DO); }
<YYINITIAL> "double"		{ return $this->createToken(CParser::TK_DOUBLE); }
<YYINITIAL> "else"			{ return $this->createToken(CParser::TK_ELSE); }
<YYINITIAL> "enum"			{ return $this->createToken(CParser::TK_ENUM); }
<YYINITIAL> "extern"		{ return $this->createToken(CParser::TK_EXTERN); }
<YYINITIAL> "float"			{ return $this->createToken(CParser::TK_FLOAT); }
<YYINITIAL> "for"			{ return $this->createToken(CParser::TK_FOR); }
<YYINITIAL> "goto"			{ return $this->createToken(CParser::TK_GOTO); }
<YYINITIAL> "if"			{ return $this->createToken(CParser::TK_IF); }
<YYINITIAL> "int"			{ return $this->createToken(CParser::TK_INT); }
<YYINITIAL> "long"			{ return $this->createToken(CParser::TK_LONG); }
<YYINITIAL> "register"		{ return $this->createToken(CParser::TK_REGISTER); }
<YYINITIAL> "return"		{ return $this->createToken(CParser::TK_RETURN); }
<YYINITIAL> "short"			{ return $this->createToken(CParser::TK_SHORT); }
<YYINITIAL> "signed"		{ return $this->createToken(CParser::TK_SIGNED); }
<YYINITIAL> "sizeof"		{ return $this->createToken(CParser::TK_SIZEOF); }
<YYINITIAL> "static"		{ return $this->createToken(CParser::TK_STATIC); }
<YYINITIAL> "struct"		{ return $this->createToken(CParser::TK_STRUCT); }
<YYINITIAL> "switch"		{ return $this->createToken(CParser::TK_SWITCH); }
<YYINITIAL> "typedef"		{ return $this->createToken(CParser::TK_TYPEDEF); }
<YYINITIAL> "union"			{ return $this->createToken(CParser::TK_UNION); }
<YYINITIAL> "unsigned"		{ return $this->createToken(CParser::TK_UNSIGNED); }
<YYINITIAL> "void"			{ return $this->createToken(CParser::TK_VOID); }
<YYINITIAL> "volatile"		{ return $this->createToken(CParser::TK_VOLATILE); }
<YYINITIAL> "while"			{ return $this->createToken(CParser::TK_WHILE); }

<YYINITIAL> {L}({L}|{D})*		{ return $this->createToken(CParser::TK_IDENTIFIER); }

<YYINITIAL> 0[xX]{H}+{IS}?		{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> 0{D}+{IS}?		{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> {D}+{IS}?		{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> L?\'(\\.|[^\\\'])+\'	{ return $this->createToken(CParser::TK_CONSTANT); }

<YYINITIAL> {D}+{E}{FS}?		{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> {D}*"."{D}+({E})?{FS}?	{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> {D}+"."{D}*({E})?{FS}?	{ return $this->createToken(CParser::TK_CONSTANT); }

<YYINITIAL> L?\"(\\.|[^\\\"])*\" 	{ return $this->createToken(CParser::TK_STRING_LITERAL); }

<YYINITIAL> "..."			{ return $this->createToken(CParser::TK_ELLIPSIS); }
<YYINITIAL> ">>="			{ return $this->createToken(CParser::TK_RIGHT_ASSIGN); }
<YYINITIAL> "<<="			{ return $this->createToken(CParser::TK_LEFT_ASSIGN); }
<YYINITIAL> "+="			{ return $this->createToken(CParser::TK_ADD_ASSIGN); }
<YYINITIAL> "-="			{ return $this->createToken(CParser::TK_SUB_ASSIGN); }
<YYINITIAL> "*="			{ return $this->createToken(CParser::TK_MUL_ASSIGN); }
<YYINITIAL> "/="			{ return $this->createToken(CParser::TK_DIV_ASSIGN); }
<YYINITIAL> "%="			{ return $this->createToken(CParser::TK_MOD_ASSIGN); }
<YYINITIAL> "&="			{ return $this->createToken(CParser::TK_AND_ASSIGN); }
<YYINITIAL> "^="			{ return $this->createToken(CParser::TK_XOR_ASSIGN); }
<YYINITIAL> "|="			{ return $this->createToken(CParser::TK_OR_ASSIGN); }
<YYINITIAL> ">>"			{ return $this->createToken(CParser::TK_RIGHT_OP); }
<YYINITIAL> "<<"			{ return $this->createToken(CParser::TK_LEFT_OP); }
<YYINITIAL> "++"			{ return $this->createToken(CParser::TK_INC_OP); }
<YYINITIAL> "--"			{ return $this->createToken(CParser::TK_DEC_OP); }
<YYINITIAL> "->"			{ return $this->createToken(CParser::TK_PTR_OP); }
<YYINITIAL> "&&"			{ return $this->createToken(CParser::TK_AND_OP); }
<YYINITIAL> "||"			{ return $this->createToken(CParser::TK_OR_OP); }
<YYINITIAL> "<="			{ return $this->createToken(CParser::TK_LE_OP); }
<YYINITIAL> ">="			{ return $this->createToken(CParser::TK_GE_OP); }
<YYINITIAL> "=="			{ return $this->createToken(CParser::TK_EQ_OP); }
<YYINITIAL> "!="			{ return $this->createToken(CParser::TK_NE_OP); }
<YYINITIAL> ";"			{ return $this->createToken(CParser::TK_SEMIC); }
<YYINITIAL> ("{"|"<%")		{ return $this->createToken(CParser::TK_LCURLY); }
<YYINITIAL> ("}"|"%>")		{ return $this->createToken(CParser::TK_RCURLY); }
<YYINITIAL> ","			{ return $this->createToken(CParser::TK_COMMA); }
<YYINITIAL> ":"			{ return $this->createToken(CParser::TK_COLON); }
<YYINITIAL> "="			{ return $this->createToken(CParser::TK_EQUALS); }
<YYINITIAL> "("			{ return $this->createToken(CParser::TK_LPAREN); }
<YYINITIAL> ")"			{ return $this->createToken(CParser::TK_RPAREN); }
<YYINITIAL> ("["|"<:")		{ return $this->createToken(CParser::TK_LSQUARE); }
<YYINITIAL> ("]"|":>")		{ return $this->createToken(CParser::TK_RSQUARE); }
<YYINITIAL> "."			{ return $this->createToken(CParser::TK_PERIOD); }
<YYINITIAL> "&"			{ return $this->createToken(CParser::TK_AMP); }
<YYINITIAL> "!"			{ return $this->createToken(CParser::TK_EXCLAM); }
<YYINITIAL> "~"			{ return $this->createToken(CParser::TK_TILDE); }
<YYINITIAL> "-"			{ return $this->createToken(CParser::TK_MINUS); }
<YYINITIAL> "+"			{ return $this->createToken(CParser::TK_PLUS); }
<YYINITIAL> "*"			{ return $this->createToken(CParser::TK_STAR); }
<YYINITIAL> "/"			{ return $this->createToken(CParser::TK_SLASH); }
<YYINITIAL> "%"			{ return $this->createToken(CParser::TK_PERCENT); }
<YYINITIAL> "<"			{ return $this->createToken(CParser::TK_LANGLE); }
<YYINITIAL> ">"			{ return $this->createToken(CParser::TK_RANGLE); }
<YYINITIAL> "^"			{ return $this->createToken(CParser::TK_CARET); }
<YYINITIAL> "|"			{ return $this->createToken(CParser::TK_PIPE); }
<YYINITIAL> "?"			{ return $this->createToken(CParser::TK_QUESTION); }

<YYINITIAL> [ \t\v\n\f] { }
.			{ /* ignore bad characters */ }

