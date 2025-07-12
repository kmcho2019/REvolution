// Define a module for a 1-bit full adder
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for a 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, sum, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output cout;

    wire [3:0] g, p;
    wire [2:0] c;

    // Generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] | b[2];
    assign g[3] = a[3] & b[3];
    assign p[3] = a[3] | b[3];

    // Carry signals
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);

    // Sum signals
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ c[0];
    assign sum[2] = a[2] ^ b[2] ^ c[1];
    assign sum[3] = a[3] ^ b[3] ^ c[2];

    // Final carry-out
    assign cout = g[3] | (p[3] & c[2]);
endmodule

// Define a module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, sum, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] sum;
    output cout;

    wire [3:0] g0, g1, g2, g3;
    wire [3:0] p0, p1, p2, p3;
    wire c0, c1, c2, c3;

    cla_4bit cla0(a[3:0], b[3:0], cin, sum[3:0], c0);
    cla_4bit cla1(a[7:4], b[7:4], c0, sum[7:4], c1);
    cla_4bit cla2(a[11:8], b[11:8], c1, sum[11:8], c2);
    cla_4bit cla3(a[15:12], b[15:12], c2, sum[15:12], cout);
endmodule

// Define the top-level 32-bit adder module
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire c16;

    cla_16bit cla_lo(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit cla_hi(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule