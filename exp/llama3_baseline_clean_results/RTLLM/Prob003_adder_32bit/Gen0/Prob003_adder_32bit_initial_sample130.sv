// 1-bit Full Adder
module full_adder(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;
    wire sum, carry;

    assign sum = a ^ b ^ c_in;
    assign carry = (a & b) | (a & c_in) | (b & c_in);

    assign s = sum;
    assign c_out = carry;
endmodule

// 4-bit Carry-Lookahead Adder
module cla_4bit(a, b, c_in, s, c_out, p, g);
    input [3:0] a, b;
    input c_in;
    output [3:0] s;
    output c_out;
    output [3:0] p, g;

    wire c1, c2, c3;

    full_adder fa0(a[0], b[0], c_in, s[0], c1);
    full_adder fa1(a[1], b[1], c1, s[1], c2);
    full_adder fa2(a[2], b[2], c2, s[2], c3);
    full_adder fa3(a[3], b[3], c3, s[3], c_out);

    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];

    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];

    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];

    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];
endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(a, b, c_in, s, c_out);
    input [15:0] a, b;
    input c_in;
    output [15:0] s;
    output c_out;

    wire [3:0] p, g;
    wire c4, c8, c12;

    cla_4bit cla0(a[3:0], b[3:0], c_in, s[3:0], c4, p, g);
    cla_4bit cla1(a[7:4], b[7:4], c4, s[7:4], c8, p, g);
    cla_4bit cla2(a[11:8], b[11:8], c8, s[11:8], c12, p, g);
    cla_4bit cla3(a[15:12], b[15:12], c12, s[15:12], c_out, p, g);
endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire c16;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit cla1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule