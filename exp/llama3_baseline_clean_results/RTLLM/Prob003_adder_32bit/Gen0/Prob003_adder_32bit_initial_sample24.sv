// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, s, cout);
    input [3:0] a;
    input [3:0] b;
    input cin;
    output [3:0] s;
    output cout;
    wire [2:0] g, p;
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] | b[2];
    wire c1, c2, c3;
    assign c1 = g[0] | (p[0] & cin);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign cout = g[2] | (p[2] & c2);
    full_adder fa0(a[0], b[0], cin, s[0], );
    full_adder fa1(a[1], b[1], c1, s[1], );
    full_adder fa2(a[2], b[2], c2, s[2], );
    full_adder fa3(a[3], b[3], c3, s[3], );
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a;
    input [15:0] b;
    input cin;
    output [15:0] s;
    output cout;
    wire [3:0] g, p;
    assign g[0] = (a[3] & b[3]) | (a[2] & b[2]) | (a[1] & b[1]) | (a[0] & b[0]);
    assign p[0] = (a[3] | b[3]) & (a[2] | b[2]) & (a[1] | b[1]) & (a[0] | b[0]);
    assign g[1] = (a[7] & b[7]) | (a[6] & b[6]) | (a[5] & b[5]) | (a[4] & b[4]);
    assign p[1] = (a[7] | b[7]) & (a[6] | b[6]) & (a[5] | b[5]) & (a[4] | b[4]);
    assign g[2] = (a[11] & b[11]) | (a[10] & b[10]) | (a[9] & b[9]) | (a[8] & b[8]);
    assign p[2] = (a[11] | b[11]) & (a[10] | b[10]) & (a[9] | b[9]) & (a[8] | b[8]);
    assign g[3] = (a[15] & b[15]) | (a[14] & b[14]) | (a[13] & b[13]) | (a[12] & b[12]);
    assign p[3] = (a[15] | b[15]) & (a[14] | b[14]) & (a[13] | b[13]) & (a[12] | b[12]);
    wire c4, c8, c12;
    assign c4 = g[0] | (p[0] & cin);
    assign c8 = g[1] | (p[1] & c4);
    assign c12 = g[2] | (p[2] & c8);
    assign cout = g[3] | (p[3] & c12);
    cla_4bit cla0(a[3:0], b[3:0], cin, s[3:0], );
    cla_4bit cla1(a[7:4], b[7:4], c4, s[7:4], );
    cla_4bit cla2(a[11:8], b[11:8], c8, s[11:8], );
    cla_4bit cla3(a[15:12], b[15:12], c12, s[15:12], );
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;
    wire c16;
    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit cla1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule