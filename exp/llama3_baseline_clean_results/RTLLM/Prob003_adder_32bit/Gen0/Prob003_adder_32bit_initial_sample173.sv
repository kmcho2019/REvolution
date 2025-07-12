// Define a 1-bit full adder module
module full_adder(a, b, cin, s, cout);
    input a, b, cin;
    output s, cout;

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a 4-bit CLA block
module cla_4bit(a, b, cin, s, cout, p, g);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;
    output [3:0] p, g;

    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];
    assign p[3] = a[3] ^ b[3];
    assign g[3] = a[3] & b[3];

    assign cout = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & cin))))));

    assign s[0] = p[0] ^ cin;
    assign s[1] = p[1] ^ (g[0] | (p[0] & cin));
    assign s[2] = p[2] ^ (g[1] | (p[1] & (g[0] | (p[0] & cin))));
    assign s[3] = p[3] ^ (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & cin))))));
endmodule

// Define a 16-bit CLA block
module cla_16bit(a, b, cin, s, cout, p, g);
    input [15:0] a, b;
    input cin;
    output [15:0] s;
    output cout;
    output [15:0] p, g;

    wire [3:0] p0, g0, p1, g1, p2, g2, p3, g3;
    wire cout0, cout1, cout2, cout3;

    cla_4bit cla0(a[3:0], b[3:0], cin, s[3:0], cout0, p0, g0);
    cla_4bit cla1(a[7:4], b[7:4], cout0, s[7:4], cout1, p1, g1);
    cla_4bit cla2(a[11:8], b[11:8], cout1, s[11:8], cout2, p2, g2);
    cla_4bit cla3(a[15:12], b[15:12], cout2, s[15:12], cout3, p3, g3);

    assign p = {p3, p2, p1, p0};
    assign g = {g3, g2, g1, g0};
    assign cout = cout3;
endmodule

// Define the 32-bit CLA adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire [15:0] s0, s1;
    wire cout0, cout1;
    wire [15:0] p0, g0, p1, g1;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, s0, cout0, p0, g0);
    cla_16bit cla1(A[31:16], B[31:16], cout0, s1, cout1, p1, g1);

    assign S[15:1] = s0;
    assign S[31:16] = s1;
    assign C32 = cout1;
endmodule