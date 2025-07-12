// 1-bit full adder
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit CLA block
module cla_4bit(a, b, cin, s, cout, g, p);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;
    output g;
    output [3:0] p;

    wire [3:0] g_int;
    wire [3:0] p_int;
    wire [3:0] c_int;

    assign g_int[0] = a[0] & b[0];
    assign p_int[0] = a[0] | b[0];
    assign c_int[0] = cin;

    full_adder fa0(a[0], b[0], cin, s[0], c_int[0]);

    assign g_int[1] = a[1] & b[1];
    assign p_int[1] = a[1] | b[1];
    assign c_int[1] = g_int[0] | (p_int[0] & c_int[0]);

    full_adder fa1(a[1], b[1], c_int[0], s[1], c_int[1]);

    assign g_int[2] = a[2] & b[2];
    assign p_int[2] = a[2] | b[2];
    assign c_int[2] = g_int[1] | (p_int[1] & c_int[1]);

    full_adder fa2(a[2], b[2], c_int[1], s[2], c_int[2]);

    assign g_int[3] = a[3] & b[3];
    assign p_int[3] = a[3] | b[3];
    assign c_int[3] = g_int[2] | (p_int[2] & c_int[2]);

    full_adder fa3(a[3], b[3], c_int[2], s[3], c_int[3]);

    assign g = g_int[3];
    assign p = p_int;
    assign cout = c_int[3];
endmodule

// 16-bit CLA block
module cla_16bit(a, b, cin, s, cout, g, p);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    output g;
    output [15:0] p;

    wire [3:0] g_int;
    wire [3:0] p_int;
    wire [3:0] c_int;

    cla_4bit cla0(a[3:0], b[3:0], cin, s[3:0], c_int[0], g_int[0], p_int[0]);
    cla_4bit cla1(a[7:4], b[7:4], c_int[0], s[7:4], c_int[1], g_int[1], p_int[1]);
    cla_4bit cla2(a[11:8], b[11:8], c_int[1], s[11:8], c_int[2], g_int[2], p_int[2]);
    cla_4bit cla3(a[15:12], b[15:12], c_int[2], s[15:12], c_int[3], g_int[3], p_int[3]);

    assign g = g_int[3];
    assign p = {p_int[3], p_int[2], p_int[1], p_int[0]};
    assign cout = c_int[3];
endmodule

// 32-bit CLA adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire [15:0] s0;
    wire [15:0] s1;
    wire g0;
    wire g1;
    wire cout0;
    wire cout1;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, s0, cout0, g0, );
    cla_16bit cla1(A[31:16], B[31:16], cout0, s1, cout1, g1, );

    assign S[15:1] = s0;
    assign S[31:16] = s1;
    assign C32 = cout1;
endmodule