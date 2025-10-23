module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    assign out = a + (b ^ {8{do_sub}}) + do_sub;
    assign result_is_zero = (out == 8'b0);

endmodule