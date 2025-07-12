module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    assign out = a + (do_sub ? ~b : b) + do_sub;
    assign result_is_zero = ~(|out);

endmodule