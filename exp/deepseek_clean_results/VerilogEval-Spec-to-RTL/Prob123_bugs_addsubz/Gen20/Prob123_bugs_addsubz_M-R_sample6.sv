module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Explicit adder-subtractor logic
    wire [7:0] adjusted_b = do_sub ? ~b : b;
    wire carry_in = do_sub;
    assign out = a + adjusted_b + carry_in;

    // Clear zero detection logic
    assign result_is_zero = (out == 8'b0);

endmodule