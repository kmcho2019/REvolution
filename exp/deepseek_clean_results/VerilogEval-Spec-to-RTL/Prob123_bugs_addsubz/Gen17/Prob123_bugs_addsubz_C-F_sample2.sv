module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Power-efficient conditional inversion
    wire [7:0] b_operand = do_sub ? ~b : b;
    
    // Clear two's complement arithmetic
    assign out = a + b_operand + do_sub;
    
    // Area-efficient zero detection with clear comparison
    assign result_is_zero = (out == 8'b0);

endmodule