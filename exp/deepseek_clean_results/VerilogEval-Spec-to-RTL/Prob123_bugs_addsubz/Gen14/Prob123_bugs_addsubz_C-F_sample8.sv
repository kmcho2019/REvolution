module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Conditional inversion for subtraction (two's complement)
    wire [7:0] b_operand = b ^ {8{do_sub}};
    
    // Single adder handles both operations
    assign out = a + b_operand + do_sub;
    
    // Explicit zero detection
    assign result_is_zero = (out == 8'd0);

endmodule