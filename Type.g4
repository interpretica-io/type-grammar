grammar Type;

UNION:      'union';
ENUM:       'enum';
STRUCT:     'struct';
LPAREN:     '(';
RPAREN:     ')';
LBRACKET:   '[';
RBRACKET:   ']';
ASTERISK:   '*';
COMMA:      ',';

WS: [ \n\t\r]+ -> skip;

fragment
IdentifierNondigit
    :   Nondigit
    |   UniversalCharacterName
    ;

fragment
Nondigit
    :   [a-zA-Z_]
    ;

fragment
Digit
    :   [0-9]
    ;

fragment
UniversalCharacterName
    :   '\\u' HexQuad
    |   '\\U' HexQuad HexQuad
    ;

fragment
HexQuad
    :   HexadecimalDigit HexadecimalDigit HexadecimalDigit HexadecimalDigit
    ;

fragment
HexadecimalDigit
    :   [0-9a-fA-F]
    ;

Identifier
    :   IdentifierNondigit
        ( IdentifierNondigit
        | Digit
        )*
    ;

Size
    : Digit+
    ;

enum_union_struct
    : UNION
    | ENUM
    | STRUCT
    ;

param_list
    : LPAREN type_name (COMMA type_name)* RPAREN
    | LPAREN RPAREN
    ;

simple_type
    : enum_union_struct? Identifier
    ;

pointer_indirection
    : LPAREN (ASTERISK)+ RPAREN
    ;

size_specification
    : LBRACKET Size? RBRACKET
    ;

type_name
    : simple_type (ASTERISK)* pointer_indirection? (size_specification)* (param_list)?
    ;
