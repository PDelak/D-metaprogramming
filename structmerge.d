import std.stdio;
import std.traits;
import std.typetuple;
import std.range;

struct S1 { int x; float y; }
struct S2 { int x2; float y2; S1 s1; }

string genFields(T)()
{
  string s;
  foreach(int i , e ; Fields!T) {
     static if(i > 0) s ~= "; ";
     s ~= e.stringof;
     s ~= " ";
     s ~= FieldNameTuple!T[i];
  }
  s ~= ";";  
  return s;
}

string mergeTypesImpl(T1, T2)()
{
  string s = "struct Result {";
  s ~= genFields!(T1);
  s ~= genFields!(T2);
  s ~= "};";
  return s;
}

Result copyMembers(T, Result)(T arg, Result result)
{
  foreach(memberName; __traits(allMembers, T)) {
      static if(!hasIndirections!(typeof(__traits(getMember, arg, memberName))))
          __traits(getMember, result, memberName) = __traits(getMember, arg, memberName);
      else
          __traits(getMember, result, memberName) = __traits(getMember, arg, memberName).dup;
  }  
  return result;
}

auto mergeTypes (T1, T2) (T1 arg1, T2 arg2) 
{
  string s = mergeTypesImpl!(T1, T2);
  writeln(s);
  mixin(mergeTypesImpl!(T1, T2));
  Result result;
  
  result = copyMembers(arg1, result); 
  result = copyMembers(arg2, result); 
  
  return result;
}

void main()
{
  S1 s1;
  s1.x = 4;
  S2 s2;
  s2.x2 = 5;
  auto r = mergeTypes(s1, s2);
  writeln(r.x);
  writeln(r.x2);
}