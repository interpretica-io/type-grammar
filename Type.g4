grammar Type;

fragment
IdentifierNondigit
    :   Nondigit
    |   UniversalCharacterName
    //|   // other implementation-defined characters...
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
Star
    :   '*'
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

EnumUnionStruct
    : 'union'
    | 'enum'
    | 'struct'
    ;

StarPointer
    : Star
    ;

StarIndirection
    : Star
    ;

param_list
    : type_name (',' type_name)*
    ;

type_name
    : EnumUnionStruct? Identifier StarPointer* ('(' (StarIndirection)* ')')? ('[' Size? ']')* (param_list)
    ;
