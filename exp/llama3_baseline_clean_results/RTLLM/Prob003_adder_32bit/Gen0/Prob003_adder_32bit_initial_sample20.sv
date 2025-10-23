// 1-bit full adder
module full_adder(a, b, cin, s, cout);
  input a, b, cin;
  output s, cout;
  assign s = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit CLA
module cla_4bit(a, b, cin, s, cout);
  input [3:0] a, b;
  input cin;
  output [3:0] s;
  output cout;
  wire [3:0] p, g;
  wire [2:0] c;

  // compute propagate and generate signals
  assign p[0] = a[0] ^ b[0];
  assign g[0] = a[0] & b[0];
  assign p[1] = a[1] ^ b[1];
  assign g[1] = a[1] & b[1];
  assign p[2] = a[2] ^ b[2];
  assign g[2] = a[2] & b[2];
  assign p[3] = a[3] ^ b[3];
  assign g[3] = a[3] & b[3];

  // compute carry signals
  assign c[0] = g[0] | (p[0] & cin);
  assign c[1] = g[1] | (p[1] & c[0]);
  assign c[2] = g[2] | (p[2] & c[1]);

  // compute sum signals
  assign s[0] = p[0] ^ cin;
  assign s[1] = p[1] ^ c[0];
  assign s[2] = p[2] ^ c[1];
  assign s[3] = p[3] ^ c[2];

  assign cout = g[3] | (p[3] & c[2]);
endmodule

// 16-bit CLA using two 8-bit CLA
module cla_16bit(a, b, cin, s, cout);
  input [15:0] a, b;
  input cin;
  output [15:0] s;
  output cout;
  wire [7:0] s1, s2;
  wire c8;
  wire [15:0] p, g;
  cla_8bit cla1(a[7:0], b[7:0], cin, s1, c8);
  cla_8bit cla2(a[15:8], b[15:8], c8, s2, cout);
  assign s[7:0] = s1;
  assign s[15:8] = s2;
endmodule

// 8-bit CLA using two 4-bit CLA
module cla_8bit(a, b, cin, s, cout);
  input [7:0] a, b;
  input cin;
  output [7:0] s;
  output cout;
  wire [3:0] s1, s2;
  wire c4;
  cla_4bit cla1(a[3:0], b[3:0], cin, s1, c4);
  cla_4bit cla2(a[7:4], b[7:4], c4, s2, cout);
  assign s[3:0] = s1;
  assign s[7:4] = s2;
endmodule

// 32-bit CLA using two 16-bit CLA
module adder_32bit(A, B, S, C32);
  input [31:0] A, B;
  output [31:0] S;
  output C32;
  wire [15:0] s1, s2;
  wire c16;
  cla_16bit cla1(A[15:0], B[15:0], 1'b0, s1, c16);
  cla_16bit cla2(A[31:16], B[31:16], c16, s2, C32);
  assign S[15:0] = s1;
  assign S[31:16] = s2;
endmodule