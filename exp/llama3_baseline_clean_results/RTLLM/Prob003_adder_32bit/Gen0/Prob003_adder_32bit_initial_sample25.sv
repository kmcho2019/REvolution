// 1-bit full adder
module full_adder(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;

    assign s = a ^ b ^ c_in;
    assign c_out = (a & b) | (a & c_in) | (b & c_in);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, c_in, s, c_out);
    input [3:0] a, b;
    input c_in;
    output [3:0] s;
    output c_out;

    wire [2:0] c;

    assign c[0] = (a[0] & b[0]) | (a[0] & c_in) | (b[0] & c_in);
    assign c[1] = (a[1] & b[1]) | (a[1] & c[0]) | (b[1] & c[0]);
    assign c[2] = (a[2] & b[2]) | (a[2] & c[1]) | (b[2] & c[1]);
    assign c_out = (a[3] & b[3]) | (a[3] & c[2]) | (b[3] & c[2]);

    assign s[0] = a[0] ^ b[0] ^ c_in;
    assign s[1] = a[1] ^ b[1] ^ c[0];
    assign s[2] = a[2] ^ b[2] ^ c[1];
    assign s[3] = a[3] ^ b[3] ^ c[2];
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, c_in, s, c_out);
    input [15:0] a, b;
    input c_in;
    output [15:0] s;
    output c_out;

    wire c1, c2, c3;

    cla_4bit u0(.a(a[3:0]), .b(b[3:0]), .c_in(c_in), .s(s[3:0]), .c_out(c1));
    cla_4bit u1(.a(a[7:4]), .b(b[7:4]), .c_in(c1), .s(s[7:4]), .c_out(c2));
    cla_4bit u2(.a(a[11:8]), .b(b[11:8]), .c_in(c2), .s(s[11:8]), .c_out(c3));
    cla_4bit u3(.a(a[15:12]), .b(b[15:12]), .c_in(c3), .s(s[15:12]), .c_out(c_out));
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire c16;

    cla_16bit u0(.a(A[15:1]), .b(B[15:1]), .c_in(1'b0), .s(S[15:1]), .c_out(c16));
    cla_16bit u1(.a(A[31:16]), .b(B[31:16]), .c_in(c16), .s(S[31:16]), .c_out(C32));
endmodule