#include<vector>
#include<string>
#include "type.hh"
enum typeExp
{
    Empty_astnode,
    Seq_astnode,
    AssignS_astnode,
    Return_astnode,
    If_astnode,
    While_astnode,
    For_astnode,
    Proccall_astnode,
    Op_binary_astnode,
    Op_unary_astnode,
    AssignE_astnode,
    Funcall_astnode,
    Intconst_astnode,
    Floatconst_astnode,
    Stringconst_astnode,
    IDENTIFIER_astnode,
    Arrayref_astnode,
    Member_astnode,
    Arrow_astnode,
};

using namespace std;
class abstract_astnode
{
public:
    virtual void print(int blanks) = 0;
    enum typeExp astnode_type;
    virtual ~abstract_astnode();
};

class statement_astnode : public abstract_astnode
{
public:
    virtual void print(int blanks) = 0;
// protected:
//     statement_astnode(enum typeExp astnode_type);
    statement_astnode();
    virtual ~statement_astnode();
};

class exp_astnode : public abstract_astnode
{
public:
    virtual void print(int blanks) = 0;
    std::string id_name;
    int vali;
    float valf;
    std::string vals;
    exp_astnode* child;
    bool lvalue;
    // std::string type;
    datatype *type;
    exp_astnode();
    virtual ~exp_astnode(){};
// protected:
//     exp_astnode(enum typeExp astnode_type);
};

class ref_astnode : public exp_astnode
{
public:
    virtual void print(int blanks) = 0;
    ref_astnode();
    virtual ~ref_astnode(){};
// protected:
//     ref_astnode(enum typeExp astnode_type);
};

class identifier_astnode : public ref_astnode
{
public:
    std::string id_name;
    void print(int blanks);
    identifier_astnode(std::string name);
};

class empty_astnode : public statement_astnode
{
public:
    void print(int blanks);
    empty_astnode();
};

class seq_astnode : public statement_astnode
{
public:
    std::vector<statement_astnode*> statements;
    void print(int blanks);
    seq_astnode(vector<statement_astnode*> statements);
    seq_astnode();
    ~seq_astnode();
};

class assignS_astnode : public statement_astnode
{
public:
    exp_astnode* left;
    exp_astnode* right;
    void print(int blanks);
    assignS_astnode(exp_astnode* left, exp_astnode* right);
    ~assignS_astnode();
};

class return_astnode : public statement_astnode
{
public:
    exp_astnode* exp;
    void print(int blanks);
    return_astnode(exp_astnode* exp);
    ~return_astnode();
};

class if_astnode : public statement_astnode
{
public:
    exp_astnode* condition;
    statement_astnode* then;
    statement_astnode* elsee;
    void print(int blanks);
    if_astnode(exp_astnode* condition,statement_astnode* then,statement_astnode* elsee);
    ~if_astnode();
};

class while_astnode : public statement_astnode
{
public:
    exp_astnode* condition;
    statement_astnode* body;
    void print(int blanks);
    while_astnode(exp_astnode* condition,statement_astnode* body);
    ~while_astnode();
};

class for_astnode : public statement_astnode
{
public:
    exp_astnode* init;
    exp_astnode* condition;
    exp_astnode* update;
    statement_astnode* body;
    void print(int blanks);
    for_astnode(exp_astnode* init,exp_astnode* condition,exp_astnode* update,statement_astnode* body);
    ~for_astnode();
};

class proccall_astnode : public statement_astnode
{
public:
    // std::string name;
    identifier_astnode* i_name;
    std::vector<exp_astnode*> args;
    void print(int blanks);
    proccall_astnode(identifier_astnode* i_name,std::vector<exp_astnode*> args);
    proccall_astnode(identifier_astnode* i_name);
    proccall_astnode();
    void add_arg(exp_astnode* arg);
    ~proccall_astnode();
};



class op_binary_astnode : public exp_astnode
{
public:
    std::string op;
    exp_astnode* left;
    exp_astnode* right;
    void print(int blanks);
    op_binary_astnode(std::string op,exp_astnode* left,exp_astnode* right);
    ~op_binary_astnode();
};

class op_unary_astnode : public exp_astnode
{
public:
    std::string op;
    exp_astnode* exp;
    void print(int blanks);
    op_unary_astnode(std::string op,exp_astnode* exp);
    op_unary_astnode(std::string op);
    ~op_unary_astnode();
};

class assignE_astnode : public exp_astnode
{
public:
    exp_astnode* left;
    exp_astnode* right;
    void print(int blanks);
    assignE_astnode(exp_astnode* left,exp_astnode* right);
    ~assignE_astnode();
};

class funcall_astnode : public exp_astnode
{
public:
    // std::string name;
    identifier_astnode* i_name;
    std::vector<exp_astnode*> args;
    void print(int blanks);
    funcall_astnode(identifier_astnode* i_name,std::vector<exp_astnode*> args);
    funcall_astnode(identifier_astnode* i_name);
    funcall_astnode(std::vector<exp_astnode*> args);
    ~funcall_astnode();
};

class intconst_astnode : public exp_astnode
{
public:
    int vali;
    void print(int blanks);
    intconst_astnode(int value);
};

class floatconst_astnode : public exp_astnode
{
public:
    float valf;
    void print(int blanks);
    floatconst_astnode(float value);
};

class stringconst_astnode : public exp_astnode
{
public:
    std::string vals;
    void print(int blanks);
    stringconst_astnode(std::string value);
};


class arrayref_astnode : public ref_astnode
{
public:
    exp_astnode* array;
    exp_astnode* index;
    void print(int blanks);
    arrayref_astnode(exp_astnode* array,exp_astnode* index);
    ~arrayref_astnode();
};

class member_astnode : public ref_astnode
{
public:
    exp_astnode* exp;
    identifier_astnode* member;
    void print(int blanks);
    member_astnode(exp_astnode* exp,identifier_astnode* member);
    ~member_astnode();
};

class arrow_astnode : public ref_astnode
{
public:
    exp_astnode* exp;
    identifier_astnode* member;
    void print(int blanks);
    arrow_astnode(exp_astnode* exp,identifier_astnode* member);
    ~arrow_astnode();
};

void printAst(const char *astname, const char *fmt...);