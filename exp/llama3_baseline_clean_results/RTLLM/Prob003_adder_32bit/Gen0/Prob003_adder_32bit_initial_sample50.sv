// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit CLA block
module cla_4bit(a, b, cin, s, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;

    wire [2:0] g, p;
    wire [1:0] c;

    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign c[0] = g[0] | (p[0] & cin);

    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] ^ b[1];
    assign c[1] = g[1] | (p[1] & c[0]);

    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] ^ b[2];
    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & c[0]);

    assign s[0] = a[0] ^ b[0] ^ cin;
    assign s[1] = a[1] ^ b[1] ^ c[0];
    assign s[2] = a[2] ^ b[2] ^ c[1];
    assign s[3] = a[3] ^ b[3] ^ (g[2] | (p[2] & c[1]));
    assign cout = g[2] | (p[2] & c[1]);
endmodule

// 16-bit CLA block
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;

    wire [7:0] g, p;
    wire [3:0] c;
    wire [3:0] cout_block;

    cla_4bit cla0(a[3:0], b[3:0], cin, s[3:0], c[0]);
    cla_4bit cla1(a[7:4], b[7:4], c[0], s[7:4], c[1]);
    cla_4bit cla2(a[11:8], b[11:8], c[1], s[11:8], c[2]);
    cla_4bit cla3(a[15:12], b[15:12], c[2], s[15:12], cout);
endmodule

// 32-bit CLA adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire c16;

    cla_16bit cla_low(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit cla_high(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule