module HalfAdder(
    input a,
    input b,
    output sum,
    output cout
);
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // First segment (bits 0-1) - ripple carry
    wire carry_low;
    wire [1:0] sum_low;
    
    HalfAdder ha0(
        .a(x[0]),
        .b(y[0]),
        .sum(sum_low[0]),
        .cout(carry_low)
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry_low),
        .sum(sum_low[1]),
        .cout(carry_mid)
    );
    
    // Second segment (bits 2-3) - carry-select
    // Case 1: carry_in = 0
    wire [1:0] sum_high_0;
    wire carry_high_0;
    
    HalfAdder ha2_0(
        .a(x[2]),
        .b(y[2]),
        .sum(sum_high_0[0]),
        .cout(c2_0)
    );
    
    HalfAdder ha3_0(
        .a(x[3]),
        .b(y[3]),
        .sum(sum_high_0[1]),
        .cout(c3_0)
    );
    
    assign carry_high_0 = c2_0 | (c3_0 & sum_high_0[0]);
    
    // Case 2: carry_in = 1
    wire [1:0] sum_high_1;
    wire carry_high_1;
    
    FullAdder fa2_1(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b1),
        .sum(sum_high_1[0]),
        .cout(c2_1)
    );
    
    FullAdder fa3_1(
        .a(x[3]),
        .b(y[3]),
        .cin(c2_1),
        .sum(sum_high_1[1]),
        .cout(carry_high_1)
    );
    
    // Select correct upper result based on actual carry
    assign sum[3:2] = carry_mid ? sum_high_1 : sum_high_0;
    assign sum[4] = carry_mid ? carry_high_1 : carry_high_0;
    
    // Lower bits directly connected
    assign sum[1:0] = sum_low;
endmodule