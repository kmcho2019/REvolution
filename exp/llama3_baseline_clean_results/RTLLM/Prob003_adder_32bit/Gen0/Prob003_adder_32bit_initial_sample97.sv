// 1-bit full adder
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, sum, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output cout;
    wire [2:0] g, p, c;

    // calculate generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] ^ b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] ^ b[2];
    assign g[3] = a[3] & b[3];
    assign p[3] = a[3] ^ b[3];

    // calculate carry signals
    full_adder fa0(a[0], b[0], cin, sum[0], c[0]);
    assign c[1] = g[0] | (p[0] & c[0]);
    full_adder fa1(a[1], b[1], c[0], sum[1], c[1]);
    assign c[2] = g[1] | (p[1] & c[1]);
    full_adder fa2(a[2], b[2], c[1], sum[2], c[2]);
    assign c[3] = g[2] | (p[2] & c[2]);
    full_adder fa3(a[3], b[3], c[2], sum[3], c[3]);

    assign cout = g[3] | (p[3] & c[3]);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, sum, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] sum;
    output cout;
    wire c4, c8, c12;

    cla_4bit cla0(a[3:0], b[3:0], cin, sum[3:0], c4);
    cla_4bit cla1(a[7:4], b[7:4], c4, sum[7:4], c8);
    cla_4bit cla2(a[11:8], b[11:8], c8, sum[11:8], c12);
    cla_4bit cla3(a[15:12], b[15:12], c12, sum[15:12], cout);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;
    wire c16;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit cla1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule