// #include "symbtab.hh"

// localST::localST(std::string n, std::string v){
//     this->name = n;
//     this->vfs = v;
//     this->l_offset = -4;
//     this->h_offset = 12;
//     this->lv_entries.clear();
// }

// void localST::insert(struct var_entry a){
//     // a.offset = this->l_offset;
//     // this->l_offset -= 4;
//     this->lv_entries.push_back(a);
// }

// void localST::insert(std::string n, std::string v, std::string s, int sz, std::string t){
//     struct var_entry a;
//     a.ename = n;
//     a.vfs = v;
//     a.scope = s;
//     a.size = sz;
//     a.etype = t;
//     // a.offset = this->l_offset;
//     // this->l_offset -= 4;
//     // this->lv_entries.push_back(a);
//     if(s=="param"){
//         a.offset = h_offset;
//         h_offset += sz;
//     }
//     else{
//         a.offset = l_offset;
//         l_offset -= sz;
//     }
// }

// int localST::find(std::string n){
//     for(int i=0; i<this->lv_entries.size(); i++){
//         if(this->lv_entries[i].ename == n){
//             return i;
//         }
//     }
//     return -1;
// }

// void localST::print(){
//     std::cout<<"\"name\": \""<<this->name<<"\",\n\"localST\":\n[\n";
//     std::sort(this->lv_entries.begin(), this->lv_entries.end());
//     for(int i = 0; i < lv_entries.size(); i++){
//         std::cout<<"[\""<<lv_entries[i].ename<<"\",\t\t\t\""<<lv_entries[i].vfs<<"\",\t\t\t\""<<lv_entries[i].scope<<"\",\t\t"<<lv_entries[i].size<<",\t\t"<<lv_entries[i].offset<<",\""<<lv_entries[i].etype<<"\"\n]\n";
//         if(i != lv_entries.size()-1)
//             std::cout<<",\n";
//     }
//     std::cout<<"]\n";
// }

// int localST::tot_size(){
//     if(vfs=="fun") return 0;
//     else{
//         int tot = 0;
//         for(int i=0; i<this->lv_entries.size(); i++){
//             if(lv_entries[i].scope!="param")tot += this->lv_entries[i].size;
//         }
//         return tot;
//     }
// }

// localST::localST(){
//     lv_entries.clear();
// }

// globalST::globalST(){
//     gv_entries.clear();
// }

// void globalST::insert(struct globalST_entry a){
//     gv_entries.push_back(a);
// }

// void globalST::insert(class localST* lsptr, std::string type){
//     if(lsptr==NULL) return;
//     struct globalST_entry a;
//     a.ename = lsptr->name;
//     a.vfs = lsptr->vfs;
//     a.scope = "global";
//     a.etype = type;
//     a.size = lsptr->tot_size();
//     if(a.vfs == "struct")a.offset="\"-\"";
//     else a.offset="0";
//     gv_entries.push_back(a);
// }

// void globalST::print(){
//     std::cout<<"\"globalST\":\n[";
//     std::sort(this->gv_entries.begin(), this->gv_entries.end());
//     for(int i = 0; i < gv_entries.size(); i++){
//         std::cout<<"[\t\t\t\""<<gv_entries[i].ename<<"\",\t\t\t\""<<gv_entries[i].vfs<<"\",\t\t\t\""<<gv_entries[i].scope<<"\",\t\t"<<gv_entries[i].size<<",\t\t"<<gv_entries[i].offset<<",\""<<gv_entries[i].etype<<"\"\n]\n";
//         if(i != gv_entries.size()-1)
//             std::cout<<",\n";
//     }
//     std::cout<<"]\n";
// }

#include <iostream>
#include "symbtab.hh"
#include <string>


using namespace std;

SymTab::SymTab()
{
    l_off = 0;
    p_off = 12;
    s_off = 0;
}

bool SymTab::lookup(string name){
    if(Entries.find(name) == Entries.end())
        return false;
    else
        return true;
}

std::string SymTab::f_identifier(string name){
    if(Entries.find(name) == Entries.end())
        return "";
    else
        return Entries[name].r_type;
}

std::string SymTab::f_func(string name){
    if(Entries.find(name) == Entries.end())
        return "";
    else
        // return Entries[name].r_type;
        if(Entries[name].varfun == "fun")
            return Entries[name].r_type;
        else
            return "";
}

int SymTab::get_struct_size(string name){
    if(Entries.find(name) == Entries.end())
        return -1;
    else
        // return Entries[name].size;
        if(Entries[name].varfun == "struct")
            return Entries[name].size;
        else
            return -1;
}

void SymTab::printgst(){
    std::cout<<"[\n";

    for(auto it = Entries.begin(); it != Entries.end(); ++it){
        std::cout<<"[\n";
        std::cout<<"\""<<it->first<<"\",\n";
        std::cout<<"\""<<it->second.varfun<<"\",\n";
        std::cout<<"\""<<it->second.scope<<"\",\n";
        std::cout<<it->second.size<<",\n";
        if(it->second.varfun == "struct"){
            std::cout<<"\"-\",\n";
        }
        else{
        std::cout<<it->second.offset<<",\n";
        }
        std::cout<<"\""<<it->second.r_type<<"\"";
        std::cout<<"]\n";
        if (next(it,1) != Entries.end()) std::cout << "," << endl;
    }
    std::cout<<"]\n";
}

void SymTab::print(){ return printgst(); }

int SymTab::push_local(std::string name, SymTabEntry* entry){
    if(Entries.find(name) == Entries.end()){
        // Entries[name] = *entry;
        l_off -= entry->size;
        entry->offset = l_off;
        Entries.insert({name, *entry});
        return 1;
    }
    else
        return -1;
}

int SymTab::push_param(std::string name, SymTabEntry* entry){
    if(Entries.find(name) == Entries.end()){
        // Entries[name] = *entry;
        entry->offset = p_off;
        p_off += entry->size;
        Entries.insert({name, *entry});
        return 1;
    }
    else
        return -1;
}

int SymTab::push_struct(std::string name, SymTabEntry* entry){
    if(Entries.find(name) == Entries.end()){
        // Entries[name] = *entry;
        entry->offset = s_off;
        s_off += entry->size;
        Entries.insert({name, *entry});
        return 1;
    }
    else
        return -1;
}

int SymTab::push(std::string name, SymTabEntry *entry){
    if(Entries.find(name) == Entries.end()){
        Entries.insert({name, *entry});
        return 1;
    }
    else
        return -1;
}

SymTabEntry::SymTabEntry(std::string varfun, std::string scope, int size, int offset, std::string r_type)
{
    this->varfun = varfun;
    this->scope = scope;
    this->size = size;
    this->offset = offset;
    this->r_type = r_type;
    this->stptr = NULL;
}

SymTabEntry::SymTabEntry(std::string varfun, std::string scope, int size, int offset, std::string r_type, SymTab* stptr)
{
    this->varfun = varfun;
    this->scope = scope;
    this->size = size;
    this->offset = offset;
    this->r_type = r_type;
    this->stptr = stptr;
}

SymTabEntry::SymTabEntry(std::string varfun, std::string scope, std::string r_type){
    this->varfun = varfun;
    this->scope = scope;
    this->r_type = r_type;
    this->stptr = NULL;
    this->size = 0;
    this->offset = 0;
}

SymTabEntry::SymTabEntry(std::string varfun, std::string scope, std::string r_type, SymTab* stptr){
    this->varfun = varfun;
    this->scope = scope;
    this->r_type = r_type;
    this->stptr = stptr;
    this->size = 0;
    this->offset = 0;
}

SymTabEntry::SymTabEntry(){
    this-> size = 0;
    this-> offset = 0;
    this-> r_type = "";
    this-> stptr = NULL;
}

void SymTabEntry::print(){
    std::cout<<"[\n"<<"\""<<this->varfun<<"\","<<"\n"<<"\""<<this->scope<<"\","<<"\n"<<this->size<<",\n"<<this->offset<<",\n"<<"\""<<this->r_type<<"\"\n]\n";
}

void SymTabEntry::set_param_list(std::vector<datatype*> param_list){
    // this->param_list = param_list;
    this->param_data_list = std::vector<datatype*>();
    for(auto it = param_list.begin(); it != param_list.end(); ++it){
        this->param_data_list.push_back(*it);
    }
}