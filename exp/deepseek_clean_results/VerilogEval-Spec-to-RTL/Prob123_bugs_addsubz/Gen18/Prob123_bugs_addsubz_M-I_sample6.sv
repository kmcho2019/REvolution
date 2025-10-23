module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Optimized conditional inversion using XOR
    wire [7:0] b_operand = b ^ {8{do_sub}};
    
    // Carry-select adder implementation
    wire [3:0] sum_low, sum_high0, sum_high1;
    wire carry_low;
    
    // Lower 4-bit adder
    assign {carry_low, sum_low} = a[3:0] + b_operand[3:0] + do_sub;
    
    // Higher 4-bit adders (with and without carry)
    assign sum_high0 = a[7:4] + b_operand[7:4];
    assign sum_high1 = a[7:4] + b_operand[7:4] + 1'b1;
    
    // Final output
    assign out = {carry_low ? sum_high1 : sum_high0, sum_low};
    
    // Tree-structured zero detection
    wire or_03, or_47;
    assign or_03 = |out[3:0];
    assign or_47 = |out[7:4];
    assign result_is_zero = ~(or_03 | or_47);

endmodule