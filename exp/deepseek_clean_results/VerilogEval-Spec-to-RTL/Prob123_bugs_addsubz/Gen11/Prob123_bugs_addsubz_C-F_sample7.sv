module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Efficient adder-subtractor with conditional inversion and carry-in
    wire [7:0] b_operand = b ^ {8{do_sub}};
    assign out = a + b_operand + do_sub;

    // Fastest zero detection with reduction NOR
    assign result_is_zero = ~(|out);

endmodule