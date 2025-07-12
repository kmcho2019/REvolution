// Define a module for a 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for a 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, s, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;
    wire [2:0] g, p;
    wire [1:0] c;

    // Generate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] | b[2];

    // Calculate carry signals
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & (g[0] | (p[0] & cin)));
    assign c[2] = g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & cin)))));

    // Calculate sum signals
    assign s[0] = a[0] ^ b[0] ^ cin;
    assign s[1] = a[1] ^ b[1] ^ c[0];
    assign s[2] = a[2] ^ b[2] ^ c[1];
    assign s[3] = a[3] ^ b[3] ^ c[2];

    // Calculate final carry-out
    assign cout = g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & cin)))));
endmodule

// Define a module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    wire c1, c2, c3;
    cla_4bit cla0(a[3:0], b[3:0], cin, s[3:0], c1);
    cla_4bit cla1(a[7:4], b[7:4], c1, s[7:4], c2);
    cla_4bit cla2(a[11:8], b[11:8], c2, s[11:8], c3);
    cla_4bit cla3(a[15:12], b[15:12], c3, s[15:12], cout);
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:0] A, B;
    output [31:0] S;
    output C32;
    wire c16;
    cla_16bit cla0(A[15:0], B[15:0], 1'b0, S[15:0], c16);
    cla_16bit cla1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule