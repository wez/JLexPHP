<?php
include 'c.lex.php';
error_reporting(E_ALL);
$L = new CLexer(popen('gcc -E /usr/include/err.h', 'r'));;

while ($t = $L->nextToken()) {
	print_r($t);
}

