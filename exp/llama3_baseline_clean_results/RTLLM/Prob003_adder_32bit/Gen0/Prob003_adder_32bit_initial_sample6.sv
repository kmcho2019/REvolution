// 1-bit full adder
module full_adder(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;

    assign s = a ^ b ^ c_in;
    assign c_out = (a & b) | (a & c_in) | (b & c_in);

endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, c_in, s, c_out, g, p);
    input [3:0] a, b;
    input c_in;
    output [3:0] s;
    output c_out;
    output [3:0] g, p;

    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];

    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];

    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];

    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];

    assign c_out = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & c_in)))))));

    assign s[0] = p[0] ^ c_in;
    assign s[1] = p[1] ^ (g[0] | (p[0] & c_in));
    assign s[2] = p[2] ^ (g[1] | (p[1] & (g[0] | (p[0] & c_in))));
    assign s[3] = p[3] ^ (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & c_in))))));

endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, c_in, s, c_out);
    input [15:0] a, b;
    input c_in;
    output [15:0] s;
    output c_out;

    wire [3:0] g1, p1;
    wire [3:0] g2, p2;
    wire [3:0] g3, p3;
    wire [3:0] g4, p4;
    wire c1, c2, c3;

    cla_4bit u1(a[3:0], b[3:0], c_in, s[3:0], c1, g1, p1);
    cla_4bit u2(a[7:4], b[7:4], c1, s[7:4], c2, g2, p2);
    cla_4bit u3(a[11:8], b[11:8], c2, s[11:8], c3, g3, p3);
    cla_4bit u4(a[15:12], b[15:12], c3, s[15:12], c_out, g4, p4);

endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire c16;

    cla_16bit u1(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit u2(A[31:16], B[31:16], c16, S[31:16], C32);

endmodule