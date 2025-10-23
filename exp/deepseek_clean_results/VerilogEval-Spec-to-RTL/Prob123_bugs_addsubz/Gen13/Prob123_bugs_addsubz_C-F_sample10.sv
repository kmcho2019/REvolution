module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Only invert when subtracting - reduces power
    wire [7:0] b_operand = do_sub ? ~b : b;
    
    // Single arithmetic operation with conditional carry-in
    assign out = a + b_operand + do_sub;
    
    // Clear zero detection
    assign result_is_zero = (out == 8'b0);

endmodule