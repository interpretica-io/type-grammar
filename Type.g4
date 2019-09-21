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
DOUBLECOLON: '::';
COLON:      ':';
ANONYMOUS:  'anonymous';
AT:         'at';

SPEC_SYMBOL
    :   '/'
    |   '-'
    |   '\\'
    |   '.'
    |   '_'
    ;

WS
    : [ \n\t\r]+ -> skip
    ;

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

Location
    : WS AT WS .*?
    ;

Size
    : Digit+
    ;

kind_decoration
    : UNION
    | ENUM
    | STRUCT
    ;

param_list
    : LPAREN type_name (COMMA type_name)* RPAREN
    | LPAREN RPAREN
    ;

anonymous_location_specification
    : LPAREN ANONYMOUS kind_decoration? (Location)? RPAREN
    ;

complete_identifier
    : Identifier
    | complete_identifier DOUBLECOLON complete_identifier
    | anonymous_location_specification
    ;

simple_type
    : kind_decoration? complete_identifier
    ;

prototype_specification
    : LPAREN ASTERISK* complete_identifier? RPAREN
    ;

size_specification
    : LBRACKET Size? RBRACKET
    | LBRACKET complete_identifier RBRACKET
    ;

type_name
    : simple_type (ASTERISK)* prototype_specification? (size_specification)* (param_list)?
    ;
