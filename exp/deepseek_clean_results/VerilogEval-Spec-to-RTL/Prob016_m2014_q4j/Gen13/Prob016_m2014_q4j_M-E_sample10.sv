module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Lower 2 bits (ripple carry)
    wire c1;
    FullAdder fa0 (x[0], y[0], 1'b0, sum[0], c1);
    FullAdder fa1 (x[1], y[1], c1, sum[1], c_lower);
    
    // Upper 2 bits computed in parallel for both carry cases
    wire [1:0] sum_upper_c0, sum_upper_c1;
    wire c_upper_c0, c_upper_c1;
    
    // Case when carry-in is 0
    FullAdder fa2_c0 (x[2], y[2], 1'b0, sum_upper_c0[0], c2_c0);
    FullAdder fa3_c0 (x[3], y[3], c2_c0, sum_upper_c0[1], c_upper_c0);
    
    // Case when carry-in is 1
    FullAdder fa2_c1 (x[2], y[2], 1'b1, sum_upper_c1[0], c2_c1);
    FullAdder fa3_c1 (x[3], y[3], c2_c1, sum_upper_c1[1], c_upper_c1);
    
    // Select correct upper result based on lower carry
    assign {sum[3:2], sum[4]} = c_lower ? 
                                {sum_upper_c1, c_upper_c1} : 
                                {sum_upper_c0, c_upper_c0};
endmodule