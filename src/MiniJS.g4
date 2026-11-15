lexer grammar MiniJS;

tokens {
    STRING,
    TEMPLATE_STRING,
    BLOCK_COMMENT,
    UNTERMINATED_COMMENT,
    UNTERMINATED_STRING,
    UNTERMINATED_TEMPLATE
}


Break      : 'break' ;          Case     : 'case' ;      Catch    : 'catch' ;
Class      : 'class' ;          Const    : 'const' ;     Continue : 'continue' ;
Default    : 'default' ;        Delete   : 'delete' ;    Do       : 'do' ;
Else       : 'else' ;           Export   : 'export' ;    Extends  : 'extends' ;
Finally    : 'finally' ;        For      : 'for' ;       Function : 'function' ;
If         : 'if' ;             Import   : 'import' ;    In       : 'in' ;
Instanceof : 'instanceof' ;     New    : 'new' ;         Return   : 'return' ;
Super      : 'super' ;          Switch   : 'switch' ;    This     : 'this' ;
Throw      : 'throw' ;          Try      : 'try' ;       Typeof   : 'typeof' ;
Var        : 'var' ;            Void     : 'void' ;      While    : 'while' ;
Await     : 'await' ;           Debugger  : 'debugger' ; Enum      : 'enum' ;
With      : 'with' ;            Yield     : 'yield' ;    Let        : 'let' ;
Boolean  : 'true' | 'false' ;   NULL      : 'null';



Identifier : [a-zA-Z_$][a-zA-Z0-9_$]* ;


Assign       : '=' ;   Equals          : '==' ;   StrictEquals    : '===' ;
Not          : '!' ;   NotEquals       : '!=' ;   StrictNotEquals : '!==' ;
Lt           : '<' ;   Gt              : '>' ;    Le              : '<=' ;     Ge : '>=' ;
Plus         : '+' ;   Minus           : '-' ;    Multiply        : '*' ;      Divide : '/' ;
Mod          : '%' ;   And             : '&&' ;   Or              : '||' ;     Increment : '++' ;
Decrement    : '--' ;  BitAnd          : '&' ;    BitOr           : '|' ;      BitXor : '^' ;
BitNot       : '~' ;   Shl             : '<<' ;   Shr             : '>>' ;     Ushr : '>>>' ;
PlusAssign   : '+=' ;  MinusAssign     : '-=' ;

Exponentiation       : '**' ;
ExponentiationAssign : '**=' ;

MultiplyAssign : '*=' ;
DivideAssign   : '/=' ;
ModAssign      : '%=' ;

BitAndAssign : '&=' ;
BitOrAssign  : '|=' ;
BitXorAssign : '^=' ;

ShlAssign  : '<<=' ;
ShrAssign  : '>>=' ;
UshrAssign : '>>>=' ;

AndAssign : '&&=' ;
OrAssign  : '||=' ;

NullishCoalescing : '??' ;
NullishAssign     : '??=' ;

OptionalChaining : '?.' ;
Arrow            : '=>' ;

OpenParen    : '(' ;   CloseParen      : ')' ;    OpenBracket     : '[' ;      CloseBracket : ']' ;
OpenBrace    : '{' ;   CloseBrace     : '}' ;
SemiColon    : ';' ;   Comma           : ',' ;    Dot             : '.' ;      Ellipsis : '...' ;
Question     : '?' ;   Colon           : ':' ;


BIGINT
    : ('0' [xX] [0-9a-fA-F]+
      | '0' [oO] [0-7]+
      | '0' [bB] [01]+
      | '0'
      | [1-9] [0-9]*)
      'n'
    ;


HEX_NUMBER   : '0' [xX] [0-9a-fA-F]+ ;
OCTAL_NUMBER : '0' [oO] [0-7]+ ;
INVALID_OCTAL_NUMBER
    : '0' [oO] [0-9a-zA-Z_$]*
    ;
BINARY_NUMBER: '0' [bB] [01]+ ;
INVALID_BINARY_NUMBER
    : '0' [bB] [0-9a-zA-Z_$]*
    ;

FLOAT
    : [0-9]+ '.' [0-9]* ([eE] [+-]? [0-9]+)?
    | '.' [0-9]+ ([eE] [+-]? [0-9]+)?
    | [0-9]+ [eE] [+-]? [0-9]+
    ;
INVALID_EXPONENT
    : ([0-9]+ ('.' [0-9]*)? | '.' [0-9]+)
      [eE] [+-]?
    ;
INTEGER      : [0-9]+ ;
INVALID_HEX_NUMBER
    : '0' [xX] [a-zA-Z0-9_$]*
    ;
INVALID_NUMBER_SUFFIX
    : [0-9]+ [a-zA-Z_$] [a-zA-Z0-9_$]*
    ;

LINE_COMMENT
    : '//' ~[\r\n]*
    ;

BLOCK_COMMENT_START : '/*' -> more, mode(BLOCK_COMMENT_MODE);
STRING_START_DOUBLE : '"'  -> more, mode(STR_DOUBLE_MODE) ;
STRING_START_SINGLE : '\'' -> more, mode(STR_SINGLE_MODE) ;
TEMPLATE_START      : '`'  -> more, mode(TEMPLATE_MODE) ;

WS           : [ \t\r\n]+ -> skip ;

ERROR_TOKEN  : . ;


mode STR_DOUBLE_MODE;

    STR_DOUBLE_LINE_CONT
        : '\\' ('\r\n' | '\n' | '\r') -> more
        ;

    STR_DOUBLE_ESCAPE
        : '\\' . -> more
        ;

    STR_DOUBLE_TEXT
        : ~["\\\r\n] -> more
        ;

    UNTERMINATED_STR_D
        : ('\r\n' | '\n' | '\r')
          -> type(UNTERMINATED_STRING), mode(DEFAULT_MODE)
        ;

    EOF_IN_STR_D
        : EOF -> type(UNTERMINATED_STRING), mode(DEFAULT_MODE)
        ;
    STRING_END_DOUBLE
        : '"' -> type(STRING), mode(DEFAULT_MODE)
        ;


mode STR_SINGLE_MODE;

    STR_SINGLE_LINE_CONT
        : '\\' ('\r\n' | '\n' | '\r') -> more
        ;

    STR_SINGLE_ESCAPE
        : '\\' . -> more
        ;

    STR_SINGLE_TEXT
        : ~['\\\r\n] -> more
        ;

    UNTERMINATED_STR_S
        : ('\r\n' | '\n' | '\r')
          -> type(UNTERMINATED_STRING), mode(DEFAULT_MODE)
        ;

    EOF_IN_STR_S
        : EOF -> type(UNTERMINATED_STRING), mode(DEFAULT_MODE)
        ;

    STRING_END_SINGLE
        : '\'' -> type(STRING), mode(DEFAULT_MODE)
        ;


mode TEMPLATE_MODE;

    TEMPLATE_ESCAPE
        : '\\' . -> more
        ;

    TEMPLATE_TEXT
        : ~[`\\] -> more
        ;

    EOF_IN_TEMPLATE
        : EOF -> type(UNTERMINATED_TEMPLATE), mode(DEFAULT_MODE)
        ;

    TEMPLATE_END
        : '`' -> type(TEMPLATE_STRING), mode(DEFAULT_MODE)
        ;

    mode BLOCK_COMMENT_MODE;

    BLOCK_COMMENT_END
        : '*/' -> type(BLOCK_COMMENT), mode(DEFAULT_MODE)
        ;

    BLOCK_COMMENT_TEXT
        : . -> more
        ;

    EOF_IN_BLOCK
        : EOF -> type(UNTERMINATED_COMMENT), mode(DEFAULT_MODE)
        ;