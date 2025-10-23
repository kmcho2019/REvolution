module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_operand = b ^ {8{do_sub}};
    wire [7:0] sum, carry;
    wire cin = do_sub;
    
    // Carry-save addition stage
    assign sum = a ^ b_operand;
    assign carry = {a[6:0] & b_operand[6:0], cin} << 1;
    
    // Final carry-propagate addition
    assign out = sum + carry;
    
    // Optimized zero detection using parallel prefix OR
    wire [3:0] or_stage1 = {|out[7:6], |out[5:4], |out[3:2], |out[1:0]};
    wire [1:0] or_stage2 = {|or_stage1[3:2], |or_stage1[1:0]};
    assign result_is_zero = ~(|or_stage2);

endmodule