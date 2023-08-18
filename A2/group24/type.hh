// #include <string>
// #include <iostream>
// #include <vector>

// class type_specifier_class{
//     public:
//         std::string type;
//         int size;
//         type_specifier_class(std::string t, int s){
//             this->type = t;
//             this->size = s;
//         }
//         type_specifier_class(){
//             this->type = "";
//             this->size = 0;
//         }
//         void print(){
//             std::cout<<"type: "<<this->type<<", size: "<<this->size<<std::endl;
//         }
// };

// class declarator_class{
//     public:
//        std:sring name;
//         int size;
//         declarator_class(std::string n, int s){
//             this->name = n;
//             this->size = s;
//         }
//         declarator_class(){
//             this->name = "";
//             this->size = 0;
//         }
//         void print(){
//             std::cout<<"name: "<<this->name<<", size: "<<this->size<<std::endl;
//         }
// };

// class declaration_class{
//     public:
//         type_specifier_class type_specifier;
//         declarator_class declarator;
//         declaration_class(type_specifier_class t, declarator_class d){
//             this->type_specifier = t;
//             this->declarator = d;
//         }
//         declaration_class(){
//             this->type_specifier = type_specifier_class();
//             this->declarator = declarator_class();
//         }
//         void print(){
//             std::cout<<"declaration_class: \n";
//             this->type_specifier.print();
//             this->declarator.print();
//         }
// };

// class declarator_list_class{
//     public:
//         std::vector<declarator_class> declarators;
//         declarator_list_class(declarator_class d){
//             this->declarators.push_back(d);
//         }
//         declarator_list_class(){
//             this->declarators.clear();
//         }
//         void print(){
//             std::cout<<"declarator_list_class: \n";
//             for(int i=0; i<this->declarators.size(); i++){
//                 this->declarators[i].print();
//             }
//         }
// };

// class declaration_list_class{
//     public:
//         std::vector<declaration_class> declarations;
//         declaration_list_class(declaration_class d){
//             this->declarations.push_back(d);
//         }
//         declaration_list_class(){
//             this->declarations.clear();
//         }
//         void print(){
//             std::cout<<"declaration_list_class: \n";
//             for(int i=0; i<this->declarations.size(); i++){
//                 this->declarations[i].print();
//             }
//         }
// };

// class parameter_list_class{
//     public:
//         std::vector<declaration_class> parameters;
//         parameter_list_class(declaration_class d){
//             this->parameters.push_back(d);
//         }
//         parameter_list_class(){
//             this->parameters.clear();
//         }
//         void print(){
//             std::cout<<"parameter_list_class: \n";
//             for(int i=0; i<this->parameters.size(); i++){
//                 this->parameters[i].print();
//             }
//         }
// };

// class parameter_declaration_class{
//     public:
//         type_specifier_class type_specifier;
//         declarator_class declarator;
//         parameter_declaration_class(type_specifier_class t, declarator_class d){
//             this->type_specifier = t;
//             this->declarator = d;
//         }
//         parameter_declaration_class(){
//             this->type_specifier = type_specifier_class();
//             this->declarator = declarator_class();
//         }
//         void print(){
//             std::cout<<"parameter_declaration_class: \n";
//             this->type_specifier.print();
//             this->declarator.print();
//         }
// };

// class fun_declarator_class{
//     public:
//         std::string name;
//         parameter_list_class parameter_list;
//         fun_declarator_class(std::string n, parameter_list_class p){
//             this->name = n;
//             this->parameter_list = p;
//         }
//         fun_declarator_class(){
//             this->name = "";
//             this->parameter_list = parameter_list_class();
//         }
//         void print(){
//             std::cout<<"fun_declarator_class: \n";
//             std::cout<<"name: "<<this->name<<std::endl;
//             this->parameter_list.print();
//         }
// };

// #pragma once
#ifndef TYPE_HH
#define TYPE_HH
#include<string>
#include<vector>
class datatype{
    // this datatype should be able to handle many types of types such as pointer to a datatype , array of a datatype , 
public:
    std::string type_name;
    int size;
    datatype* next;
    int n_arr_boxes;
    int n_stars;
    std::vector<int> arr_sizes;
    bool isPointer;
    std::string base_type;
    bool isInt;
    bool isFloat;

    void print();
    datatype(std::string type_name, int size);
    datatype(std::string type_name);
    datatype();
    ~datatype();
};

// create a enum of basic types such as int , float , void , char
enum basic_type{
    INT_TYPE,
    FLOAT_TYPE,
    VOID_TYPE,
    CHAR_TYPE,
    DEFAULT_TYPE
};

datatype createtype(basic_type type);


class type_specifier_class{

    public:
    datatype type;
    type_specifier_class(datatype t);
    type_specifier_class();
    type_specifier_class(basic_type t);
    ~type_specifier_class();
};

class declarator_class{

    public:
    std::string name;
    datatype *type;
    declarator_class(std::string n, datatype* t);
    declarator_class();
    ~declarator_class();
};

class declarator_list_class{

    public:
    std::vector<declarator_class*> declarator_list;
    declarator_list_class(std::vector<declarator_class*> d);
    declarator_list_class();
    ~declarator_list_class();
    int get_size();
};

class declaration_class{

    public:
    type_specifier_class *type_specifier;
    // declarator_class declarator;
    declarator_list_class *declarator_list;
    declaration_class(type_specifier_class* t, declarator_list_class* d);
    declaration_class();
    ~declaration_class();
};

class declaration_list_class{

    public:
    std::vector<declaration_class*> declaration_list;
    declaration_list_class(std::vector<declaration_class*> d);
    declaration_list_class();
    ~declaration_list_class();
};



class parameter_declaration_class{

    public:
    type_specifier_class* type_specifier;
    declarator_class* declarator;
    parameter_declaration_class(type_specifier_class* t, declarator_class* d);
    parameter_declaration_class();
    ~parameter_declaration_class();
};

class parameter_list_class{

    public:
    std::vector<parameter_declaration_class*> parameter_list;
    parameter_list_class(std::vector<parameter_declaration_class*> p);
    parameter_list_class();
    ~parameter_list_class();

};

class fun_declarator_class{

    public:
    std::string name;
    // declarator_list_class* declarator_list;
    parameter_list_class* parameter_list;
    datatype *type;

    fun_declarator_class(std::string n, parameter_list_class* p);
    ~fun_declarator_class();
};

int calculate_size(type_specifier_class* ts, declarator_class* dec);

bool compatible(std::string type1, std::string type2);

#endif