// Define a module for a 1-bit full adder
module full_adder(a, b, cin, s, cout);
  input a, b, cin;
  output s, cout;
  
  assign s = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for a 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, s, cout, g, p);
  input [3:0] a, b;
  input cin;
  output [3:0] s;
  output cout;
  output [3:0] g, p;
  
  wire [3:0] g_int, p_int;
  wire [2:0] c_int;
  
  // Generate propagate and generate signals
  assign g_int[0] = a[0] & b[0];
  assign p_int[0] = a[0] | b[0];
  assign g_int[1] = a[1] & b[1];
  assign p_int[1] = a[1] | b[1];
  assign g_int[2] = a[2] & b[2];
  assign p_int[2] = a[2] | b[2];
  assign g_int[3] = a[3] & b[3];
  assign p_int[3] = a[3] | b[3];
  
  // Generate carry signals
  assign c_int[0] = g_int[0] | (p_int[0] & cin);
  assign c_int[1] = g_int[1] | (p_int[1] & c_int[0]);
  assign c_int[2] = g_int[2] | (p_int[2] & c_int[1]);
  
  // Compute sum
  full_adder fa0(a[0], b[0], cin, s[0], );
  full_adder fa1(a[1], b[1], c_int[0], s[1], );
  full_adder fa2(a[2], b[2], c_int[1], s[2], );
  full_adder fa3(a[3], b[3], c_int[2], s[3], );
  
  // Compute final carry-out
  assign cout = g_int[3] | (p_int[3] & c_int[2]);
  
  assign g = g_int;
  assign p = p_int;
endmodule

// Define a module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout, g, p);
  input [15:0] a, b;
  input cin;
  output [15:0] s;
  output cout;
  output [15:0] g, p;
  
  wire [15:0] g_int, p_int;
  wire [14:0] c_int;
  wire [3:0] g4, p4;
  
  // Split inputs into 4-bit chunks
  wire [3:0] a0, a1, a2, a3;
  wire [3:0] b0, b1, b2, b3;
  assign a0 = a[3:0];
  assign a1 = a[7:4];
  assign a2 = a[11:8];
  assign a3 = a[15:12];
  assign b0 = b[3:0];
  assign b1 = b[7:4];
  assign b2 = b[11:8];
  assign b3 = b[15:12];
  
  // Generate propagate and generate signals for each 4-bit chunk
  cla_4bit cla0(a0, b0, cin, s[3:0], c_int[0], g4, p4);
  cla_4bit cla1(a1, b1, c_int[0], s[7:4], c_int[1], g[3:0], p[3:0]);
  cla_4bit cla2(a2, b2, c_int[1], s[11:8], c_int[2], g[7:4], p[7:4]);
  cla_4bit cla3(a3, b3, c_int[2], s[15:12], cout, g[11:8], p[11:8]);
  
  assign g[15:12] = g4;
  assign p[15:12] = p4;
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
  input [32:1] A, B;
  output [32:1] S;
  output C32;
  
  wire [15:0] a0, a1;
  wire [15:0] b0, b1;
  wire [15:0] s0, s1;
  wire cout0;
  
  assign a0 = A[16:1];
  assign a1 = A[32:17];
  assign b0 = B[16:1];
  assign b1 = B[32:17];
  
  cla_16bit cla0(a0, b0, 1'b0, s0, cout0, , );
  cla_16bit cla1(a1, b1, cout0, s1, C32, , );
  
  assign S[16:1] = s0;
  assign S[32:17] = s1;
endmodule