CXX =  g++-8
EXE = iplC
CXXDEBUG = -g -w
CXXSTD = -std=c++11


.PHONY: all
all: parser lexer 	
	$(CXX) $(CXXDEBUG) -o iplC driver.cpp parser.o scanner.o 

parser: parser.yy scanner.hh
	bison -d -v $<
	$(CXX) $(CXXDEBUG) -c parser.tab.cc -o parser.o 

lexer: scanner.l scanner.hh parser.tab.hh parser.tab.cc	
	flex++ --outfile=scanner.yy.cc  $<
	$(CXX)  $(CXXDEBUG) -c scanner.yy.cc -o scanner.o
clean: 
	rm -f parser.tab.cc parser.o iplC scanner.o scanner.yy.cc parser.tab.hh stack.hh position.hh location.hh parser.output
