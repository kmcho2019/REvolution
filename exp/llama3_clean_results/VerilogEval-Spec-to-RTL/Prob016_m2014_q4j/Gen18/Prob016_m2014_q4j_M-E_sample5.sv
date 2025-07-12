// 2-bit Ripple-Carry Adder module
module RCA2(a, b, cin, sum, cout);
    input [1:0] a;
    input [1:0] b;
    input cin;
    output [1:0] sum;
    output cout;
    
    // FullAdder modules for the 2-bit ripple-carry adder
    wire c1;
    FullAdder fa0(a[0], b[0], cin, sum[0], c1);
    FullAdder fa1(a[1], b[1], c1, sum[1], cout);
endmodule

// 2-bit Carry-Lookahead Adder module
module CLA2(a, b, cin, sum, cout);
    input [1:0] a;
    input [1:0] b;
    input cin;
    output [1:0] sum;
    output cout;
    
    // Generate and propagate signals
    wire g0, g1;
    wire p0, p1;
    
    assign g0 = a[0] & b[0];
    assign p0 = a[0] ^ b[0];
    assign g1 = a[1] & b[1];
    assign p1 = a[1] ^ b[1];
    
    // Calculate carry signals
    wire c1, c2;
    assign c1 = g0;
    assign c2 = g1 | (p1 & c1);
    
    // Calculate sum signals
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign cout = c2;
endmodule

// Hierarchical Carry-Chain (HCC) 4-bit Adder module
module TopModule(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;
    
    // 2-bit Ripple-Carry Adders for the first stage
    wire [1:0] sum0, sum1;
    wire c0, c1;
    RCA2 rca0(x[1:0], y[1:0], 1'b0, sum0, c0);
    RCA2 rca1(x[3:2], y[3:2], 1'b0, sum1, c1);
    
    // 2-bit Carry-Lookahead Adder for the second stage
    wire [1:0] sum2;
    wire cout;
    CLA2 cla2(sum0, sum1, c0, sum2, cout);
    
    // Assign the final sum and overflow bit
    assign sum[3:0] = {sum2[1], sum2[0]};
    assign sum[4] = cout;
endmodule

// FullAdder module used in the RCA2 and CLA2 modules
module FullAdder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule