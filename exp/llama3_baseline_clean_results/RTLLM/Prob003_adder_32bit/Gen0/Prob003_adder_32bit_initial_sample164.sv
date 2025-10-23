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
    wire [3:0] p, g;
    wire [2:0] c;

    // Calculate propagate and generate signals
    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];
    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];

    // Calculate carry signals
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);

    // Calculate sum signals
    assign s[0] = a[0] ^ b[0] ^ cin;
    assign s[1] = a[1] ^ b[1] ^ c[0];
    assign s[2] = a[2] ^ b[2] ^ c[1];
    assign s[3] = a[3] ^ b[3] ^ c[2];

    assign cout = g[3] | (p[3] & c[2]);
endmodule

// Define a module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    wire [15:0] p, g;
    wire [14:0] c;

    // Calculate propagate and generate signals
    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];
    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];
    assign p[4] = a[4] ^ b[4];
    assign g[4] = a[4] & b[4];
    assign p[5] = a[5] ^ b[5];
    assign g[5] = a[5] & b[5];
    assign p[6] = a[6] ^ b[6];
    assign g[6] = a[6] & b[6];
    assign p[7] = a[7] ^ b[7];
    assign g[7] = a[7] & b[7];
    assign p[8] = a[8] ^ b[8];
    assign g[8] = a[8] & b[8];
    assign p[9] = a[9] ^ b[9];
    assign g[9] = a[9] & b[9];
    assign p[10] = a[10] ^ b[10];
    assign g[10] = a[10] & b[10];
    assign p[11] = a[11] ^ b[11];
    assign g[11] = a[11] & b[11];
    assign p[12] = a[12] ^ b[12];
    assign g[12] = a[12] & b[12];
    assign p[13] = a[13] ^ b[13];
    assign g[13] = a[13] & b[13];
    assign p[14] = a[14] ^ b[14];
    assign g[14] = a[14] & b[14];
    assign p[15] = a[15] ^ b[15];
    assign g[15] = a[15] & b[15];

    // Calculate carry signals
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    assign c[4] = g[4] | (p[4] & c[3]);
    assign c[5] = g[5] | (p[5] & c[4]);
    assign c[6] = g[6] | (p[6] & c[5]);
    assign c[7] = g[7] | (p[7] & c[6]);
    assign c[8] = g[8] | (p[8] & c[7]);
    assign c[9] = g[9] | (p[9] & c[8]);
    assign c[10] = g[10] | (p[10] & c[9]);
    assign c[11] = g[11] | (p[11] & c[10]);
    assign c[12] = g[12] | (p[12] & c[11]);
    assign c[13] = g[13] | (p[13] & c[12]);
    assign c[14] = g[14] | (p[14] & c[13]);

    // Calculate sum signals
    assign s[0] = a[0] ^ b[0] ^ cin;
    assign s[1] = a[1] ^ b[1] ^ c[0];
    assign s[2] = a[2] ^ b[2] ^ c[1];
    assign s[3] = a[3] ^ b[3] ^ c[2];
    assign s[4] = a[4] ^ b[4] ^ c[3];
    assign s[5] = a[5] ^ b[5] ^ c[4];
    assign s[6] = a[6] ^ b[6] ^ c[5];
    assign s[7] = a[7] ^ b[7] ^ c[6];
    assign s[8] = a[8] ^ b[8] ^ c[7];
    assign s[9] = a[9] ^ b[9] ^ c[8];
    assign s[10] = a[10] ^ b[10] ^ c[9];
    assign s[11] = a[11] ^ b[11] ^ c[10];
    assign s[12] = a[12] ^ b[12] ^ c[11];
    assign s[13] = a[13] ^ b[13] ^ c[12];
    assign s[14] = a[14] ^ b[14] ^ c[13];
    assign s[15] = a[15] ^ b[15] ^ c[14];

    assign cout = g[15] | (p[15] & c[14]);
endmodule

// Define the 32-bit adder module
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire C16;

    // Instance the first 16-bit adder
    cla_16bit cla1(A[15:1], B[15:1], 1'b0, S[15:1], C16);

    // Instance the second 16-bit adder
    cla_16bit cla2(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule