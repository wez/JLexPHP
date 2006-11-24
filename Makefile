
all: JLexPHP.jar simple.lex.php c.lex.php

simple.lex.php: simple.lex JLexPHP.jar
	java -cp JLexPHP.jar JLexPHP.Main simple.lex
	test -s simple.lex.php || rm simple.lex.php

c.lex.php: c.lex JLexPHP.jar
	java -cp JLexPHP.jar JLexPHP.Main c.lex
	test -s c.lex.php || rm c.lex.php

JLexPHP.jar: JLexPHP/Main.java
	javac JLexPHP/Main.java
	jar cvf JLexPHP.jar JLexPHP/*.class

clean:
	rm JLexPHP/*.class *.jar

