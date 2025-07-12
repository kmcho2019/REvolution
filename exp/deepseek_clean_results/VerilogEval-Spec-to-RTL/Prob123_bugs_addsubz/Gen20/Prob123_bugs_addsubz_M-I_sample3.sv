module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Combined conditional inversion and addition
    assign out = a + (do_sub ? ~b : b) + {7'b0, do_sub};
    
    // More efficient zero detection using NOR
    assign result_is_zero = (out == 8'b0);

endmodule