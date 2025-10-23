module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Combined adder-subtractor with direct carry-in
    assign out = a + (do_sub ? ~b : b) + do_sub;
    
    // Clear zero flag logic with explicit condition
    assign result_is_zero = (out == 8'b0);

endmodule