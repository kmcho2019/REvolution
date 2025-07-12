// Define a module for a 1-bit full adder
module full_adder(a, b, cin, sum, cout);
  input a, b, cin;
  output sum, cout;
  
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for a 4-bit CLA block
module cla_4bit(a, b, cin, sum, cout);
  input [3:0] a, b;
  input cin;
  output [3:0] sum;
  output cout;
  
  wire p, g, c1, c2, c3;
  
  assign p = a[0] ^ b[0];
  assign g = a[0] & b[0];
  assign c1 = g | (p & cin);
  assign sum[0] = p ^ cin;
  
  assign p = a[1] ^ b[1];
  assign g = a[1] & b[1];
  assign c2 = g | (p & c1);
  assign sum[1] = p ^ c1;
  
  assign p = a[2] ^ b[2];
  assign g = a[2] & b[2];
  assign c3 = g | (p & c2);
  assign sum[2] = p ^ c2;
  
  assign p = a[3] ^ b[3];
  assign g = a[3] & b[3];
  assign cout = g | (p & c3);
  assign sum[3] = p ^ c3;
endmodule

// Define a module for a 16-bit CLA block
module cla_16bit(a, b, cin, sum, cout);
  input [15:0] a, b;
  input cin;
  output [15:0] sum;
  output cout;
  
  wire c4, c8, c12;
  
  cla_4bit u1(a[3:0], b[3:0], cin, sum[3:0], c4);
  cla_4bit u2(a[7:4], b[7:4], c4, sum[7:4], c8);
  cla_4bit u3(a[11:8], b[11:8], c8, sum[11:8], c12);
  cla_4bit u4(a[15:12], b[15:12], c12, sum[15:12], cout);
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
  input [31:1] A, B;
  output [31:1] S;
  output C32;
  
  wire c16;
  
  cla_16bit u1(A[15:1], B[15:1], 1'b0, S[15:1], c16);
  cla_16bit u2(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule