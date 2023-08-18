#include "type.hh"
#include <iostream>
#include <algorithm>

datatype createtype(basic_type type){
    datatype temp;
    switch(type){
        case INT_TYPE:
            temp.type_name = "int";
            temp.size = 4;
            break;
        case FLOAT_TYPE:
            temp.type_name = "float";
            temp.size = 4;
            break;
        case VOID_TYPE:
            temp.type_name = "void";
            temp.size = 0;
            break;
        case CHAR_TYPE:
            temp.type_name = "char";
            temp.size = 1;
            break;
        case DEFAULT_TYPE:
            temp.type_name = "";
            temp.size = 1;
    }
    temp.n_stars = 0;
            temp.n_arr_boxes = 0;
    return temp;
}

void datatype::print(){
    // cout << type << " " << size << endl;
}

datatype::datatype(std::string type_name, int size){
    this->type_name = type_name;
    this->size = size;
    this->isPointer = false;
    this->next = NULL;
    this->n_arr_boxes = 0;
    this->n_stars = 0;
    this->isInt = (type_name == "int");
    this->isFloat = (type_name == "float");
    this->arr_sizes = std::vector<int>();
    char b = '[';
    for(int i = 0 ; ( i = type_name.find(b, i)) != std::string::npos ; i++){
        this->n_arr_boxes++;
        this->arr_sizes.push_back(stoi(type_name.substr(i+1, type_name.find(']', i) - i - 1)));
    }
    char a = '*';
    for(int i = 0 ; ( i = type_name.find(a, i)) != std::string::npos ; i++){
        this->n_stars++;
    }
    if(this->n_stars > 0) this->isPointer = true;
    unsigned int pos1 = type_name.find('[');
    unsigned int pos2 =  type_name.find('*');
    if(pos1 == std::string::npos && pos2 == std::string::npos) this->base_type = type_name;
    else if(pos1 == std::string::npos) this->base_type = type_name.substr(0, pos2);
    else if(pos2 == std::string::npos) this->base_type = type_name.substr(0, pos1);
    else  this->base_type = type_name.substr(0, std::min(type_name.find('['), type_name.find('*')));
    this->base_type.erase(std::remove(this->base_type.begin(), this->base_type.end(), '('), this->base_type.end());
    this->base_type.erase(std::remove(this->base_type.begin(), this->base_type.end(), ')'), this->base_type.end());
}

datatype::datatype(std::string type_name){
    this->type_name = type_name;
    this->size = 1;
    this->isPointer = false;
    this->next = NULL;
    this->n_arr_boxes = 0;
    this->n_stars = 0;
    this->isInt = (type_name == "int");
    this->isFloat = (type_name == "float");
    this->arr_sizes = std::vector<int>();
    char b = '[';
    for(int i = 0 ; ( i = type_name.find(b, i)) != std::string::npos ; i++){
        this->n_arr_boxes++;
        this->arr_sizes.push_back(stoi(type_name.substr(i+1, type_name.find(']', i) - i - 1)));
    }
    char a = '*';
    for(int i = 0 ; ( i = type_name.find(a, i)) != std::string::npos ; i++){
        this->n_stars++;
    }
    if(type_name == "void") this->size = 0;
    else {
        this->size = 1;
        for(int i = 0 ; i < this->n_arr_boxes ; i++){
            this->size *= this->arr_sizes[i];
        }
    }
    if(this->n_stars > 0) this->isPointer = true;
    unsigned int pos1 = type_name.find('[');
    unsigned int pos2 =  type_name.find('*');
    if(pos1 == std::string::npos && pos2 == std::string::npos) this->base_type = type_name;
    else if(pos1 == std::string::npos) this->base_type = type_name.substr(0, pos2);
    else if(pos2 == std::string::npos) this->base_type = type_name.substr(0, pos1);
    else  this->base_type = type_name.substr(0, std::min(type_name.find('['), type_name.find('*')));
    this->base_type.erase(std::remove(this->base_type.begin(), this->base_type.end(), '('), this->base_type.end());
    this->base_type.erase(std::remove(this->base_type.begin(), this->base_type.end(), ')'), this->base_type.end());
}

datatype::datatype(){
    this->type_name = "";
    this->size = 1;
    this->isPointer = false;
    this->next = NULL;
    this->n_arr_boxes = 0;
    this->n_stars = 0;
    this->isInt = false;
    this->isFloat = false;
    this->arr_sizes = std::vector<int>();
    this->base_type = "";
}

datatype::~datatype(){
    if(this->next != NULL){
        delete this->next;
    }
}

type_specifier_class::type_specifier_class(datatype t){
    this->type = t;
}

type_specifier_class::type_specifier_class(){
    this->type = createtype(DEFAULT_TYPE);
}

type_specifier_class::type_specifier_class(basic_type t){
    this->type = createtype(t);
}

type_specifier_class::~type_specifier_class(){
}

declarator_class::declarator_class(std::string n, datatype* t){
    this->name = n;
    this->type = t;
}

declarator_class::declarator_class(){
    this->name = "";
    // this->type = createtype(VOID_TYPE);
    datatype* temp = new datatype();
    *temp = createtype(DEFAULT_TYPE);
    this->type = temp;
}

declarator_class::~declarator_class(){
    if(this->type != NULL){
        delete this->type;
    }
}

declarator_list_class::declarator_list_class(std::vector<declarator_class*> d){
    this->declarator_list = d;
}

declarator_list_class::declarator_list_class(){
    this->declarator_list = std::vector<declarator_class*>();
}

declarator_list_class::~declarator_list_class(){
    for(int i = 0; i < this->declarator_list.size(); i++){
        delete this->declarator_list[i];
    }
}

int declarator_list_class::get_size(){
    int size = 0;
    for(int i = 0; i < this->declarator_list.size(); i++){
        // size += this->declarator_list[i]->type->size;
        if(this->declarator_list[i]->type==NULL){
            size += 1;
        }
        else{
            size += this->declarator_list[i]->type->size;
        }
    }
    return size;
}

declaration_class::declaration_class(type_specifier_class* t, declarator_list_class* d){
    this->type_specifier = t;
    this->declarator_list = d;
}

declaration_class::declaration_class(){
    this->type_specifier = NULL;
    this->declarator_list = NULL;
}

declaration_class::~declaration_class(){
    if(this->type_specifier != NULL){
        delete this->type_specifier;
    }
    if(this->declarator_list != NULL){
        delete this->declarator_list;
    }
}

declaration_list_class::declaration_list_class(std::vector<declaration_class*> d){
    this->declaration_list = d;
}

declaration_list_class::declaration_list_class(){
    this->declaration_list = std::vector<declaration_class*>();
}

declaration_list_class::~declaration_list_class(){
    for(int i = 0; i < this->declaration_list.size(); i++){
        delete this->declaration_list[i];
    }
}

parameter_declaration_class::parameter_declaration_class(type_specifier_class* t, declarator_class* d){
    this->type_specifier = t;
    this->declarator = d;
    std::string t_n = "";
    if(t!=NULL){
        t_n = t->type.type_name;
    }
    if(d!=NULL&&d->type!=NULL){
        if(d->type->base_type=="") t_n += d->type->type_name;
        else t_n = d->type->type_name;
    }
    // std::cout<<"t_n: "<<t_n<<std::endl;
    if(d!=NULL)
        d->type = new datatype(t_n);
    
}

parameter_declaration_class::parameter_declaration_class(){
    this->type_specifier = NULL;
    this->declarator = NULL;
}

parameter_declaration_class::~parameter_declaration_class(){
    if(this->type_specifier != NULL){
        delete this->type_specifier;
    }
    if(this->declarator != NULL){
        delete this->declarator;
    }
}

parameter_list_class::parameter_list_class(std::vector<parameter_declaration_class*> p){
    this->parameter_list = p;
}

parameter_list_class::parameter_list_class(){
    this->parameter_list = std::vector<parameter_declaration_class*>();
}

parameter_list_class::~parameter_list_class(){
    for(int i = 0; i < this->parameter_list.size(); i++){
        delete this->parameter_list[i];
    }
}

fun_declarator_class::fun_declarator_class(std::string n, parameter_list_class* p){
    // this->declarator = d;
    this->name = n;
    this->parameter_list = p;
}

fun_declarator_class::~fun_declarator_class(){
    if(this->type != NULL){
        delete this->type;
    }
    if(this->parameter_list != NULL){
        delete this->parameter_list;
    }
}

int calculate_size(type_specifier_class* t, declarator_class* d){
    // int size = 0;
    // for(int i = 0; i < d->declarator_list.size(); i++){
    //     size += d->declarator_list[i]->type->size;
    // }
    // return size;
    if(d->type == NULL){
        return t->type.size;
    }
    else{
        if(d->type->isPointer || d->type->n_stars > 0){
            if(d->type->n_arr_boxes==0){
                return 4;
            }
            //return 4;
            //return d->type->size;
            int sz = 4;
            for(int i =0 ; i < d->type->arr_sizes.size(); i++){
                sz*=d->type->arr_sizes[i];
            }
            return sz;

        }
        else{
            return d->type->size * t->type.size;
        }
    }
}

bool compatible(std::string type1, std::string type2){
    if(type1 == type2){
        return true;
    }
    datatype* t1 = new datatype(type1);
    datatype* t2 = new datatype(type2);
    if(type1=="void*"){
        if(t2->n_arr_boxes+t2->n_stars>0) return true;
        return false;
    }
    if(type2=="void*"){
        if(t1->n_arr_boxes+t1->n_stars>0) return true;
        return false;
    }
    if(t1->n_arr_boxes+t1->n_stars!=t2->n_arr_boxes+t2->n_stars){
        return false;
    }
    if(t1->base_type!=t2->base_type){
        return false;
    }
    if(t1->n_arr_boxes==0&&t2->n_arr_boxes==0){
        return t1->n_stars==t2->n_stars;
    }
    else if(t1->n_arr_boxes==1&&t2->n_arr_boxes==0){
        return t1->n_stars+1==t2->n_stars;
    }
    else if(t1->n_arr_boxes==0&&t2->n_arr_boxes==1){
        return t1->n_stars==t2->n_stars+1;
    }
    else if(t1->n_stars > t2->n_stars){
        // return t1->n_stars==t2->n_stars+1;
        if(t1->n_stars!=t2->n_stars+1){
            return false;
        }
        for(int i = 0; i< t1->n_arr_boxes; i++){
            if(t1->arr_sizes[i]!=t2->arr_sizes[i+1]){
                return false;
            }
        }
        int par_occ = t1->type_name.find('(');
        int sq_occ = t2->type_name.find('[');
        if(par_occ!=sq_occ){
            return false;
        }
        if(t1->type_name[par_occ+1]=='*'&&t1->type_name[par_occ+2]==')'){
            return true;
        }
    }
    else if(t1->n_stars < t2->n_stars){
        if(t1->n_stars+1!=t2->n_stars){
            return false;
        }
        for(int i = 0; i< t2->n_arr_boxes; i++){
            if(t2->arr_sizes[i]!=t1->arr_sizes[i+1]){
                return false;
            }
        }
        int par_occ = t2->type_name.find('(');
        int sq_occ = t1->type_name.find('[');
        if(par_occ!=sq_occ){
            return false;
        }
        if(t2->type_name[par_occ+1]=='*'&&t2->type_name[par_occ+2]==')'){
            return true;
        }
    }
    else{
        bool first = false;
        for(int i = 0; i < t1->n_arr_boxes; i++){
            if(t1->arr_sizes[i]!=t2->arr_sizes[i]){
                //return false;
                if(i==0)first = true;
                else return false;
            }
        }
        return true;
    }
    return false;
}