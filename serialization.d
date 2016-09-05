import std.stdio;
import std.traits;
import std.typetuple;
import std.range;

interface Serializable { }

string genFields(T)()
{
  string s;
  s ~= "void serialize(";
  s ~= T.stringof;
  s ~= " obj) {\n";
  foreach(int i , e ; Fields!T) {
	 string field;
     field ~= "\"";
     field ~= FieldNameTuple!T[i];
     field ~= "=";
     field ~= "\";";
     s ~= "string field";
     s ~= i.stringof;
     s ~= " = ";
     s ~= field;
     s ~= "write(";
     s ~= "field";
     s ~= i.stringof;
     s ~= ");\n";
     s ~= "writeln(";
     s ~= "obj.";
     s ~= FieldNameTuple!T[i];
     s ~= ");\n";
  }
  s ~= "}\n";
  return s;
}

string generateSerializer(T)()
{
  alias TL = BaseTypeTuple!T;
  string s;
  foreach (e ; TL) {
  	static if(e.stringof == "Serializable") {  		
  		s = genFields!T;
  	}
  }
  return s;
}



class B1 : Serializable 
{
   int x;
   int y;
   int z;
   this() { x = 0; y = 0; z = 0; }
   this(int _x, int _y, int _z) { x = _x; y = _y; z = _z; }
}

mixin(generateSerializer!B1);

void main()
{
  //writeln(generateSerializer!B1);  
  B1 b1 = new B1(1,2,4);
  b1.serialize();
}
