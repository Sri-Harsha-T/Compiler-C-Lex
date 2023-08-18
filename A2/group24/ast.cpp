#include <iostream>
#include <cstdarg>
#include "ast.hh"

using namespace std;

abstract_astnode::~abstract_astnode() {
};

statement_astnode::~statement_astnode() {
};

statement_astnode::statement_astnode(){
    
}

exp_astnode::exp_astnode() {
    // this->astnode_type = typeExp::Exp_astnode;
    this->lvalue = false;
    // this->type = "";
    this->type = NULL;
}

ref_astnode::ref_astnode() {
    // this->astnode_type = typeExp::Ref_astnode;
    this->lvalue = true;
}

empty_astnode::empty_astnode(){
    this->astnode_type = typeExp::Empty_astnode;
};


void empty_astnode::print(int blank) {
    cout << "\"empty\"" << endl;
}

seq_astnode::seq_astnode(vector<statement_astnode *> s) {
    this->astnode_type = typeExp::Seq_astnode;
    this->statements = s;
}

seq_astnode::seq_astnode() {
    this->astnode_type = typeExp::Seq_astnode;
    this->statements = vector<statement_astnode *>();
}

void seq_astnode::print(int blank) {
    // cout << "seq_astnode" << endl;
    printAst("", "l", "seq", this->statements);
}

seq_astnode::~seq_astnode() {
    for (int i = 0; i < this->statements.size(); i++) {
        delete this->statements[i];
    }
};

assignS_astnode::assignS_astnode(exp_astnode *l, exp_astnode *r) {
    this->astnode_type = typeExp::AssignS_astnode;
    this->left = l;
    this->right = r;
}

void assignS_astnode::print(int blank) {
    // cout << "assignS_astnode" << endl;
    printAst("assignS", "aa", "left", left, "right", right);
}

assignS_astnode::~assignS_astnode() {
    delete this->left;
    delete this->right;
};

return_astnode::return_astnode(exp_astnode *e) {
    this->astnode_type = typeExp::Return_astnode;
    this->exp = e;
}

void return_astnode::print(int blank) {
    // cout << "return_astnode" << endl;
    printAst("", "a", "return", exp);
}

return_astnode::~return_astnode() {
    delete this->exp;
};

if_astnode::if_astnode(exp_astnode *c, statement_astnode *t, statement_astnode *f) {
    this->astnode_type = typeExp::If_astnode;
    this->condition = c;
    this->then = t;
    this->elsee = f;
}

void if_astnode::print(int blank) {
    // cout << "if_astnode" << endl;
    printAst("if", "aaa", "cond", condition, "then", then, "else", elsee);
}

if_astnode::~if_astnode() {
    delete this->condition;
    delete this->then;
    delete this->elsee;
};

while_astnode::while_astnode(exp_astnode *c, statement_astnode *b) {
    this->astnode_type = typeExp::While_astnode;
    this->condition = c;
    this->body = b;
}

void while_astnode::print(int blank) {
    // cout << "while_astnode" << endl;
    printAst("while", "aa", "cond", condition, "stmt", body);
}

while_astnode::~while_astnode() {
    delete this->condition;
    delete this->body;
};

for_astnode::for_astnode(exp_astnode *i, exp_astnode *c, exp_astnode *u, statement_astnode *b) {
    this->astnode_type = typeExp::For_astnode;
    this->init = i;
    this->condition = c;
    this->update = u;
    this->body = b;
}

void for_astnode::print(int blank) {
    // cout << "for_astnode" << endl;
    printAst("for", "aaaa", "init", init, "guard", condition, "step", update, "body", body);
}

for_astnode::~for_astnode() {
    delete this->init;
    delete this->condition;
    delete this->update;
    delete this->body;
};

proccall_astnode::proccall_astnode(identifier_astnode* i_n, vector<exp_astnode *> a) {
    this->astnode_type = typeExp::Proccall_astnode;
    this->i_name = i_n;
    this->args = a;
}

proccall_astnode::proccall_astnode(identifier_astnode* i_n) {
    this->astnode_type = typeExp::Proccall_astnode;
    this->i_name = i_n;
    this->args = vector<exp_astnode *>();
}

proccall_astnode::proccall_astnode() {
    this->astnode_type = typeExp::Proccall_astnode;
    this->i_name = NULL;
    this->args = vector<exp_astnode *>();
}

void proccall_astnode::add_arg(exp_astnode *a) {
    this->args.push_back(a);
};

proccall_astnode::~proccall_astnode() {
    delete this->i_name;
    for (int i = 0; i < this->args.size(); i++) {
        delete this->args[i];
    }
};

void proccall_astnode::print(int blank) {
    // cout << "proccall_astnode" << endl;
    printAst("proccall", "al", "fname", i_name, "params", args);
}

op_binary_astnode::op_binary_astnode( std::string o,exp_astnode *l, exp_astnode *r) {
    this->astnode_type = typeExp::Op_binary_astnode;
    this->left = l;
    this->right = r;
    this->op = o;
}

void op_binary_astnode::print(int blank) {
    // cout << "op_binary_astnode" << endl;
    std::string s = "\"" + this->op + "\"";
    char *cstr = const_cast<char *>(s.c_str());
    printAst("op_binary", "saa", "op", cstr, "left", left, "right", right);
}

op_binary_astnode::~op_binary_astnode() {
    delete this->left;
    delete this->right;
};

op_unary_astnode::op_unary_astnode(std::string o, exp_astnode *e) {
    this->astnode_type = typeExp::Op_unary_astnode;
    this->exp = e;
    this->op = o;
}

op_unary_astnode::op_unary_astnode(std::string o) {
    this->astnode_type = typeExp::Op_unary_astnode;
    this->op = o;
    this -> exp = NULL;
}

void op_unary_astnode::print(int blank) {
    // cout << "op_unary_astnode" << endl;
    std::string s = "\"" + this->op + "\"";
    char *cstr = const_cast<char *>(s.c_str());
    printAst("op_unary", "sa", "op", cstr, "child", exp);
}

op_unary_astnode::~op_unary_astnode() {
    if(this->exp != NULL)    delete this->exp;
};

assignE_astnode::assignE_astnode(exp_astnode *l, exp_astnode *r) {
    this->astnode_type = typeExp::AssignE_astnode;
    this->left = l;
    this->right = r;
}

void assignE_astnode::print(int blank) {
    // cout << "assignE_astnode" << endl;
    printAst("assignE", "aa", "left", left, "right", right);
}

assignE_astnode::~assignE_astnode() {
    delete this->left;
    delete this->right;
};

funcall_astnode::funcall_astnode(identifier_astnode* i_n, vector<exp_astnode *> a) {
    this->astnode_type = typeExp::Funcall_astnode;
    this->i_name = i_n;
    this->args = a;
}

funcall_astnode::funcall_astnode(identifier_astnode* i_n) {
    this->astnode_type = typeExp::Funcall_astnode;
    this->i_name = i_n;
    this->args = {};
}

funcall_astnode::funcall_astnode(std::vector<exp_astnode *> a) {
    this->astnode_type = typeExp::Funcall_astnode;
    this->i_name = NULL;
    this->args = a;
}

void funcall_astnode::print(int blank) {
    // cout << "funcall_astnode" << endl;
    printAst("funcall", "al", "fname", i_name, "params", args);
}

funcall_astnode::~funcall_astnode() {
    delete this->i_name;
    for (int i = 0; i < this->args.size(); i++) {
        delete this->args[i];
    }
};

intconst_astnode::intconst_astnode(int v) {
    this->astnode_type = typeExp::Intconst_astnode;
    this->vali = v;
}

void intconst_astnode::print(int blank) {
    // cout << "intconst_astnode" << endl;
    printAst("", "i", "intconst", vali);
}

floatconst_astnode::floatconst_astnode(float v) {
    this->astnode_type = typeExp::Floatconst_astnode;
    this->valf = v;
}

void floatconst_astnode::print(int blank) {
    // cout << "floatconst_astnode" << endl;
    printAst("", "f", "floatconst", valf);
}

stringconst_astnode::stringconst_astnode(std::string v) {
    this->astnode_type = typeExp::Stringconst_astnode;
    this->vals = v;
}

void stringconst_astnode::print(int blank) {
    // cout << "stringconst_astnode" << endl;
    char *cstr = const_cast<char *>(vals.c_str());
    printAst("", "s", "stringconst", cstr);
}

identifier_astnode::identifier_astnode(std::string n) {
    this->astnode_type = typeExp::IDENTIFIER_astnode;
    this->id_name = n;
}

void identifier_astnode::print(int blank) {
    // cout << "identifier_astnode" << endl;
    std::string s = "\"" + this->id_name + "\"";
    char *cstr = const_cast<char *>(s.c_str());
    printAst("", "s", "identifier", cstr);
}

arrayref_astnode::arrayref_astnode(exp_astnode* arr, exp_astnode* idx) {
    this->astnode_type = typeExp::Arrayref_astnode;
    this->array = arr;
    this->index = idx;
}

void arrayref_astnode::print(int blank) {
    // cout << "arrayref_astnode" << endl;
    printAst("arrayref", "aa", "array", array, "index", index);
}

arrayref_astnode::~arrayref_astnode() {
    delete this->array;
    delete this->index;
};

member_astnode::member_astnode(exp_astnode* exp, identifier_astnode* id) {
    this->astnode_type = typeExp::Member_astnode;
    this->exp = exp;
    this->member = id;
}

void member_astnode::print(int blank) {
    // cout << "member_astnode" << endl;
    printAst("member", "aa", "struct", exp, "field", member);
}

member_astnode::~member_astnode() {
    delete this->exp;
    delete this->member;
};

arrow_astnode::arrow_astnode(exp_astnode* exp, identifier_astnode* id) {
    this->astnode_type = typeExp::Arrow_astnode;
    this->exp = exp;
    this->member = id;
}

void arrow_astnode::print(int blank) {
    // cout << "arrow_astnode" << endl;
    printAst("arrow", "aa", "pointer", exp, "field", member);
}

arrow_astnode::~arrow_astnode() {
    delete this->exp;
    delete this->member;
};



void printAst(const char *astname, const char *fmt...) // fmt is a format string that tells about the type of the arguments.
{   
	typedef vector<exp_astnode *>* pv;
	va_list args;
	va_start(args, fmt);
	if ((astname != NULL) && (astname[0] != '\0'))
	{
		cout << "{ ";
		cout << "\"" << astname << "\"" << ": ";
	}
	cout << "{" << endl;
	while (*fmt != '\0')
	{
		if (*fmt == 'a')
		{
			char * field = va_arg(args, char *);
			abstract_astnode *a = va_arg(args, abstract_astnode *);
			cout << "\"" << field << "\": " << endl;
			
			a->print(0);
		}
		else if (*fmt == 's')
		{
			char * field = va_arg(args, char *);
			char *str = va_arg(args, char *);
			cout << "\"" << field << "\": ";

			cout << str << endl;
		}
		else if (*fmt == 'i')
		{
			char * field = va_arg(args, char *);
			int i = va_arg(args, int);
			cout << "\"" << field << "\": ";

			cout << i;
		}
		else if (*fmt == 'f')
		{
			char * field = va_arg(args, char *);
			double f = va_arg(args, double);
			cout << "\"" << field << "\": ";
			cout << f;
		}
		else if (*fmt == 'l')
		{
			char * field = va_arg(args, char *);
			pv f =  va_arg(args, pv);
			cout << "\"" << field << "\": ";
			cout << "[" << endl;
			for (int i = 0; i < (int)f->size(); ++i)
			{
				(*f)[i]->print(0);
				if (i < (int)f->size() - 1)
					cout << "," << endl;
				else
					cout << endl;
			}
			cout << endl;
			cout << "]" << endl;
		}
		++fmt;
		if (*fmt != '\0')
			cout << "," << endl;
	}
	cout << "}" << endl;
	if ((astname != NULL) && (astname[0] != '\0'))
		cout << "}" << endl;
	va_end(args);
}