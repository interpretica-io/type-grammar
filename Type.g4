grammar Type;

UNION:      'union';
ENUM:       'enum';
STRUCT:     'struct';
CLS:        'class';
LPAREN:     '(';
RPAREN:     ')';
LBRACKET:   '[';
RBRACKET:   ']';
ASTERISK:   '*';
REF:        '&';
COMMA:      ',';
DOUBLECOLON: '::';
COLON:      ':';
ANONYMOUS:  'anonymous';
AT:         'at';
CONST:      'const';
RESTRICT:   'restrict';
RESTRICT_:  '__restrict';
VOLATILE:   'volatile';
REGISTER:   'register';
EXTERN:     'extern';
AUTO:       'auto';
UNALIGNED_:  '__unaligned';
STATIC:     'static';
UNSIGNED:   'unsigned';
SIGNED:     'signed';
VARARG:     '...';
LEFT_ANGLE: '<';
RIGHT_ANGLE:'>';
ATOMIC:     '_Atomic';
NS_DELIMITER: '`';
NOEXCEPT_:  'noexcept';

SPECIAL_SYMBOL
    :   '/'
    |   '-'
    |   '\\'
    |   '.'
    |   '_'
    |   '+'
    ;

WS
    : [ \n\t\r]+ -> channel(HIDDEN)
    ;

fragment
IdentifierNondigit
    :   Nondigit
    |   UniversalCharacterName
    ;

fragment
Nondigit
    :   [a-zA-Z_-]
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
    | CLS
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
    | RESTRICT_
    | VOLATILE
    | UNALIGNED_
    | ATOMIC
    ;

const_qualifier
    : CONST
    ;

pre_qualifier
    : qualifier
    ;

post_qualifier
    : CONST
    | RESTRICT_
    ;

type_qualifier
    : UNSIGNED
    | SIGNED
    ;

pointer_const
    : ASTERISK+ const_qualifier
    | ASTERISK+
    | REF+ const_qualifier
    | REF+
    | const_qualifier
    ;

param_list
    : LPAREN type_name (COMMA type_name)* RPAREN
    | LPAREN RPAREN
    ;

anonymous_location_specification
    : LPAREN ANONYMOUS kind_decoration? (AT .*?)? RPAREN
    ;

angled_expression
    : LEFT_ANGLE (.*?) (angled_expression (.*?))* RIGHT_ANGLE
    ;

complete_identifier
    : NS_DELIMITER complete_identifier NS_DELIMITER DOUBLECOLON complete_identifier
    | complete_identifier DOUBLECOLON complete_identifier
    | kind_decoration? Identifier angled_expression?
    | anonymous_location_specification
    ;

pre_type
    : modifier* (pre_qualifier *) kind_decoration? type_qualifier?
    ;

post_type
    : post_qualifier* pointer_const* post_qualifier* size_specification* NOEXCEPT_?
    ;

size_specification
    : LBRACKET Size? RBRACKET
    | LBRACKET complete_identifier RBRACKET
    ;

template_type
    : angled_expression
    ;

class_spec
    : type_name DOUBLECOLON
    ;

pre_simple_type
    : pre_type complete_identifier pointer_const* post_type
    ;

inner
    : class_spec? pointer_const* Identifier? template_type? post_type
    | class_spec? pointer_const* LPAREN inner post_type RPAREN param_list?
    ;

type_name
    : pre_simple_type Identifier? template_type? post_type
    | pre_simple_type complete_identifier param_list post_type
    | pre_simple_type (LPAREN inner RPAREN)? param_list post_type
    | ATOMIC LPAREN type_name RPAREN
    | VARARG
    ;
