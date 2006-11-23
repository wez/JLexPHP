
all: simple-lex.php

simple.lex.php: simple.lex JLexPHP.jar
	java -cp JLexPHP.jar JLexPHP.Main simple.lex

JLexPHP.jar: JLexPHP/Main.java
	javac JLexPHP/Main.java
	jar cvf JLexPHP.jar JLexPHP/*.class

clean:
	rm JLexPHP/*.class *.jar

