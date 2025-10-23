module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_operand = do_sub ? ~b : b;
    wire carry_in = do_sub;
    
    // Lower 4-bit adder (always computed)
    wire [3:0] sum_low_0 = a[3:0] + b_operand[3:0] + carry_in;
    wire carry_low = (a[3] & b_operand[3]) | 
                    ((a[3] | b_operand[3]) & sum_low_0[3]);
    
    // Upper 4-bit adders (both possibilities)
    wire [3:0] sum_high_0 = a[7:4] + b_operand[7:4];
    wire [3:0] sum_high_1 = a[7:4] + b_operand[7:4] + 1'b1;
    
    // Select upper sum based on lower carry
    wire [3:0] sum_high = carry_low ? sum_high_1 : sum_high_0;
    
    // Combine final result
    assign out = {sum_high, sum_low_0};
    
    // Early zero detection
    wire zero_low = ~(|sum_low_0);
    wire zero_high_0 = ~(|sum_high_0);
    wire zero_high_1 = ~(|sum_high_1);
    wire zero_high = carry_low ? zero_high_1 : zero_high_0;
    
    assign result_is_zero = zero_low & zero_high;

endmodule