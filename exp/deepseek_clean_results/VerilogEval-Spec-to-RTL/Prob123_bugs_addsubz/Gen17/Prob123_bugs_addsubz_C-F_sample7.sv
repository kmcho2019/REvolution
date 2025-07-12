module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Efficient conditional inversion and addition
    wire [7:0] b_operand = do_sub ? ~b : b;
    assign out = a + b_operand + do_sub;

    // Clear zero comparison
    assign result_is_zero = (out == 8'b0);

endmodule