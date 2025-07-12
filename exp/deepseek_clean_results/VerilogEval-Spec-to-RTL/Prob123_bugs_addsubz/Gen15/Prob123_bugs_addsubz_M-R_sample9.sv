module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Conditional operand inversion for subtraction
    wire [7:0] operand_b = do_sub ? ~b : b;
    
    // Addition with carry-in for subtraction
    wire [8:0] sum_ext = a + operand_b + do_sub;
    
    // Final output (discard carry-out)
    assign out = sum_ext[7:0];
    
    // Zero detection
    assign result_is_zero = (out == 8'd0);

endmodule