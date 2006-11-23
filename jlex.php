<?php # vim:ts=2:sw=2:et:

class JLexToken {
  public $line;
  public $col;
  public $value;
  public $type;

  function __construct($type, $value = null, $line = null, $col = null) {
    $this->line = $line;
    $this->col = $col;
    $this->value = $value;
    $this->type = $type;
  }
}

class JLexBase {
  protected $yy_reader;
  protected $yy_buffer;
  protected $yy_buffer_read;
  protected $yy_buffer_index;
  protected $yy_buffer_start;
  protected $yy_buffer_end;
  protected $yychar = 0;
  protected $yyline = 0;
  protected $yy_at_bol;
  protected $yy_lexical_state;
  protected $yy_last_was_cr = false;
  protected $yy_count_lines = false;
  protected $yy_count_chars = false;
  protected $yyfilename = null;

  const YY_E_INTERNAL = 0;
  const YY_E_MATCH = 1;

  function __construct($stream) {
    $this->yy_reader = $stream;
    $meta = stream_get_meta_data($stream);
    $this->yyfilename = $meta['uri'];

    $this->yy_buffer = "";
    $this->yy_buffer_read = 0;
    $this->yy_buffer_index = 0;
    $this->yy_buffer_start = 0;
    $this->yy_buffer_end = 0;
    $this->yychar = 0;
    $this->yyline = 0;
    $this->yy_at_bol = true;

    $this->yy_build_tables();
  }

  protected function yybegin($state) {
    $this->yy_lexical_state = $state;
  }

  protected function yy_advance() {
    if ($this->yy_buffer_index < $this->yy_buffer_read) {
      return $this->yy_buffer[$this->yy_buffer_index++];
    }
    if ($this->yy_buffer_start != 0) {
      /* shunt */
      $j = $this->yy_buffer_read - $this->yy_buffer_start;
      $this->yy_buffer = substr($this->yy_buffer, $this->yy_buffer_start, $j);
      $this->yy_buffer_end -= $this->yy_buffer_start;
      $this->yy_buffer_start = 0;
      $this->yy_buffer_read = $j;
      $this->yy_buffer_index = $j;

      $data = fread($this->yy_reader, 8192);
      $this->yy_buffer .= $data;
      $this->yy_buffer_read .= strlen($data);
    }

    while ($this->yy_buffer_index >= $this->yy_buffer_read) {
      $data = fread($this->yy_reader, 8192);
      $this->yy_buffer .= $data;
      $this->yy_buffer_read .= strlen($data);
    }
    return $this->yy_buffer[$this->yy_buffer_index++];
  }

  protected function yy_move_end() {
    if ($this->yy_buffer_end > $this->yy_buffer_start &&
        $this->yy_buffer[$this->yy_buffer_end-1] == "\n")
      $this->yy_buffer_end--;
    if ($this->yy_buffer_end > $this->yy_buffer_start &&
        $this->yy_buffer[$this->yy_buffer_end-1] == "\r")
      $this->yy_buffer_end--;
  }

  protected function yy_mark_start() {
    if ($this->yy_count_lines || $this->yy_count_chars) {
      if ($this->yy_count_lines) {
        for ($i = $this->yy_buffer_start; $i < $this->yy_buffer_index; ++$i) {
          if ("\n" == $this->yy_buffer[$i] && !$this->yy_last_was_cr) {
            ++$this->yyline;
          }
          if ("\r" == $this->yy_buffer[$i]) {
            ++$yyline;
            $this->yy_last_was_cr = true;
          } else {
            $this->yy_last_was_cr = false;
          }
        }
      }
      if ($this->yy_count_chars) {
        $this->yychar += $this->yy_buffer_index - $this->yy_buffer_start;
      }
      $this->yy_buffer_start = $this->yy_buffer_index;
    }
  }

  protected function yy_mark_end() {
    $this->yy_buffer_end = $this->yy_buffer_index;
  }

  protected function yy_to_mark() {
    $this->yy_buffer_index = $this->yy_buffer_end;
    $this->yy_at_bol = ($this->yy_buffer_end > $this->yy_buffer_start) &&
                ("\r" == $this->yy_buffer[$this->yy_buffer_end-1] ||
                 "\n" == $this->yy_buffer[$this->yy_buffer_end-1] ||
                 2028/*LS*/ == $this->yy_buffer[$this->yy_buffer_end-1] ||
                 2029/*PS*/ == $this->yy_buffer[$this->yy_buffer_end-1]);
  }

  protected function yytext() {
    return substr($this->yy_buffer, $this->yy_buffer_start, 
          $this->yy_buffer_end - $this->yy_buffer_start);
  }

  protected function yylength() {
    return $this->yy_buffer_end - $this->yy_buffer_start;
  }

  static $yy_error_string = array(
    "Error: internal error.\n",
    "Error: Unmatched input.\n"
  );

  protected function yy_error($code, $fatal) {
    print self::$yy_error_string[$code];
    flush();
    if ($fatal) throw new Exception("JLex fatal error " . self::$yy_error_string[$code]);
  }

  protected function /* int[][] */ unpackFromString($size1, $size2, $st) {
    $colonIndex = -1;
    $lengthString = 0;
    $sequenceLength = 0;
    $sequenceInteger = 0;
    $commaIndex = 0;

    $res = array();

    for ($i = 0; $i < $size1; $i++) {
      for ($j= 0; $j < $size2; $j++) {
        if ($sequenceLength != 0) {
          $res[$i][$j] = $sequenceInteger;
          $sequenceLength--;
          continue;
        }
        $commaIndex = strpos($st, ","); //st.indexOf(',');
        $workString = ($commaIndex===false) ? $st :
          substr($st, 0, $commaIndex);
        $st = substr($st, $commaIndex+1);
        $colonIndex = strpos($workString, ':');
        if ($colonIndex === false) {
          $res[$i][$j]=(int)$workString;
          continue;
        }
        $lengthString = substr($workString, $colonIndex+1);
        $sequenceLength = (int)lengthString;
        $workString = substr($workString, 0, $colonIndex);
        $sequenceInteger = (int)$workString;
        $res[$i][$j] = $sequenceInteger;
        $sequenceLength--;
      }
    }
    return $res;
  }

  /* creates an annotated token */
  function createToken($type = null) {
    if ($type === null) $type = $this->yytext();
    $tok = new JLexToken($type);
    $this->annotateToken($tok);
    return $tok;
  }

  /* annotates a token with a value and source positioning */
  function annotateToken(JLexToken $tok) {
    $tok->value = $this->yytext();
    $tok->col = $this->yychar;
    $tok->line = $this->yyline;
    $tok->filename = $this->yyfilename;
  }
}

