%{
// This part goes directly into the generated parser

#include "scanner.hh"
#include "parser.tab.hh"

// YY_DECL is bound to the type of the scanner. The default is 
// #define YY_DECL int Scanner::yylex()
// which is generated anyway.

//If you want the type of the generated scanner to be different, do this

#undef  YY_DECL
#define YY_DECL int IPL::Scanner::yylex( IPL::Parser::semantic_type * const lval, IPL::Parser::location_type *location )

//We want these to be the first action after a token is recognized. 

#define YY_USER_ACTION loc->step(); loc->columns(yyleng);

// token_type is a short hand for IPL::Parser::token

#define token_type IPL::Parser::token

%}


/* %option debug */
%option nodefault
%option yyclass="Scanner"
%option noyywrap
%option c++

%x IN_COMMENT

%%

%{ /** Code executed at the beginning of yylex **/

      yylval = lval;

%}

[ \t]                             //skip
struct                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::STRUCT;
}
void                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::VOID;
}
int                                         {
       yylval->emplace< std::string >(YYText() );
       return token_type::INT;
}
float                                       {
       yylval->emplace< std::string >(YYText() );
       return token_type::FLOAT;
}
while                                       {
       yylval->emplace< std::string >(YYText() );
       return token_type::WHILE;
}
for                                         {
       yylval->emplace< std::string >(YYText() );
       return token_type::FOR;
}
if                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::IF;
}
else                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::ELSE;
}
return                                       {
       yylval->emplace< std::string >(YYText() );
       return token_type::RETURN;
}
([[:alpha:]]|_)[[:alnum:]_]*                {
       yylval->emplace< std::string >( YYText() );
       return token_type::IDENTIFIER;
}
[1-9][0-9]*|0[bB][01]*|0[0-7]*|0[xX][0-9a-fA-F]*  {
       yylval->emplace< std::string >( YYText() );
       return token_type::INT_CONSTANT;
}

[0-9]*([0-9]\.?|\.[0-9])[0-9]*(([Ee][-+]?[0-9]+)?)  {
       yylval->emplace< std::string >( YYText() );
       return token_type::FLOAT_CONSTANT;
}

\"([^\\\"]|\\.)*\"                          {
       yylval->emplace< std::string >( YYText() );
       return token_type::STRING_LITERAL;
}



 
"||"                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::OR_OP;
}
"&&"                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::AND_OP;
}
"=="                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::EQ_OP;
}
"!="                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::NE_OP;
}
"<="                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::LE_OP;
}
">="                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::GE_OP;
}
"++"                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::INC_OP;
}
"->"                                        {
       yylval->emplace< std::string >(YYText() );
       return token_type::PTR_OP;
}
"<"                                         return '<';
">"                                         return '>';
"+"                                         return '+';
"-"                                         return '-';
"*"                                         return '*';
"/"                                         return '/';
","                                         return ',';
"("                                         return '(';
")"                                         return ')';
"{"                                         return '{';
"}"                                         return '}';
"!"                                         return '!';
"&"                                         return '&';
";"                                         return ';';
"="                                         return '=';
"["                                         return '[';
"]"                                         return ']';
"."                                         return '.';    
"\n"          
<<EOF>>         yyterminate();
<INITIAL>{
       "/*"                 BEGIN(IN_COMMENT);
}
<IN_COMMENT>{
       "*/"                 BEGIN(INITIAL);
       [^*\n]+              // eat comment in chunks
       "*"                  // eat the lone star
       \n                   yylineno++;
}
.				              {
       yylval->emplace< std::string >(YYText() );
       return token_type::OTHERS;
}



%%

