// 1-bit full adder
module full_adder(a, b, c_in, s, c_out);
  input a, b, c_in;
  output s, c_out;

  assign s = a ^ b ^ c_in;
  assign c_out = (a & b) | (a & c_in) | (b & c_in);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, c_in, s, c_out);
  input [3:0] a, b;
  input c_in;
  output [3:0] s;
  output c_out;

  wire [3:0] g, p;
  wire [2:0] c;

  assign g[0] = a[0] & b[0];
  assign p[0] = a[0] | b[0];
  assign g[1] = a[1] & b[1];
  assign p[1] = a[1] | b[1];
  assign g[2] = a[2] & b[2];
  assign p[2] = a[2] | b[2];
  assign g[3] = a[3] & b[3];
  assign p[3] = a[3] | b[3];

  assign c[0] = g[0] | (p[0] & c_in);
  assign c[1] = g[1] | (p[1] & c[0]);
  assign c[2] = g[2] | (p[2] & c[1]);

  full_adder fa0(a[0], b[0], c_in, s[0], );
  full_adder fa1(a[1], b[1], c[0], s[1], );
  full_adder fa2(a[2], b[2], c[1], s[2], );
  full_adder fa3(a[3], b[3], c[2], s[3], c_out);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, c_in, s, c_out);
  input [15:0] a, b;
  input c_in;
  output [15:0] s;
  output c_out;

  wire [3:0] g, p;
  wire [15:0] s1, s2;
  wire c1, c2;

  cla_4bit cla1(a[3:0], b[3:0], c_in, s1[3:0], c1);
  cla_4bit cla2(a[7:4], b[7:4], c1, s1[7:4], c2);
  cla_4bit cla3(a[11:8], b[11:8], c2, s1[11:8], c1);
  cla_4bit cla4(a[15:12], b[15:12], c1, s1[15:12], c_out);

  assign s = s1;
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
  input [31:1] A, B;
  output [31:1] S;
  output C32;

  wire [15:0] s1, s2;
  wire c1;

  cla_16bit cla1(A[15:1], B[15:1], 1'b0, s1, c1);
  cla_16bit cla2(A[31:16], B[31:16], c1, s2, C32);

  assign S[15:1] = s1;
  assign S[31:16] = s2;
endmodule