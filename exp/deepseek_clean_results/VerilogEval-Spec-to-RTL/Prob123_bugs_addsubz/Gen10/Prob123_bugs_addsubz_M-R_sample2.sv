module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Two's complement subtraction: when do_sub=1, invert b and add 1
    wire [7:0] b_modified = do_sub ? ~b : b;
    wire [7:0] sum = a + b_modified + do_sub;

    assign out = sum;
    assign result_is_zero = (sum == 8'd0);

endmodule