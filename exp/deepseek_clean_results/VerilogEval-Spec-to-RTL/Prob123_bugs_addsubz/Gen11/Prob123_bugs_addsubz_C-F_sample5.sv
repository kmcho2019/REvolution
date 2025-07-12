module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Efficient conditional inversion for subtraction
    wire [7:0] operand_b = b ^ {8{do_sub}};
    
    // Single optimized arithmetic operation
    assign out = a + operand_b + do_sub;
    
    // Correct and efficient zero detection
    assign result_is_zero = (out == 8'd0);

endmodule