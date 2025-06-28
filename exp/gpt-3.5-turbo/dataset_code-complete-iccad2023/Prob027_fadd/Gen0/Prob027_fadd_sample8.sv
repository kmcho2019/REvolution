module FullAdder (
  input a,
  input b,
  input cin,
  output cout,
  output sum
);

  // First Half Adder
  wire s1, c1;
  HalfAdder HA1 (.a(a), .b(b), .sum(s1), .cout(c1));
  
  // Second Half Adder
  wire s2, c2;
  HalfAdder HA2 (.a(s1), .b(cin), .sum(sum), .cout(c2));
  
  // Cout is the OR of two half adder carries
  assign cout = c1 | c2;
  
endmodule