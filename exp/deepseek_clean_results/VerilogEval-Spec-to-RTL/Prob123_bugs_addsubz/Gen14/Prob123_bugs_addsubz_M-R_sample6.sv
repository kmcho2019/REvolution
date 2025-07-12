module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Perform addition or two's complement subtraction
    wire [7:0] b_operand = do_sub ? ~b : b;
    wire carry_in = do_sub;
    assign out = a + b_operand + carry_in;

    // Zero flag generation
    assign result_is_zero = (out == 8'b0);

endmodule