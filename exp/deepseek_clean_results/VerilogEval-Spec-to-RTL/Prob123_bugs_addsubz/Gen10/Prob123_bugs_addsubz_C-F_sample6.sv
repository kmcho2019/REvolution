module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Direct adder-subtractor with optimized carry handling
    assign out = a + (do_sub ? ~b : b) + do_sub;
    
    // Efficient zero detection with clear comparison
    assign result_is_zero = (out == 8'd0);

endmodule