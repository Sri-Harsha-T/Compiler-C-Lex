// #include <string>
// #include <vector>
// #include <iostream>
// #include <algorithm>


// struct var_entry{
//     std::string ename;
//     std::string vfs;
//     std::string scope;
//     int size;
//     int offset;
//     std::string etype;

//     bool operator<(const var_entry& rhs) const
//     {
//         return ename < rhs.ename;
//     }
// };

// struct globalST_entry{
//     std::string ename;
//     std::string vfs;
//     std::string scope;
//     int size;
//     std::string offset;
//     std::string etype;
//     class localST* lstptr;

//     bool operator<(const globalST_entry& rhs) const
//     {
//         return ename < rhs.ename;
//     }
// };

// class localST{
//     int l_offset;
//     int h_offset;

//     public:

//         std::string vfs;
//         std::string name;
//         std::vector<struct var_entry> lv_entries;

//         localST();

//         localST(std::string n, std::string v);

//         void insert(struct var_entry a);

//         void insert(std::string n, std::string v, std::string s, int sz, std::string t);

//         int find(std::string n);

//         void print();

//         int tot_size();
// };

// struct globalST{
//     std::vector<struct globalST_entry> gv_entries;

//     globalST();

//     void insert(struct globalST_entry a);

//     void insert(class localST* lsptr, std::string type);
//     void print();
// };
#ifndef SYMBTAB_HH
#define SYMBTAB_HH

#include "type.hh"
#include <iostream>
#include <string>
#include <map>

class SymTabEntry;

class SymTab{
    public:
        int p_off;
        int l_off;
        int s_off;

        std::map<std::string, SymTabEntry> Entries;
        void print();
        void printgst();
        int push_param(std::string name, SymTabEntry* entry);
        int push_local(std::string name, SymTabEntry* entry);
        int push_struct(std::string name, SymTabEntry* entry);
        int push(std::string name, SymTabEntry* entry);
        std::string f_identifier(std::string name);
        std::string f_func(std::string name);
        int get_struct_size(std::string name);
        bool lookup(std::string name);
        SymTab();

};

class SymTabEntry{
    public:
        int size;
        int offset;
        std::string varfun;
        std::string scope;
        std::string r_type;
        SymTab *stptr;
        std::vector<datatype*> param_data_list; // for functions

        SymTabEntry();
        SymTabEntry(std::string v, std::string s, std::string r_t);
        SymTabEntry(std::string v, std::string s, std::string r_t, SymTab *stptr);
        SymTabEntry(std::string v, std::string s, int sz, int off, std::string r_t);
        SymTabEntry(std::string v, std::string s, int sz, int off, std::string r_t, SymTab *stptr);
        void set_param_list(std::vector<datatype*> param_list);
        void print();

};

#endif