// Basic 1-bit full adder module
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Basic 4-bit carry-lookahead adder module
module cla_4bit(a, b, cin, s, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;
    wire [2:0] c;

    full_adder fa0(a[0], b[0], cin, s[0], c[0]);
    full_adder fa1(a[1], b[1], c[0], s[1], c[1]);
    full_adder fa2(a[2], b[2], c[1], s[2], c[2]);
    full_adder fa3(a[3], b[3], c[2], s[3], cout);
endmodule

// 16-bit carry-lookahead adder module using 4-bit CLA blocks
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    wire c0, c1, c2, c3;

    cla_4bit cla0(a[3:0], b[3:0], cin, s[3:0], c0);
    cla_4bit cla1(a[7:4], b[7:4], c0, s[7:4], c1);
    cla_4bit cla2(a[11:8], b[11:8], c1, s[11:8], c2);
    cla_4bit cla3(a[15:12], b[15:12], c2, s[15:12], cout);
endmodule

// Top module: 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;
    wire c16;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit cla1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule