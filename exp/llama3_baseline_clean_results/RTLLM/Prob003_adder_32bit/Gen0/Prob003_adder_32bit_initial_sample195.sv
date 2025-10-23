// 1-bit full adder module
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit carry-lookahead adder module
module cla_4bit(a, b, cin, s, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;

    wire p0, g0, p1, g1, p2, g2, p3, g3;
    wire c1, c2, c3;

    // Calculate p and g values
    assign p0 = a[0] ^ b[0];
    assign g0 = a[0] & b[0];
    assign p1 = a[1] ^ b[1];
    assign g1 = a[1] & b[1];
    assign p2 = a[2] ^ b[2];
    assign g2 = a[2] & b[2];
    assign p3 = a[3] ^ b[3];
    assign g3 = a[3] & b[3];

    // Calculate carry values
    assign c1 = g0 | (p0 & cin);
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & c2);

    // Calculate sum values
    assign s[0] = p0 ^ cin;
    assign s[1] = p1 ^ c1;
    assign s[2] = p2 ^ c2;
    assign s[3] = p3 ^ c3;
    assign cout = g3 | (p3 & c3);
endmodule

// 16-bit carry-lookahead adder module
module cla_16bit(a, b, cin, s, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;

    wire [3:0] a0, a1, a2, a3;
    wire [3:0] b0, b1, b2, b3;
    wire [3:0] s0, s1, s2, s3;
    wire c1, c2, c3, c4;

    assign a0 = a[3:0];
    assign a1 = a[7:4];
    assign a2 = a[11:8];
    assign a3 = a[15:12];
    assign b0 = b[3:0];
    assign b1 = b[7:4];
    assign b2 = b[11:8];
    assign b3 = b[15:12];

    cla_4bit cla0(a0, b0, cin, s0, c1);
    cla_4bit cla1(a1, b1, c1, s1, c2);
    cla_4bit cla2(a2, b2, c2, s2, c3);
    cla_4bit cla3(a3, b3, c3, s3, c4);

    assign s[3:0] = s0;
    assign s[7:4] = s1;
    assign s[11:8] = s2;
    assign s[15:12] = s3;
    assign cout = c4;
endmodule

// 32-bit carry-lookahead adder module
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire [15:0] a0, a1;
    wire [15:0] b0, b1;
    wire [15:0] s0, s1;
    wire c0;

    assign a0 = A[15:1];
    assign a1 = A[31:16];
    assign b0 = B[15:1];
    assign b1 = B[31:16];

    cla_16bit cla0(a0, b0, 1'b0, s0, c0);
    cla_16bit cla1(a1, b1, c0, s1, C32);

    assign S[15:1] = s0;
    assign S[31:16] = s1;
endmodule