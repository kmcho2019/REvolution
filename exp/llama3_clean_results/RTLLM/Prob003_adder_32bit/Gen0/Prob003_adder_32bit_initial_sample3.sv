// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, s, cout);
    input [4:1] a, b;
    input cin;
    output [4:1] s;
    output cout;

    wire [3:1] c;

    full_adder fa1(a[1], b[1], cin, s[1], c[1]);
    full_adder fa2(a[2], b[2], c[1], s[2], c[2]);
    full_adder fa3(a[3], b[3], c[2], s[3], c[3]);
    full_adder fa4(a[4], b[4], c[3], s[4], cout);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, s, cout);
    input [16:1] a, b;
    input cin;
    output [16:1] s;
    output cout;

    wire [4:1] c1, c2, c3, c4;

    cla_4bit cla1(a[4:1], b[4:1], cin, s[4:1], c1[4]);
    cla_4bit cla2(a[8:5], b[8:5], c1[4], s[8:5], c2[4]);
    cla_4bit cla3(a[12:9], b[12:9], c2[4], s[12:9], c3[4]);
    cla_4bit cla4(a[16:13], b[16:13], c3[4], s[16:13], cout);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    wire c16;

    cla_16bit cla1(A[16:1], B[16:1], 1'b0, S[16:1], c16);
    cla_16bit cla2(A[32:17], B[32:17], c16, S[32:17], C32);
endmodule