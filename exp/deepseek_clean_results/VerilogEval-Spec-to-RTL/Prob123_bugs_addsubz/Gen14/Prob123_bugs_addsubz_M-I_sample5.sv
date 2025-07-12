module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Conditional inversion based on do_sub
    wire [7:0] b_operand = do_sub ? ~b : b;
    
    // Single adder with conditional carry-in
    assign out = a + b_operand + do_sub;
    
    // Zero detection using NOR (equivalent to AND of inverted bits)
    assign result_is_zero = (out == 8'b0);

endmodule