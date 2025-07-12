// 1-bit full adder
module full_adder(a, b, cin, s, cout);
  input a, b, cin;
  output s, cout;
  
  assign s = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit CLA
module cla_4bit(a, b, cin, s, cout);
  input [4:1] a, b;
  input cin;
  output [4:1] s;
  output cout;
  
  wire [3:1] c;
  
  full_adder fa1(a[1], b[1], cin, s[1], c[1]);
  full_adder fa2(a[2], b[2], c[1], s[2], c[2]);
  full_adder fa3(a[3], b[3], c[2], s[3], c[3]);
  full_adder fa4(a[4], b[4], c[3], s[4], cout);
endmodule

// 16-bit CLA
module cla_16bit(a, b, cin, s, cout);
  input [16:1] a, b;
  input cin;
  output [16:1] s;
  output cout;
  
  wire [16:1] c;
  wire [4:1] s1, s2, s3, s4;
  
  cla_4bit cla1(a[4:1], b[4:1], cin, s1, c[4]);
  cla_4bit cla2(a[8:5], b[8:5], c[4], s2, c[8]);
  cla_4bit cla3(a[12:9], b[12:9], c[8], s3, c[12]);
  cla_4bit cla4(a[16:13], b[16:13], c[12], s4, cout);
  
  assign s[4:1] = s1;
  assign s[8:5] = s2;
  assign s[12:9] = s3;
  assign s[16:13] = s4;
endmodule

// 32-bit CLA
module adder_32bit(A, B, S, C32);
  input [32:1] A, B;
  output [32:1] S;
  output C32;
  
  wire c16;
  
  cla_16bit cla1(A[16:1], B[16:1], 1'b0, S[16:1], c16);
  cla_16bit cla2(A[32:17], B[32:17], c16, S[32:17], C32);
endmodule