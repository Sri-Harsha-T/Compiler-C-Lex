%skeleton "lalr1.cc"
%require "3.5"

%defines
%define api.namespace {IPL}
%define api.parser.class {Parser}

%define parse.trace
 %define api.location.type {IPL::location}

%code requires {
    #include "symbtab.hh"
    #include "ast.hh"
    #include "type.hh"
    #include "location.hh"
    namespace IPL{
        class Scanner;
    }


}

%printer {std::cerr << $$; } STRUCT
%printer {std::cerr << $$; } IDENTIFIER
%printer {std::cerr << $$; } VOID
%printer {std::cerr << $$; } INT
%printer {std::cerr << $$; } FLOAT
%printer {std::cerr << $$; } INT_CONSTANT
%printer {std::cerr << $$; } FLOAT_CONSTANT
%printer {std::cerr << $$; } STRING_LITERAL
%printer {std::cerr << $$; } OR_OP
%printer {std::cerr << $$; } AND_OP
%printer {std::cerr << $$; } EQ_OP
%printer {std::cerr << $$; } NE_OP
%printer {std::cerr << $$; } GE_OP
%printer {std::cerr << $$; } LE_OP
%printer {std::cerr << $$; } INC_OP
%printer {std::cerr << $$; } PTR_OP
%printer {std::cerr << $$; } WHILE
%printer {std::cerr << $$; } FOR
%printer {std::cerr << $$; } IF
%printer {std::cerr << $$; } ELSE
%printer {std::cerr << $$; } RETURN


%parse-param {Scanner &scanner } 
%locations
%code{
    #include <iostream>
    #include <cstdlib>
    #include <fstream>
    #include <string>
    #include <sstream>


    #include "scanner.hh"

    #undef yylex
    #define yylex IPL::Parser::scanner.yylex

    // # ifndef YY_NULLPTR
    // #  if defined __cplusplus && 201103L <= __cplusplus
    // #   define YY_NULLPTR nullptr
    // #  else
    // #   define YY_NULLPTR 0
    // #  endif
    // # endif
    // std::string a;

    extern SymTab gst;
    std::map<std::string, abstract_astnode*> ast;
    SymTab* st;
    SymTabEntry* ste;
    std::string currStruct;
    int currStructSize;
    bool structdef;
    int offset;
    bool funcdef;

    extern std::map<std::string, datatype> predefined;
    vector<datatype*> param_type_list;
    std::string f_type_name;
    std::stringstream dump_buff;
    std::string f_ret_type;

    // class type_specifier_class;
    // class declarator_class;
    // class declaration_class;
    // class declarator_list_class;
    // class declaration_list_class;
    // class fun_declarator_class;
    // class parameter_list_class;
    // class parameter_declaration_class;


    // class abstract_astnode;
    // class exp_astnode;
    // class statement_astnode;
    // class assignS_astnode;
    // class seq_astnode;
    // class assignE_astnode;
    // class op_unary_astnode;
    // class funcall_astnode;

    // class intconstant_astnode;
    // class floatconstant_astnode;    

    // struct globalST gst;
    // class localST;
    // extern enum basic_type;

}



%define api.value.type variant
%define parse.assert

%start translation_unit

%token '\n'
%token <std::string> STRUCT OTHERS
%token <std::string> IDENTIFIER
%token <std::string> VOID 
%token <std::string> INT 
%token <std::string> FLOAT
%token <std::string> INT_CONSTANT
%token <std::string> FLOAT_CONSTANT
%token <std::string> STRING_LITERAL
%token <std::string> OR_OP
%token <std::string> AND_OP
%token <std::string> EQ_OP
%token <std::string> NE_OP
%token <std::string> GE_OP
%token <std::string> LE_OP
%token <std::string> INC_OP
%token <std::string> PTR_OP
%token <std::string> WHILE
%token <std::string> FOR
%token <std::string> IF
%token <std::string> ELSE
%token <std::string> RETURN

%token '<' '>' '+' '-' '*' '/' '=' ',' ';' '(' ')' '[' ']' '{' '}' '!' '&'

/* add left associativity rules for - and + and also precedence rules */
%nonassoc '='
%left OR_OP
%left AND_OP
%left EQ_OP NE_OP
%left '<' LE_OP
%left '>' GE_OP
%left '+' '-'
%left '*' '/'
%right '&'
%right USTAR
%right UMINUS
%left PTR_OP
%left '.'
%left INC_OP

%%

%nterm <abstract_astnode*> translation_unit;
%nterm <abstract_astnode*> struct_specifier;
%nterm <abstract_astnode*> function_definition;

%nterm <type_specifier_class*> type_specifier;
%nterm <declarator_class*> declarator_arr;
%nterm <declarator_class*> declarator;
%nterm <declaration_class*> declaration;
%nterm <declarator_list_class*> declarator_list;
%nterm <declaration_list_class*> declaration_list;

%nterm <fun_declarator_class*> fun_declarator;
%nterm <parameter_list_class*> parameter_list;
%nterm <parameter_declaration_class*> parameter_declaration;
%nterm <exp_astnode*> expression;
%nterm <statement_astnode*> statement;
%nterm <assignS_astnode*> assignment_statement;

%nterm <abstract_astnode*> compound_statement;
%nterm <seq_astnode*> statement_list;
%nterm <assignE_astnode*> assignment_expression;
/* %nterm <op_unary_astnode*> unary_operator; */
%nterm <std::string> unary_operator;
%nterm <exp_astnode*> logical_and_expression;
%nterm <exp_astnode*> equality_expression;
%nterm <exp_astnode*> relational_expression;
%nterm <exp_astnode*> additive_expression;
%nterm <exp_astnode*> multiplicative_expression;
%nterm <exp_astnode*> unary_expression;
%nterm <exp_astnode*> postfix_expression;
%nterm <exp_astnode*> primary_expression;
/* %nterm <funcall_astnode*> expression_list; */
%nterm <proccall_astnode*> procedure_call;
%nterm <proccall_astnode*> expression_list;
%nterm <statement_astnode*> selection_statement;
%nterm <statement_astnode*> iteration_statement;

translation_unit:

    struct_specifier
    {
        

    }

    | function_definition
    {
        
    }

    | translation_unit struct_specifier
    {
        
    }

    | translation_unit function_definition
    {
        
    }
    ;

struct_specifier:
    STRUCT IDENTIFIER
    {
        currStruct = "struct " + $2;
        if(gst.lookup(currStruct)){
            std::string err = ""+ currStruct + " has a previous declaration";
            error(@$, err);
        }
        st = new SymTab();
        currStructSize = 0;
        structdef = true;
        offset = 0;
    }
    '{' declaration_list '}' ';'
    {
        currStruct = "";
        structdef = false;
        offset = 0;
        gst.push("struct " + $2, new SymTabEntry("struct", "global", currStructSize, 0, "-", st));
        currStructSize = 0;
        st = NULL;
    }
    ;

function_definition:
    type_specifier 
    {
        f_type_name = $1->type.type_name;
        // gst.push($2->name, new SymTabEntry("fun", "global", $1->type.type_name, st));
    }
    fun_declarator compound_statement
    {
        funcdef = false;
        offset = 0;
        

        ast.insert({$3->name, $4});
        // param_type_list.clear();
        param_type_list = {};
        // gst.Entries[$2->name].stptr = st;
        st = NULL;
        f_type_name = "";

    }
    ;

type_specifier:
    VOID
    {
        $$ = new type_specifier_class(createtype(VOID_TYPE));
    }

    | INT
    {
        $$ = new type_specifier_class(createtype(INT_TYPE));
    }

    | FLOAT
    {
        $$ = new type_specifier_class(createtype(FLOAT_TYPE));
    }
    | STRUCT IDENTIFIER
    {
        
        //TODO: update global symbol table
        $$ = new type_specifier_class();
        $$->type.type_name = "struct " + $2;
        $$->type.size = gst.get_struct_size($$->type.type_name);
    }
    ;

fun_declarator:
    IDENTIFIER '(' parameter_list ')'
    {
        if(gst.lookup($1)){
            std::string err = "Function "+ $1+ " has a previous definition";
            error(@$, err);
        }
        $$ = new fun_declarator_class($1, $3);
        funcdef = true;
        st = new SymTab();
        gst.push($1, new SymTabEntry("fun", "global", f_type_name, st));
        
        unsigned int n = $3->parameter_list.size();
        //std::vector<SymTabEntry*> se = {};
        for(unsigned int i = 0; i<n; i++){
            std::string type_name = "";
            
            if($3->parameter_list[i]->declarator->type!=NULL){
                type_name = $3->parameter_list[i]->declarator->type->type_name;
            }
            
           
            param_type_list.push_back(new datatype(type_name));
        }  
        for(int i = n-1; i>=0; i--){
            std::string type_name = "";
            
            if($3->parameter_list[i]->declarator->type!=NULL){
                type_name = $3->parameter_list[i]->declarator->type->type_name;
            }

            int sz = calculate_size($3->parameter_list[i]->type_specifier, $3->parameter_list[i]->declarator);
            st->push_param($3->parameter_list[i]->declarator->name, new SymTabEntry("var", "param", sz,0, type_name));

        }    
        gst.Entries[$1].set_param_list(param_type_list);
        
    }

    | IDENTIFIER '(' ')'
    {
        $$ = new fun_declarator_class($1, NULL);
        funcdef = true;
        st = new SymTab();
        gst.push($1, new SymTabEntry("fun", "global", f_type_name, st));
    }
    ;

parameter_list:
    parameter_declaration
    {
        std::vector<parameter_declaration_class*> v;
        v.push_back($1);
        $$ = new parameter_list_class(v);
    }

    | parameter_list ',' parameter_declaration
    {
        $1->parameter_list.push_back($3);
        $$ = $1;
    }
    ;

parameter_declaration:
    type_specifier declarator
    {
        if($1->type.type_name=="void"&&$2->type->n_stars<1){
            std::string err = "Cannot declare simple void variable";
            error(@$, err);
        }
        $$ = new parameter_declaration_class($1, $2);
        // $$->declarator->type.type = $1->type.type + $2->type.type;
        // $$->declarator->type.size = $1->type.size * $2->type.size;
    }
    ;

declarator_arr:
    IDENTIFIER
    {
        $$ = new declarator_class();
        $$->name = $1;
        // $$->type = NULL;
        $$->type = new datatype();
    }
    | declarator_arr '[' INT_CONSTANT ']'
    {
        // std::string type_str = $1->type.type;
        // std::string new_type_str = type_str + "[+" + $3 + "+]";
        // $1->type.type = new_type_str;
        // $1->type.size *= std::stoi($3);
        // $$ = $1;
        $$ = $1;
        datatype* oldtype = $$->type;
        // $$->type = new datatype();
        std::string old_type_name = "";
        if(oldtype!=NULL){
            old_type_name = oldtype->type_name;
            // $$->type->n_arr_boxes = oldtype->n_arr_boxes;
            // $$->type->n_stars = oldtype->n_stars;
        }
        int oldsize = 1;
        if(oldtype!=NULL){
            oldsize = oldtype->size;
        }
        // std::vector<int> a_s;
        // if(oldtype!=NULL){
        //     a_s = oldtype->arr_sizes;
        // }
        // $$->type->next = oldtype;
        old_type_name = old_type_name + "[" + $3 + "]";
        oldsize = oldsize * std::stoi($3);
        // a_s.push_back(std::stoi($3));
        // $$->type->arr_sizes = a_s;
        // $$->type->arr_sizes.push_back(std::stoi($3));
        // $$->type->n_arr_boxes++;
        $$->type = new datatype(old_type_name, oldsize);
        
    }
    ;

declarator:
    declarator_arr
    {
        $$ = $1;
    }
    | '*' declarator
    {
        // $2->type.type = "*" + $2->type.type;
        // $2->type.size  = 8;
        // $$ = $2;
        $$ = $2;
        datatype* oldtype = $$->type;
        // $$->type = new datatype();
        std::string old_type_name = "";
        if(oldtype!=NULL){
            old_type_name = oldtype->type_name;
        }   
        // $$->type->next = oldtype;
        // $$->type->type_name = "*" + old_type_name;
        old_type_name = "*" + old_type_name;
        // $$ -> type->isPointer = true;
        int oldsize = 4;
        if(oldtype!=NULL){
            oldsize = oldtype->size;
            if(oldtype->n_stars>0){
                oldsize = oldtype->size;
            }
            else{
                // if(oldtype->n_arr_boxes>0){
                oldsize = 4;
                for(int i=0; i<oldtype->n_arr_boxes; i++){
                    
                    oldsize *= oldtype->arr_sizes[i];
                }
                // }
            }
        }

        
        $$->type = new datatype(old_type_name, oldsize);
        $$->type->next = oldtype;
    }

    ;

compound_statement:
    '{' '}'
    {
        $$ = new seq_astnode();
    }

    | '{' declaration_list '}'
    {
        $$ = new seq_astnode();
    }

    | '{' statement_list '}'
    {
        $$ = $2;
    }

    | '{' declaration_list statement_list '}'
    {
        $$ = $3;
        // local symbol table from declaration_list
    }
    ;

statement_list:
    statement
    {
        $$ = new seq_astnode();
        $$->statements.push_back($1);
    }

    | statement_list statement
    {
        $1->statements.push_back($2);
        $$ = $1;
    }
    ;

statement:
    ';' 
    {
        $$ = new empty_astnode();
    }
    | '{' statement_list '}'
    {
        $$ = $2;
    }
    | assignment_statement
    {
        $$ = $1;
    }
    | procedure_call
    {
        $$ = $1;
    }
    | selection_statement
    {
        $$ = $1;
    }
    | iteration_statement
    {
        $$ = $1;
    }
    | RETURN expression ';'
    {   
        if(f_type_name=="int"&&$2->type->type_name=="float"){
            $$ = new return_astnode(new op_unary_astnode("TO_INT", $2));
        }
        else if(f_type_name=="float"&&$2->type->type_name=="int"){
            $$ = new return_astnode(new op_unary_astnode("TO_FLOAT", $2));
        }
        else if(compatible(f_type_name, $2->type->type_name)==false){
            std::string err = "Incompatible return type for the function";
            error(@$, err);
        }
        else {
            $$ = new return_astnode($2);
        }
    }
    ;

assignment_expression:
    unary_expression '=' expression
    {
        // $$ = new assignE_astnode($1, $3);
        if($1->lvalue==false){
          std::string err = "Expression on the left not a modifiable l-value";
         error(@$, err);
        }
        if(($1->type->type_name=="int"&&$3->type->type_name=="int")||($1->type->type_name=="float"&&$3->type->type_name=="float")){
            $$ = new assignE_astnode($1, $3);
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="float"){
            op_unary_astnode *temp = new op_unary_astnode("TO_INT", $3);
            $$ = new assignE_astnode($1, temp);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="int"){
            op_unary_astnode *temp = new op_unary_astnode("TO_FLOAT", $3);
            $$ = new assignE_astnode($1, temp);
        }
        else if($1->type->type_name==$3->type->type_name){
            $$ = new assignE_astnode($1, $3);
        }
        else if(($1->type->type_name=="void*"&&$3->type->n_arr_boxes + $3->type->n_stars > 0)||($3->type->type_name=="void*"&&$1->type->n_arr_boxes + $1->type->n_stars > 0)||($1->type->type_name=="void*"&&$3->type->type_name=="void*")){
            $$ = new assignE_astnode($1, $3);
        }
        else if($1->type->n_arr_boxes + $1->type->n_stars >0&&$3->type->n_arr_boxes + $3->type->n_stars>0){
            if(compatible($1->type->type_name, $3->type->type_name)){
                $$ = new assignE_astnode($1, $3);
            }
            else{
                std::string err = "Assignment of incompatible pointer types";
                error(@$, err);
            }
        }
        else if(($1->type->n_arr_boxes + $1->type->n_stars >0&&$3->astnode_type==typeExp::Floatconst_astnode)||($1->type->n_arr_boxes + $1->type->n_stars >0&&$3->astnode_type==typeExp::Intconst_astnode)){
            if($3->astnode_type==typeExp::Intconst_astnode&&$3->vali==0){
                $$ = new assignE_astnode($1, $3);
            }
            else if($3->astnode_type==typeExp::Floatconst_astnode&&$3->valf==0){
                $$ = new assignE_astnode($1, $3);
            }
            else{
                std::string err = "Assignment of incompatible pointer types";
                error(@$, err);
            }
        }
        else{
            std::string err = "Assignment of incompatible pointer types";
                error(@$, err);
        }

    }
    ;

assignment_statement:
    assignment_expression ';'
    {
        $$ = new assignS_astnode($1->left, $1->right);
    }
    ;

procedure_call:
    IDENTIFIER '(' expression_list ')' ';'
    {
        // $$->type = new datatype(gst.) TODO : assign type
        if($1=="printf"||$1=="scanf"||$1=="mod"){
            identifier_astnode* i_n = new identifier_astnode($1);
            $$ = new proccall_astnode(i_n, $3->args);
        }
        //else{
        //    identifier_astnode* i_n = new identifier_astnode($1);
        //    $$ = new proccall_astnode(i_n, $3->args);
        //}
        
        else{

            if(gst.lookup($1) == false || gst.Entries[$1].varfun!="fun"){
                // std::string err = "Invalid use of function call";
                std::string err = "Procedure \"" + $1 + "\" is not declared";
                error(@$, err);
            }
            if(gst.Entries[$1].param_data_list.size() > $3->args.size()){
                // std::string err = "Invalid use of function call";
                // std::string err = "Too few arguments to function \"" + $1 + "\"";
                std::string err = "Procedure \"" + $1 + "\" called with too few arguments";
                error(@$, err);
            }
            else if(gst.Entries[$1].param_data_list.size() < $3->args.size()){
                std::string err = "Procedure \"" + $1 + "\" called with too many arguments";
                error(@$, err);
            }
            for(int i = 0; i < $3->args.size(); i++){
                if(gst.Entries[$1].param_data_list[i]->type_name=="int"&&$3->args[i]->type->type_name=="float"){
                    op_unary_astnode* temp = new op_unary_astnode("TO_INT", $3->args[i]);
                    $3->args[i] = temp;
                }
                else if(gst.Entries[$1].param_data_list[i]->type_name=="float"&&$3->args[i]->type->type_name=="int"){
                    op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3->args[i]);
                    $3->args[i] = temp;
                }
                else if(compatible($3->args[i]->type->type_name, gst.Entries[$1].param_data_list[i]->type_name) == false){
                    std::string err = "Incompatible type of argument of type \"" + $3->args[i]->type->type_name + "\" to function \"" + $1 + "\"";
                    error(@$, err);
                }
                
            }
            identifier_astnode* i_n = new identifier_astnode($1);
            $$ = new proccall_astnode(i_n, $3->args);
        }
    }
    | IDENTIFIER '(' ')' ';'
    {
        // $$ = new proccall_astnode($1);
        if($1=="printf"||$1=="scanf"||$1=="mod"){
            identifier_astnode* i_n = new identifier_astnode($1);
            $$ = new proccall_astnode(i_n);
        }
        //else{
        //    identifier_astnode* i_n = new identifier_astnode($1);
        //    $$ = new proccall_astnode(i_n, $3->args);
        //}
        
        else{

            if(gst.lookup($1) == false || gst.Entries[$1].varfun!="fun"){
                // std::string err = "Invalid use of function call";
                std::string err = "Procedure \"" + $1 + "\" is not declared";
                error(@$, err);
            }
            else if(gst.Entries[$1].param_data_list.size() > 0){
                 std::string err = "Procedure \"" + $1 + "\" called with too few arguments";
                error(@$, err);
            }
        $$ = new proccall_astnode(new identifier_astnode($1));
        }
        // $$->type = new datatype(gst.f_func($1));
    }
    ;

expression:
    logical_and_expression
    {
        $$ = $1;
    }
    | expression OR_OP logical_and_expression
    {
        // $$ = new op_binary_astnode("OR_OP", $1, $3);
        if($1->type->type_name=="int"||$1->type->type_name=="float"||$1->type->n_arr_boxes + $1->type->n_stars > 0){
            if($3->type->type_name=="int"||$3->type->type_name=="float"||$3->type->n_arr_boxes + $3->type->n_stars > 0){
                $$ = new op_binary_astnode("OR_OP", $1, $3);
                $$->type = new datatype("int", 4);
            }
            else{
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
        }
        else{
            std::string err = "Cannot compare pointers of different types";
            error(@$, err);
        }
    }
    ;

logical_and_expression:
    equality_expression
    {
        $$ = $1;
    }
    | logical_and_expression AND_OP equality_expression
    {
        // $$ = new op_binary_astnode("AND_OP", $1, $3);
        if($1->type->type_name=="int"||$1->type->type_name=="float"||$1->type->n_arr_boxes + $1->type->n_stars > 0){
            if($3->type->type_name=="int"||$3->type->type_name=="float"||$3->type->n_arr_boxes + $3->type->n_stars > 0){
                $$ = new op_binary_astnode("AND_OP", $1, $3);
                $$->type = new datatype("int", 4);
            }
            else{
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
        }
        else{
            std::string err = "Cannot compare pointers of different types";
            error(@$, err);
        }
    }
    ;

equality_expression:
    relational_expression
    {
        $$ = $1;
    }
    | equality_expression EQ_OP relational_expression
    {
        // $$ = new op_binary_astnode("EQ_OP_X", $1, $3);
        if($1->type->type_name=="void*"){
            if($3->type->type_name=="void*" || $3->type->n_arr_boxes + $3->type->n_stars > 0){
                $$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
            else{
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
        }
        else if($3->type->type_name=="void*"){
            if($1->type->type_name=="void*" || $1->type->n_arr_boxes + $1->type->n_stars > 0){
                $$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
            else{
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
        }
        else if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->type->n_arr_boxes + $3->type->n_stars > 0){
            if(compatible($1->type->type_name, $3->type->type_name)==false){
               
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->astnode_type==typeExp::Floatconst_astnode){
            if($3->valf!=0){
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->astnode_type==typeExp::Intconst_astnode){
            if($3->vali!=0){
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->type_name == "int" && $3->type->type_name == "int"){
            $$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name == "float" && $3->type->type_name == "float"){
            $$ = new op_binary_astnode("EQ_OP_FLOAT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="float"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            $$ = new op_binary_astnode("EQ_OP_FLOAT", temp, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            $$ = new op_binary_astnode("EQ_OP_FLOAT", $1, temp);
            $$->type = new datatype("int", 4);
        }
        else{
            std::string err = "Cannot compare pointers of different types";
            error(@$, err);
        }
    }
    | equality_expression NE_OP relational_expression
    {
        // $$ = new op_binary_astnode("NE_OP_X", $1, $3);
        if($1->type->type_name=="void*"){
            if($3->type->type_name=="void*" || $3->type->n_arr_boxes + $3->type->n_stars > 0){
                $$ = new op_binary_astnode("NE_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
            else{
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
        }
        else if($3->type->type_name=="void*"){
            if($1->type->type_name=="void*" || $1->type->n_arr_boxes + $1->type->n_stars > 0){
                $$ = new op_binary_astnode("NE_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
            else{
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
        }
        else if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->type->n_arr_boxes + $3->type->n_stars > 0){
            if(compatible($1->type->type_name, $3->type->type_name)==false){
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("NE_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->astnode_type==typeExp::Floatconst_astnode){
            if($3->valf!=0){
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("NE_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->astnode_type==typeExp::Intconst_astnode){
            if($3->vali!=0){
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("NE_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->type_name == "int" && $3->type->type_name == "int"){
            $$ = new op_binary_astnode("NE_OP_INT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name == "float" && $3->type->type_name == "float"){
            $$ = new op_binary_astnode("NE_OP_FLOAT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="float"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            $$ = new op_binary_astnode("NE_OP_FLOAT", temp, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            $$ = new op_binary_astnode("NE_OP_FLOAT", $1, temp);
            $$->type = new datatype("int", 4);
        }
        else{
            std::string err = "Cannot compare pointers of different types";
            error(@$, err);
        }
    }
    ;

relational_expression:
    additive_expression
    {
        $$ = $1;
    }
    | relational_expression '<' additive_expression
    {
        // $$ = new op_binary_astnode("LT_OP_X", $1, $3);
        if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->type->n_arr_boxes + $3->type->n_stars > 0){
            if(compatible($1->type->type_name, $3->type->type_name)==false){
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("LT_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="int"){
            $$ = new op_binary_astnode("LT_OP_INT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="float"){
            $$ = new op_binary_astnode("LT_OP_FLOAT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="float"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            $$ = new op_binary_astnode("LT_OP_FLOAT", temp, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            $$ = new op_binary_astnode("LT_OP_FLOAT", $1, temp);
            $$->type = new datatype("int", 4);
        }
        else{
            std::string err = "Cannot compare pointers of different types";
            error(@$, err);
        }
    }
    | relational_expression '>' additive_expression
    {
        // $$ = new op_binary_astnode("GT_OP_X", $1, $3);
        if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->type->n_arr_boxes + $3->type->n_stars > 0){
            if(compatible($1->type->type_name, $3->type->type_name)==false){
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("GT_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="int"){
            $$ = new op_binary_astnode("GT_OP_INT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="float"){
            $$ = new op_binary_astnode("GT_OP_FLOAT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="float"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            $$ = new op_binary_astnode("GT_OP_FLOAT", temp, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            $$ = new op_binary_astnode("GT_OP_FLOAT", $1, temp);
            $$->type = new datatype("int", 4);
        }
        else{
            std::string err = "Cannot compare pointers of different types";
            error(@$, err);
        }
    }
    | relational_expression LE_OP additive_expression
    {
        // $$ = new op_binary_astnode("LE_OP_X", $1, $3);
        if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->type->n_arr_boxes + $3->type->n_stars > 0){
            if(compatible($1->type->type_name, $3->type->type_name)==false){
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("LE_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="int"){
            $$ = new op_binary_astnode("LE_OP_INT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="float"){
            $$ = new op_binary_astnode("LE_OP_FLOAT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="float"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            $$ = new op_binary_astnode("LE_OP_FLOAT", temp, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            $$ = new op_binary_astnode("LE_OP_FLOAT", $1, temp);
            $$->type = new datatype("int", 4);
        }
        else{
            std::string err = "Cannot compare pointers of different types";
            error(@$, err);
        }
    }
    | relational_expression GE_OP additive_expression
    {
        // $$ = new op_binary_astnode("GE_OP_X", $1, $3);
        if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->type->n_arr_boxes + $3->type->n_stars > 0){
            if(compatible($1->type->type_name, $3->type->type_name)==false){
                std::string err = "Cannot compare pointers of different types";
                error(@$, err);
            }
            else{
                $$ = new op_binary_astnode("GE_OP_INT", $1, $3);
                $$->type = new datatype("int", 4);
            }
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="int"){
            $$ = new op_binary_astnode("GE_OP_INT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="float"){
            $$ = new op_binary_astnode("GE_OP_FLOAT", $1, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="int"&&$3->type->type_name=="float"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            $$ = new op_binary_astnode("GE_OP_FLOAT", temp, $3);
            $$->type = new datatype("int", 4);
        }
        else if($1->type->type_name=="float"&&$3->type->type_name=="int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            $$ = new op_binary_astnode("GE_OP_FLOAT", $1, temp);
            $$->type = new datatype("int", 4);
        }
        else{
            std::string err = "Cannot compare pointers of different types";
            error(@$, err);
        }
    }
    ;

additive_expression:
    multiplicative_expression
    {
        $$ = $1;
    }
    | additive_expression '+' multiplicative_expression
    {
        // $$ = new op_binary_astnode("PLUS_X", $1, $3);
        if($1->type->n_arr_boxes + $1->type->n_stars > 0){
            if($3->type->type_name != "int"){
                std::string err = "Cannot add pointer to non-int";
                error(@$, err);
            }
            $$ = new op_binary_astnode("PLUS_INT", $1, $3);
            $$->type = $1->type;
        }
        else if($3->type->n_arr_boxes + $3->type->n_stars > 0){
            if($1->type->type_name != "int"){
                std::string err = "Cannot add pointer to non-int";
                error(@$, err);
            }
            $$ = new op_binary_astnode("PLUS_INT", $1, $3);
            $$->type = $3->type;
        }
        else if($1->type->type_name == "int" && $3->type->type_name == "int"){
            $$ = new op_binary_astnode("PLUS_INT", $1, $3);
            $$->type = new datatype("int");
        }
        else if($1->type->type_name == "float" && $3->type->type_name == "float"){
            $$ = new op_binary_astnode("PLUS_FLOAT", $1, $3);
            $$->type = new datatype("float");
        }
        else if($1->type->type_name == "float" && $3->type->type_name == "int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            // $$ = new op_binary_astnode("PLUS_FLOAT", $1, $3);
            $$ = new op_binary_astnode("PLUS_FLOAT", $1, temp);
            $$->type = new datatype("float");
        }
        else if($1->type->type_name == "int" && $3->type->type_name == "float"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            // $$ = new op_binary_astnode("PLUS_FLOAT", $1, $3);
            $$ = new op_binary_astnode("PLUS_FLOAT", temp, $3);
            $$->type = new datatype("float");
        }
        else{
            std::string err = "Cannot add non-numbers";
            error(@$, err);
        }

    }
    | additive_expression '-' multiplicative_expression
    {
        // $$ = new op_binary_astnode("MINUS_X", $1, $3);
        if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->type->type_name == "int"){
            $$ = new op_binary_astnode("MINUS_INT", $1, $3);
            $$->type = $1->type;
        }
        else if($1->type->n_arr_boxes + $1->type->n_stars > 0&&$3->type->n_arr_boxes + $3->type->n_stars > 0){
            if(compatible($1->type->type_name, $3->type->type_name)){
                $$ = new op_binary_astnode("MINUS_INT", $1, $3);
                $$->type = new datatype("int");
            }
            else{
                std::string err = "Cannot subtract pointers of different types";
                error(@$, err);
            }
        }
        else if($1->type->type_name == "int" && $3->type->type_name == "int"){
            $$ = new op_binary_astnode("MINUS_INT", $1, $3);
            $$->type = new datatype("int");
        }
        else if($1->type->type_name == "float" && $3->type->type_name == "float"){
            $$ = new op_binary_astnode("MINUS_FLOAT", $1, $3);
            $$->type = new datatype("float");
        }
        else if($1->type->type_name == "float" && $3->type->type_name == "int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            // $$ = new op_binary_astnode("MINUS_FLOAT", $1, $3);
            $$ = new op_binary_astnode("MINUS_FLOAT", $1, temp);
            $$->type = new datatype("float");
        }
        else if($1->type->type_name == "int" && $3->type->type_name == "float"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            // $$ = new op_binary_astnode("MINUS_FLOAT", $1, $3);
            $$ = new op_binary_astnode("MINUS_FLOAT", temp, $3);
            $$->type = new datatype("float");
        }
        else{
            std::string err = "Cannot subtract non-numbers or non-compatible pointers";
            error(@$, err);
        }
    }
    ;

unary_expression:
    postfix_expression
    {
        $$ = $1;
    }
    | unary_operator unary_expression
    {
        // $$ = new op_unary_astnode($2, $1->op);
        if($1 == "ADDRESS"){
            if($2->lvalue == false){
                std::string err = "Cannot take address of non-lvalue";
                error(@$, err);
            }
            if($2->type->type_name == "void"){
                std::string err = "Cannot take address of void";
                error(@$, err);
            }

            $$ = new op_unary_astnode($1, $2);
            // n_type_name = $2->type->type_name;
            std::string n_type_name = "";
            bool enc_par = false;
            bool ep_2 = false;
             if($2->type->type_name.find('[') == std::string::npos){
                 //n_type_name = n_type_name.substr(0, n_type_name.find('['));
                 n_type_name = ""+$2->type->type_name + "(*)";
             }
             else{

                //for(int i =0; i < $2->type->type_name.size(); i++){
                //    if(enc_par&&$2->type->type_name[i]!='*'){
                //        n_type_name+="(*)";
                //        enc_par = false;
                //        n_type_name.push_back($2->type->type_name[i]);
                //   }
                // else if(enc_par)n_type_name.push_back('*');
                // else{
                    //    if($2->type->type_name[i]=='*'&&ep_2==false){
                    //      enc_par = true;
                        //    ep_2 = true;
                    // }
                        //n_type_name.push_back($2->type->type_name[i]);
                    //}
                //}
     //           for(int i =0 ; i<  $2->type->type_name.size(); i++){
       //             if(enc_par&&($2->type->type_name[i]!='*'||i==$2->type->type_name.size()-1)){
         //               n_type_name+="(*)";
           //             enc_par = false;
             //           n_type_name.push_back($2->type->type_name[i]);
               //     }
                 //   else if(enc_par)n_type_name.push_back('*');
                   // else{
                     //   if($2->type->type_name[i]=='*'&&ep_2==false){
                       // enc_par = true;
                   //     ep_2 = true;
                     //   }
                       // n_type_name.push_back($2->type->type_name[i]);
                    //}

               // }
                //if(!ep_2){
                 //   n_type_name+="(*)";
                //}
                int lsq = $2->type->type_name.find('[');
                for(int i =0 ; i < lsq; i++){
                    n_type_name.push_back($2->type->type_name[i]);
                }
                n_type_name += "(*)";
                for(int i = lsq; i<$2->type->type_name.size(); i++){
                    n_type_name.push_back($2->type->type_name[i]);
                }
             }
            $$->type = new datatype(n_type_name);
            
        }
        else if($1 == "DEREF"){
            if($2->type->n_stars + $2->type->n_arr_boxes < 1){
                std::string err = "Cannot dereference non-pointer";
                error(@$, err);
            }
            if($2->type->base_type == "void"){
                std::string err = "Cannot dereference void pointer";
                error(@$, err);
            }
            $$ = new op_unary_astnode($1, $2);
            $$->lvalue = true;
            std::string n_type_name = "";
            bool enc_par = false;
            bool ep_2 = false;
            if($2->type->n_stars == 0){
                for(int i = 0; i < $2->type->type_name.size(); i++){
                    if(enc_par==false&&$2->type->type_name[i]=='['){
                        // n_type_name.push_back('*');
                        i = $2->type->type_name.find(']');
                        enc_par = true;
                        // break;
                    }
                    else n_type_name.push_back($2->type->type_name[i]);
                }
            }
            else{
                for(int i =0; i < $2->type->type_name.size(); i++){
                    if(enc_par==false&&$2->type->type_name[i]=='('){
                        enc_par = true;
                        i = $2->type->type_name.find(')');
                    }
                    else if(enc_par==false&&$2->type->type_name[i]=='['){
                        enc_par = true;
                        n_type_name.pop_back();
                        n_type_name.push_back($2->type->type_name[i]);
                    }
                    else{
                        n_type_name.push_back($2->type->type_name[i]);
                    }
                }
                if(enc_par==false){
                    n_type_name.pop_back();
                }
            }
            $$->type = new datatype(n_type_name);

        }
        else if($1 == "UMINUS"){
            if($2->type->type_name != "int"&&$2->type->type_name != "float"){
                std::string err = "Cannot negate non-numeric type";
                error(@$, err);
            }
            $$ = new op_unary_astnode($1, $2);
            $$->type = $2->type;
        }
        else if($1 == "NOT"){
            if($2->type->type_name != "int"&&$2->type->type_name != "float" && $2->type->n_arr_boxes + $2->type->n_stars == 0){
                std::string err = "Cannot negate non-numeric type";
                error(@$, err);
            }
            $$ = new op_unary_astnode($1, $2);
            if($2->type->n_arr_boxes + $2->type->n_stars>0){
                $$->type = new datatype("int", 4);
            }
            //else $$->type = $2->type;
            else $$->type = new datatype("int", 4);

        }

    }
    ;

multiplicative_expression:
    unary_expression
    {
        $$ = $1;
    }
    | multiplicative_expression '*' unary_expression
    {
        if($1->type->type_name != "int"&&$1->type->type_name != "float"&&$3->type->type_name != "int"&&$3->type->type_name != "float"){
            std::string err = "Cannot multiply non-numeric types";
            error(@$, err);
        }
        if($1->type->type_name == "int"&&$3->type->type_name == "int"){
            $$ = new op_binary_astnode("MULT_INT", $1, $3);
            $$->type = new datatype("int");
        }
        else if($1->type->type_name == "int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            temp->type = new datatype("float");
            $$ = new op_binary_astnode("MULT_FLOAT", temp, $3);
            $$->type = new datatype("float");
        }
        else if($3->type->type_name == "int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            temp->type = new datatype("float");
            $$ = new op_binary_astnode("MULT_FLOAT", $1, temp);
            $$->type = new datatype("float");
        }
        else if($1->type->type_name =="float"&&$3->type->type_name=="float"){
            $$ = new op_binary_astnode("MULT_FLOAT", $1, $3);
            $$->type = new datatype("float");
        }
        // else{ // not required
        //     $$ = new op_binary_astnode("DIV_X", $1, $3);
        // }
    }
    | multiplicative_expression '/' unary_expression
    {
        if($1->type->type_name != "int"&&$1->type->type_name != "float"&&$3->type->type_name != "int"&&$3->type->type_name != "float"){
            std::string err = "Cannot divide non-numeric types";
            error(@$, err);
        }
        if($1->type->type_name == "int"&&$3->type->type_name == "int"){
            $$ = new op_binary_astnode("DIV_INT", $1, $3);
            $$->type = new datatype("int");
        }
        else if($1->type->type_name == "int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $1);
            temp->type = new datatype("float");
            $$ = new op_binary_astnode("DIV_FLOAT", temp, $3);
            $$->type = new datatype("float");
        }
        else if($3->type->type_name == "int"){
            op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3);
            temp->type = new datatype("float");
            $$ = new op_binary_astnode("DIV_FLOAT", $1, temp);
            $$->type = new datatype("float");
        }
        else if($1->type->type_name =="float"&&$3->type->type_name=="float"){
            $$ = new op_binary_astnode("DIV_FLOAT", $1, $3);
            $$->type = new datatype("float");
        }
        // else{ // not required
        //     $$ = new op_binary_astnode("DIV_X", $1, $3);
        // }
    }
    ;

postfix_expression:
    primary_expression
    {
        $$ = $1;
    }
    | postfix_expression '[' expression ']'
    {   
        if($1->type->n_arr_boxes + $1->type->n_stars < 1){
            std::string err = "Subscripted value is neither array nor pointer";
            error(@$, err);
        }
        if($3->type->type_name != "int"|| $3->type->n_arr_boxes > 0 || $3->type->n_stars > 0){
            std::string err = "Array subscript is not an integer";
            error(@$, err);
        }
        $$ = new arrayref_astnode($1, $3);   
        if($1->type->n_arr_boxes > 0){
            std::string t_n = "";
            bool f_box_enc = false;
            int del_b = 1;
            for(int i =0; i< $1->type->type_name.size(); i++){
                if(f_box_enc){
                    t_n.push_back($1->type->type_name[i]);
                }
                else{
                    if($1->type->type_name[i] == '['){
                        f_box_enc = true;
                        del_b = stoi($1->type->type_name.substr(i+1, $1->type->type_name.find(']', i) - i - 1));
                        i = $1->type->type_name.find(']', i);
                        // i+=2;
                    }
                    else{
                        t_n.push_back($1->type->type_name[i]);
                    }
                }
            }
            $$->type = new datatype(t_n, $1->type->size/del_b);
        }
        else{
            // $$->type = new datatype($1->type->type_name.substr(0, $1->type->type_name.find()));
            if($1->type->type_name.find('(')==std::string::npos){
                $$->type = new datatype($1->type->type_name.substr(0, $1->type->type_name.size()-1));
            }
            else $$->type = new datatype($1->type->type_name.substr(0, $1->type->type_name.find('(')));

        }

    }
    | postfix_expression '.' IDENTIFIER
    {   
        if(gst.lookup($1->type->type_name) == false || gst.Entries[$1->type->type_name].varfun!="struct"){
            std::string err = "Left operand of \".\"  is not a  structure";
            error(@$, err);
        }
        SymTab* lst = gst.Entries[$1->type->type_name].stptr;
        if(lst->lookup($3) == false){
            // std::string err = "Invalid use of '.'";
            // std::string err = "No member named \"" + $3 + "\" in struct "+ $1->id_name;
            std::string err = "Struct \"" + $1->type->type_name + "\" has no member named \"" + $3 + "\"";
            error(@$, err);
        }
        identifier_astnode* tmp = new identifier_astnode($3);
        $$ = new member_astnode($1, tmp);
        $$->type = new datatype(lst->Entries[$3].r_type);
    }
    | IDENTIFIER '(' ')'
    {   
        if($1=="printf"||$1=="scanf"||$1=="mod"){
            $$ = new funcall_astnode(new identifier_astnode($1));
            if($1=="mod")$$->type = new datatype("int", 4);
            else $$->type = new datatype("void", 0);
        }
        else{

            if(gst.lookup($1) == false || gst.Entries[$1].varfun!="fun"){
                std::string err = "Invalid use of function call";
                error(@$, err);
            }
            if(gst.Entries[$1].param_data_list.size() != 0){
                // std::string err = "Invalid use of function call";
                std::string err = "Too few arguments to function \"" + $1 + "\"";
                error(@$, err);
            }
            $$ = new funcall_astnode(new identifier_astnode($1));
            $$->type = new datatype(gst.f_func($1));
        }
    }
    | IDENTIFIER '(' expression_list ')'
    {   
        if($1=="printf"||$1=="scanf"||$1=="mod"){
            $$ = new funcall_astnode(new identifier_astnode($1), $3->args);
            if($1=="mod")$$->type = new datatype("int", 4);
            else $$->type = new datatype("void", 0);
        }
        else{

            if(gst.lookup($1) == false || gst.Entries[$1].varfun!="fun"){
                // std::string err = "Invalid use of function call";
                std::string err = "Procedure \"" + $1 + "\" is not declared";
                error(@$, err);
            }
            if(gst.Entries[$1].param_data_list.size() > $3->args.size()){
                // std::string err = "Invalid use of function call";
                // std::string err = "Too few arguments to function \"" + $1 + "\"";
                std::string err = "Procedure \"" + $1 + "\" called with too few arguments";
                error(@$, err);
            }
            else if(gst.Entries[$1].param_data_list.size() < $3->args.size()){
                std::string err = "Procedure \"" + $1 + "\" called with too many arguments";
                error(@$, err);
            }
            for(int i = 0; i < $3->args.size(); i++){
                if(gst.Entries[$1].param_data_list[i]->type_name=="int"&&$3->args[i]->type->type_name=="float"){
                    op_unary_astnode* temp = new op_unary_astnode("TO_INT", $3->args[i]);
                    $3->args[i] = temp;
                }
                else if(gst.Entries[$1].param_data_list[i]->type_name=="float"&&$3->args[i]->type->type_name=="int"){
                    op_unary_astnode* temp = new op_unary_astnode("TO_FLOAT", $3->args[i]);
                    $3->args[i] = temp;
                }
                else if(compatible($3->args[i]->type->type_name, gst.Entries[$1].param_data_list[i]->type_name) == false){
                    std::string err = "Incompatible type of argument of type \"" + $3->args[i]->type->type_name + "\" to function \"" + $1 + "\"";
                    error(@$, err);
                }
                
            }
            $$ = new funcall_astnode(new identifier_astnode($1), $3->args); // check if we can use proccall
            $$->type = new datatype(gst.f_func($1));
        }
    }
    | postfix_expression INC_OP
    {
        // $$ = new op_unary_astnode($1, "PP");
        if($1->type->isPointer||$1->type->type_name=="float"||$1->type->type_name=="int"){
            $$ = new op_unary_astnode("PP", $1);
            $$->lvalue = false;
            $$->type = $1->type;
        }
        else{
            // std::string err = "Invalid use of \"++\"";
            std::string err = "Operand of \"++\" should be a int, float or pointer";
            error(@$, err);
        }
    }
    | postfix_expression PTR_OP IDENTIFIER
    {
        // $$ = new arrow_astnode($1, $3);
        if(gst.lookup($1->type->base_type) == false || gst.Entries[$1->type->base_type].varfun!="struct"||$1->type->n_stars + $1->type->n_arr_boxes!=1){
            std::string err = "Left operand of \"->\"  is not a pointer to structure";
            error(@$, err);
        }
        SymTab* lst = gst.Entries[$1->type->base_type].stptr;
        if(lst->lookup($3) == false){
            // std::string err = "Invalid use of '.'";
            // std::string err = "No member named \"" + $3 + "\" in struct "+ $1->id_name;
            std::string err = "Struct \"" + $1->type->base_type + "\" has no member named \"" + $3 + "\"";
            error(@$, err);
        }
        identifier_astnode* tmp = new identifier_astnode($3);
        $$ = new arrow_astnode($1, tmp);
        $$->type = new datatype(lst->f_identifier($3));
    }
    ;

primary_expression:
    IDENTIFIER
    {
        if(st->lookup($1)==false){
            // std::string err = "Undeclared variable " + std::string($1);
            std::string err = "Variable \""+ std::string($1) + "\" not declared";
            error(@$, err);
        }
        $$ = new identifier_astnode($1);
        // $$->type = st->f_identifier($1);
        $$->type = new datatype(st->f_identifier($1));
    }
    | INT_CONSTANT
    {
        //$$ = new int_constant_astnode(std::stoi($1));
        //$$->value = std::stoi($1);
        //intconst_astnode *tmp = new intconst_astnode(stoi($1));
        //$$ = tmp;
        $$ = new intconst_astnode(std::stoi($1));
        $$->vali = std::stoi($1);
        $$->type = new datatype("int");
        
    }
    | FLOAT_CONSTANT
    {
        // $$ = new float_constant_astnode(std::stof($1));
        floatconst_astnode* tmp = new floatconst_astnode(stof($1));
        $$ = tmp;
        $$->type = new datatype("float");
    }
    | '(' expression ')'
    {
        $$ = $2;

    }
    | STRING_LITERAL
    {
        stringconst_astnode* tmp = new stringconst_astnode($1);
        $$ = tmp;
        $$->type = new datatype("string");
    }
    ;

expression_list:
    expression
    {
        // std::vector<exp_astnode*> tmp = {};
        // tmp.push_back($1);
        // $$ = new funcall_astnode(tmp);
        $$ = new proccall_astnode();
        $$->args.push_back($1);
    }
    | expression_list ',' expression
    {
        $$ = $1;
        $1->args.push_back($3);
    }
    ;

unary_operator:
    '-' %prec UMINUS
    {
        // $$ = new unary_operator_astnode($1);
        //make $$ equal to string name of operator
        $$ = "UMINUS";
    }
    | '!'
    {
        // $$ = new unary_operator_astnode($1);
        $$ = "NOT";
    }
    | '&'
    {
        // $$ = new unary_operator_astnode($1);
        $$ = "ADDRESS";
    }
    | '*' %prec USTAR
    {
        // $$ = new unary_operator_astnode($1);
        $$ = "DEREF";
    }
    ;

selection_statement:
    
    IF '(' expression ')' statement ELSE statement
    {
        if($3->type->type_name!="") $$ = new if_astnode($3, $5, $7);
        else {
            std::string err = "No expression";
            error(@$, err);
        }
    }
    ;

iteration_statement:
    WHILE '(' expression ')' statement
    {
        if($3->type->type_name!="") $$ = new while_astnode($3, $5);
        else {
            std::string err = "Invalid expression";
            error(@$, err);
        }
    }
    | FOR '(' assignment_expression ';' expression ';' assignment_expression ')' statement
    {
        if($5->type->type_name!="") $$ = new for_astnode($3, $5, $7, $9);
        else {
            std::string err = "Invalid expression";
            error(@$, err);
        }
    }
    ;

declaration_list:
    declaration
    {
        std::vector<declaration_class*> tmp = {};
        tmp.push_back($1);
        $$ = new declaration_list_class(tmp);
    }
    | declaration_list declaration
    {
        $1->declaration_list.push_back($2);
        $$ = $1;
    }
    ;

declaration:
    type_specifier declarator_list ';'
    {
        $$ = new declaration_class($1, $2);
        if(structdef){
            std::vector<declarator_class*> decls = $2->declarator_list;
            for(auto decl:decls){
                    if($1->type.type_name=="void"){
                        if(decl==NULL||decl->type==NULL||decl->type->n_stars+decl->type->n_arr_boxes==0){

                            std::string err = "Cannot declare simple void type";
                            error(@$, err);
                        }
                    }
                if(decl!=NULL){
                    if(st->lookup(decl->name)==true){

                        std::string err = "\""+ decl->name+"\" has a previous declaration";
                        error(@$, err);
                    }
                }
                
                int size = calculate_size($1, decl);
                std::string type_name = "";
                if(decl->type!=NULL){
                    type_name = decl->type->type_name;
                }
                if(decl->type!=NULL&&decl->type->base_type!="") st->push_struct(decl->name, new SymTabEntry("var", "local", size, 0, type_name));
                else st->push_struct(decl->name, new SymTabEntry("var", "local", size, 0, $1->type.type_name+type_name));
                offset += size;
                currStructSize += size;
            }
        }
        if(funcdef){
            std::vector<declarator_class*> decls = $2->declarator_list;
            for(auto decl:decls){
                if(decl!=NULL&&st->lookup(decl->name)){
                    std::string err = "\""+ decl->name+"\" has a previous declaration";
                    error(@$, err);
                }
                if($1->type.type_name=="void"&&decl->type!=NULL&&decl->type->n_stars+decl->type->n_arr_boxes<1){
                        std::string err = "Cannot declare simple void type";
                        error(@$, err);
                }
                int size = calculate_size($1, decl);
                std::string type_name = "";
                if(decl->type!=NULL){
                    type_name = decl->type->type_name;
                }
                if(decl->type!=NULL&&decl->type->base_type!="") st->push_struct(decl->name, new SymTabEntry("var", "local", size, 0, type_name));
                else st->push_local(decl->name, new SymTabEntry("var", "local", size, 0, $1->type.type_name+type_name));
                // offset += size;
            }
        }
    }
    ;

declarator_list:
    declarator
    {
        std::vector<declarator_class*> tmp = {};
        tmp.push_back($1);
        $$ = new declarator_list_class(tmp);
    }
    | declarator_list ',' declarator
    {
        $1->declarator_list.push_back($3);
        $$ = $1;
    }
    ;

%%
void 
IPL::Parser::error( const location_type &l, const std::string &err_message )
{
      std::cout << "Error at line " << l.begin.line << ": " << err_message <<
 "\n";
//    std::cout << "Error at location " << l << ": " << err_message << "\n";
   exit(1);

}
