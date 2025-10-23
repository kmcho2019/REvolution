module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Mux-based operand selection for lower power
    wire [7:0] b_operand = do_sub ? ~b : b;
    
    // Single adder with carry-in for subtraction
    assign out = a + b_operand + do_sub;

    // Maintain fast zero detection
    assign result_is_zero = (out == 8'd0);

endmodule