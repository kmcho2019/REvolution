module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // Optimized implementation using compound gates
    wire ab_xor = a ^ b;
    assign sum = ab_xor ^ cin;
    assign cout = (a & b) | (ab_xor & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [1:0] carry;  // Only need carry between blocks
    
    // Lower 2 bits (0-1) - ripple carry
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );
    
    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );
    
    // Upper 2 bits (2-3) - carry-select
    wire sum2_c0, sum2_c1;
    wire sum3_c0, sum3_c1;
    
    // Calculate both possible cases for carry-in
    FullAdder fa2_c0(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b0),
        .sum(sum2_c0),
        .cout(sum3_c0)
    );
    
    FullAdder fa2_c1(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b1),
        .sum(sum2_c1),
        .cout(sum3_c1)
    );
    
    FullAdder fa3_c0(
        .a(x[3]),
        .b(y[3]),
        .cin(sum3_c0),
        .sum(sum3_c0),
        .cout(sum[4])
    );
    
    FullAdder fa3_c1(
        .a(x[3]),
        .b(y[3]),
        .cin(sum3_c1),
        .sum(sum3_c1),
        .cout(sum[4])
    );
    
    // Mux the correct results based on actual carry-in
    assign sum[2] = carry[1] ? sum2_c1 : sum2_c0;
    assign sum[3] = carry[1] ? sum3_c1 : sum3_c0;
endmodule