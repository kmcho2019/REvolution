module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Efficient adder-subtractor with conditional inversion and carry-in
    assign out = a + (do_sub ? ~b : b) + do_sub;
    
    // Proper zero detection using equality comparison
    assign result_is_zero = (out == 8'b0);

endmodule