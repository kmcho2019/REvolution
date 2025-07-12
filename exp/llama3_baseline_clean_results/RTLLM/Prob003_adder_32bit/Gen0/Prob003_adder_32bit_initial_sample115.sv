// 1-bit full adder module
module full_adder(a, b, cin, s, cout);
  input a, b, cin;
  output s, cout;
  
  assign s = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit carry-lookahead adder module
module cla_4bit(a, b, cin, s, cout);
  input [3:0] a, b;
  input cin;
  output [3:0] s;
  output cout;
  
  wire [3:0] g, p;
  wire c1, c2, c3;
  
  // Calculate generate (G) and propagate (P) signals
  assign g[0] = a[0] & b[0];
  assign p[0] = a[0] ^ b[0];
  assign g[1] = a[1] & b[1];
  assign p[1] = a[1] ^ b[1];
  assign g[2] = a[2] & b[2];
  assign p[2] = a[2] ^ b[2];
  assign g[3] = a[3] & b[3];
  assign p[3] = a[3] ^ b[3];
  
  // Calculate carry signals
  assign c1 = g[0] | (p[0] & cin);
  assign c2 = g[1] | (p[1] & c1);
  assign c3 = g[2] | (p[2] & c2);
  assign cout = g[3] | (p[3] & c3);
  
  // Calculate sum signals
  full_adder fa0(a[0], b[0], cin, s[0], );
  full_adder fa1(a[1], b[1], c1, s[1], );
  full_adder fa2(a[2], b[2], c2, s[2], );
  full_adder fa3(a[3], b[3], c3, s[3], );
endmodule

// 16-bit carry-lookahead adder module
module cla_16bit(a, b, cin, s, cout);
  input [15:0] a, b;
  input cin;
  output [15:0] s;
  output cout;
  
  wire [7:0] s0, s1;
  wire c8;
  
  // Use two 8-bit blocks to create a 16-bit block
  cla_8bit cla0(a[7:0], b[7:0], cin, s0, c8);
  cla_8bit cla1(a[15:8], b[15:8], c8, s1, cout);
  
  assign s[7:0] = s0;
  assign s[15:8] = s1;
endmodule

// 8-bit carry-lookahead adder module
module cla_8bit(a, b, cin, s, cout);
  input [7:0] a, b;
  input cin;
  output [7:0] s;
  output cout;
  
  wire [7:0] g, p;
  wire c1, c2, c3, c4, c5, c6, c7;
  
  // Calculate generate (G) and propagate (P) signals
  assign g[0] = a[0] & b[0];
  assign p[0] = a[0] ^ b[0];
  assign g[1] = a[1] & b[1];
  assign p[1] = a[1] ^ b[1];
  assign g[2] = a[2] & b[2];
  assign p[2] = a[2] ^ b[2];
  assign g[3] = a[3] & b[3];
  assign p[3] = a[3] ^ b[3];
  assign g[4] = a[4] & b[4];
  assign p[4] = a[4] ^ b[4];
  assign g[5] = a[5] & b[5];
  assign p[5] = a[5] ^ b[5];
  assign g[6] = a[6] & b[6];
  assign p[6] = a[6] ^ b[6];
  assign g[7] = a[7] & b[7];
  assign p[7] = a[7] ^ b[7];
  
  // Calculate carry signals
  assign c1 = g[0] | (p[0] & cin);
  assign c2 = g[1] | (p[1] & c1);
  assign c3 = g[2] | (p[2] & c2);
  assign c4 = g[3] | (p[3] & c3);
  assign c5 = g[4] | (p[4] & c4);
  assign c6 = g[5] | (p[5] & c5);
  assign c7 = g[6] | (p[6] & c6);
  assign cout = g[7] | (p[7] & c7);
  
  // Calculate sum signals
  full_adder fa0(a[0], b[0], cin, s[0], );
  full_adder fa1(a[1], b[1], c1, s[1], );
  full_adder fa2(a[2], b[2], c2, s[2], );
  full_adder fa3(a[3], b[3], c3, s[3], );
  full_adder fa4(a[4], b[4], c4, s[4], );
  full_adder fa5(a[5], b[5], c5, s[5], );
  full_adder fa6(a[6], b[6], c6, s[6], );
  full_adder fa7(a[7], b[7], c7, s[7], );
endmodule

// 32-bit carry-lookahead adder module
module adder_32bit(A, B, S, C32);
  input [31:1] A, B;
  output [31:1] S;
  output C32;
  
  wire c16;
  
  // Use two 16-bit blocks to create a 32-bit block
  cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], c16);
  cla_16bit cla1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule