module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    wire axorb = a ^ b;
    assign sum = axorb ^ cin;
    assign cout = (a & b) | (axorb & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2-bit adder (bits 0-1)
    wire [1:0] sum_low;
    wire carry_low;
    
    FullAdder fa0(x[0], y[0], 1'b0, sum_low[0], c0);
    FullAdder fa1(x[1], y[1], c0, sum_low[1], carry_low);
    
    // Upper 2-bit adders (bits 2-3) with both carry possibilities
    wire [1:0] sum_high_0, sum_high_1;
    wire carry_high_0, carry_high_1;
    
    // Case when carry-in is 0
    FullAdder fa2_0(x[2], y[2], 1'b0, sum_high_0[0], c2_0);
    FullAdder fa3_0(x[3], y[3], c2_0, sum_high_0[1], carry_high_0);
    
    // Case when carry-in is 1
    FullAdder fa2_1(x[2], y[2], 1'b1, sum_high_1[0], c2_1);
    FullAdder fa3_1(x[3], y[3], c2_1, sum_high_1[1], carry_high_1);
    
    // Select correct upper result based on actual carry from lower bits
    assign sum[2] = carry_low ? sum_high_1[0] : sum_high_0[0];
    assign sum[3] = carry_low ? sum_high_1[1] : sum_high_0[1];
    assign sum[4] = carry_low ? carry_high_1 : carry_high_0;
    
    // Lower bits pass through directly
    assign sum[1:0] = sum_low;
endmodule