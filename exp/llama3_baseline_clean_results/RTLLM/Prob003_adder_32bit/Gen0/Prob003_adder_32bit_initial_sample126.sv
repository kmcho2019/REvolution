// Module for a full adder
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Module for a 4-bit CLA
module cla_4bit(a, b, cin, sum, cout);
    input [3:0] a;
    input [3:0] b;
    input cin;
    output [3:0] sum;
    output cout;
    
    wire [2:0] g, p;
    wire [1:0] c;
    
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign c[0] = g[0] | (p[0] & cin);
    
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] ^ b[1];
    assign c[1] = g[1] | (p[1] & (g[0] | (p[0] & cin)));
    
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] ^ b[2];
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & (g[0] | (p[0] & cin)));
    
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ (g[0] | (p[0] & cin));
    assign sum[2] = a[2] ^ b[2] ^ (g[1] | (p[1] & (g[0] | (p[0] & cin))));
    assign sum[3] = a[3] ^ b[3] ^ (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & cin))))));
    
    assign cout = g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & cin)))));
endmodule

// Module for a 16-bit CLA
module cla_16bit(a, b, cin, sum, cout);
    input [15:0] a;
    input [15:0] b;
    input cin;
    output [15:0] sum;
    output cout;
    
    wire [3:0] g, p;
    wire [3:0] c;
    wire [15:0] sum0, sum1, sum2, sum3;
    wire cout0, cout1, cout2, cout3;
    
    cla_4bit cla0(a[3:0], b[3:0], cin, sum0[3:0], c[0]);
    cla_4bit cla1(a[7:4], b[7:4], c[0], sum0[7:4], c[1]);
    cla_4bit cla2(a[11:8], b[11:8], c[1], sum0[11:8], c[2]);
    cla_4bit cla3(a[15:12], b[15:12], c[2], sum0[15:12], c[3]);
    
    assign sum = sum0;
    assign cout = c[3];
endmodule

// Top module for a 32-bit CLA
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;
    
    wire [15:0] sum0;
    wire cout0;
    
    cla_16bit cla0(A[15:1], B[15:1], 1'b0, sum0, cout0);
    cla_16bit cla1(A[31:16], B[31:16], cout0, S[31:16], C32);
    
    assign S[15:1] = sum0;
endmodule