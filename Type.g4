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
CONST:      'const';
RESTRICT:   'restrict';
VOLATILE:   'volatile';
REGISTER:   'register';
EXTERN:     'extern';
AUTO:       'auto';
UNALIGNED:  '__unaligned';
STATIC:     'static';
UNSIGNED:   'unsigned';
SIGNED:     'signed';

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

WS_NOSKIP
    : [ ]+
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

Size
    : Digit+
    ;

kind_decoration
    : UNION
    | ENUM
    | STRUCT
    ;

modifier
    : STATIC
    | EXTERN
    | AUTO
    | REGISTER
    ;

qualifier
    : CONST
    | RESTRICT
    | VOLATILE
    | UNALIGNED
    ;

const_qualifier
    : CONST
    ;

pre_qualifier
    : qualifier
    ;

post_qualifier
    : CONST
    ;

type_qualifier
    : UNSIGNED
    | SIGNED
    ;

pointer_const
    : ASTERISK+ const_qualifier
    | ASTERISK+
    | const_qualifier
    ;

param_list
    : LPAREN type_name (COMMA type_name)* RPAREN
    | LPAREN RPAREN
    ;

anonymous_location_specification
    : LPAREN ANONYMOUS kind_decoration? (AT .*?)? RPAREN
    ;

complete_identifier
    : Identifier
    | complete_identifier DOUBLECOLON complete_identifier
    | anonymous_location_specification
    ;

simple_type
    : modifier* (pre_qualifier*) kind_decoration? type_qualifier? complete_identifier+ post_qualifier* pointer_const* size_specification*
    ;

size_specification
    : LBRACKET Size? RBRACKET
    | LBRACKET complete_identifier RBRACKET
    ;

full_specification
    : LPAREN pointer_const* complete_identifier? RPAREN size_specification* (param_list)?
    | LPAREN pointer_const* full_specification RPAREN size_specification* (param_list)?
    | complete_identifier? size_specification* param_list
    ;

type_name
    : simple_type full_specification?
    ;
