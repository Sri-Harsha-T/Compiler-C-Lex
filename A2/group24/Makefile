CXX  = g++-8
EXE = iplC
CXXDEBUG = -g -Wall
CXXSTD = -std=c++11
SCANNER = scanner.l


.PHONY: all
all : parser.o scanner.o ast.o type.o symbtab.o main.o 
	$(CXX) $(CXXDEBUG) -o iplC main.o parser.o scanner.o ast.o type.o symbtab.o

main.o : main.cpp
	$(CXX) $(CXXDEBUG) -c main.cpp -o main.o

parser.o : parser.yy
	bison -d -v $<
	$(CXX) $(CXXDEBUG) -c parser.tab.cc -o parser.o

scanner.o : $(SCANNER) scanner.hh parser.tab.cc parser.tab.hh
	flex++ --outfile=scanner.yy.cc  $<
	$(CXX)  $(CXXDEBUG) -c scanner.yy.cc -o scanner.o

ast.o : ast.cpp ast.hh
	$(CXX) $(CXXDEBUG) -c ast.cpp -o ast.o

type.o : type.cpp type.hh
	$(CXX) $(CXXDEBUG) -c type.cpp -o type.o

symbtab.o : symbtab.cpp symbtab.hh
	$(CXX) $(CXXDEBUG) -c symbtab.cpp -o symbtab.o

.PHONY: clean
clean:
	rm -f *.o parser.tab.cc parser.tab.hh scanner.yy.cc *.output $(EXE) position.hh stack.hh