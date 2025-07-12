// Define a module for a 1-bit full adder
module full_adder(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;

    assign s = a ^ b ^ c_in;
    assign c_out = (a & b) | (a & c_in) | (b & c_in);
endmodule

// Define a module for a 4-bit carry-lookahead adder
module cla_4bit(a, b, c_in, s, c_out, p, g);
    input [3:0] a, b;
    input c_in;
    output [3:0] s;
    output c_out;
    output [3:0] p, g;

    wire [3:0] c;

    // Calculate the carry-generate and carry-propagate bits
    assign g[0] = a[0] & b[0];
    assign g[1] = a[1] & b[1];
    assign g[2] = a[2] & b[2];
    assign g[3] = a[3] & b[3];
    assign p[0] = a[0] | b[0];
    assign p[1] = a[1] | b[1];
    assign p[2] = a[2] | b[2];
    assign p[3] = a[3] | b[3];

    // Calculate the carries
    assign c[0] = c_in;
    assign c[1] = g[0] | (p[0] & c_in);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);

    assign c_out = g[3] | (p[3] & c[3]);

    // Calculate the sum
    assign s[0] = a[0] ^ b[0] ^ c_in;
    assign s[1] = a[1] ^ b[1] ^ c[1];
    assign s[2] = a[2] ^ b[2] ^ c[2];
    assign s[3] = a[3] ^ b[3] ^ c[3];
endmodule

// Define a module for a 16-bit carry-lookahead adder
module cla_16bit(a, b, c_in, s, c_out);
    input [15:0] a, b;
    input c_in;
    output [15:0] s;
    output c_out;

    wire [3:0] p0, g0, p1, g1, p2, g2, p3, g3;
    wire c0, c1, c2, c3;

    cla_4bit cla0(a[3:0], b[3:0], c_in, s[3:0], c0, p0, g0);
    cla_4bit cla1(a[7:4], b[7:4], c0, s[7:4], c1, p1, g1);
    cla_4bit cla2(a[11:8], b[11:8], c1, s[11:8], c2, p2, g2);
    cla_4bit cla3(a[15:12], b[15:12], c2, s[15:12], c3, p3, g3);

    assign c_out = c3;
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire c16;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit cla1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule