// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, s, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;

    wire [3:0] g, p;
    wire c1, c2, c3;

    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] ^ b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] ^ b[2];
    assign g[3] = a[3] & b[3];
    assign p[3] = a[3] ^ b[3];

    assign c1 = g[0] | (p[0] & cin);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);

    assign cout = g[3] | (p[3] & c3);

    assign s[0] = p[0] ^ cin;
    assign s[1] = p[1] ^ c1;
    assign s[2] = p[2] ^ c2;
    assign s[3] = p[3] ^ c3;
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;

    wire [3:0] g, p;
    wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;

    // First 4-bit block
    cla_4bit u1(a[3:0], b[3:0], cin, s[3:0], c4);

    // Second 4-bit block
    cla_4bit u2(a[7:4], b[7:4], c4, s[7:4], c8);

    // Third 4-bit block
    cla_4bit u3(a[11:8], b[11:8], c8, s[11:8], c12);

    // Fourth 4-bit block
    cla_4bit u4(a[15:12], b[15:12], c12, s[15:12], cout);
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