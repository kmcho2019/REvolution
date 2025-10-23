// 1-bit full adder
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, sum, cout, p, g);
    input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output cout;
    output [3:0] p, g;
    wire [3:0] c;

    full_adder fa0(a[0], b[0], cin, sum[0], c[0]);
    full_adder fa1(a[1], b[1], c[0], sum[1], c[1]);
    full_adder fa2(a[2], b[2], c[1], sum[2], c[2]);
    full_adder fa3(a[3], b[3], c[2], sum[3], c[3]);

    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];
    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];

    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, sum, cout, p, g);
    input [15:0] a, b;
    input cin;
    output [15:0] sum;
    output cout;
    output [15:0] p, g;
    wire [3:0] c;
    wire [3:0] p1, g1, p2, g2, p3, g3, p4, g4;

    cla_4bit cla0(a[3:0], b[3:0], cin, sum[3:0], c[0], p1, g1);
    cla_4bit cla1(a[7:4], b[7:4], c[0], sum[7:4], c[1], p2, g2);
    cla_4bit cla2(a[11:8], b[11:8], c[1], sum[11:8], c[2], p3, g3);
    cla_4bit cla3(a[15:12], b[15:12], c[2], sum[15:12], cout, p4, g4);

    assign p[3:0] = p1;
    assign g[3:0] = g1;
    assign p[7:4] = p2;
    assign g[7:4] = g2;
    assign p[11:8] = p3;
    assign g[11:8] = g3;
    assign p[15:12] = p4;
    assign g[15:12] = g4;
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;
    wire c16;
    wire [15:0] p1, g1, p2, g2;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], c16, p1, g1);
    cla_16bit cla1(A[31:16], B[31:16], c16, S[31:16], C32, p2, g2);
endmodule