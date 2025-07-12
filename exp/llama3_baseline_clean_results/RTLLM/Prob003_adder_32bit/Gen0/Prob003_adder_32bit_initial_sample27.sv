// 1-bit full adder module
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit CLA block module
module cla_block_4bit(a, b, cin, s, cout, g, p);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;
    output g;
    output [3:0] p;

    assign g = a[3] & b[3];
    assign p[0] = a[0] ^ b[0];
    assign p[1] = a[1] ^ b[1];
    assign p[2] = a[2] ^ b[2];
    assign p[3] = a[3] ^ b[3];

    full_adder fa0(a[0], b[0], cin, s[0], s[1]);
    full_adder fa1(a[1], b[1], s[1], s[1], s[2]);
    full_adder fa2(a[2], b[2], s[2], s[2], s[3]);
    full_adder fa3(a[3], b[3], s[3], s[3], cout);
endmodule

// 16-bit CLA block module
module cla_block_16bit(a, b, cin, s, cout, g, p);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    output g;
    output [15:0] p;

    wire [3:0] g_block;
    wire [3:0] p_block;

    cla_block_4bit block0(a[3:0], b[3:0], cin, s[3:0], g_block[0], g_block[0], p_block);
    cla_block_4bit block1(a[7:4], b[7:4], g_block[0], s[7:4], g_block[1], g_block[1], p_block);
    cla_block_4bit block2(a[11:8], b[11:8], g_block[1], s[11:8], g_block[2], g_block[2], p_block);
    cla_block_4bit block3(a[15:12], b[15:12], g_block[2], s[15:12], cout, g_block[3], p_block);

    assign g = g_block[3];
    assign p = p_block;
endmodule

// 32-bit carry-lookahead adder module
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire cout_mid;

    cla_block_16bit block_low(A[15:1], B[15:1], 1'b0, S[15:1], cout_mid, , );
    cla_block_16bit block_high(A[31:16], B[31:16], cout_mid, S[31:16], C32, , );
endmodule