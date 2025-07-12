module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Combined adder-subtractor with direct operation
    assign out = a + (do_sub ? ~b : b) + do_sub;
    
    // Simplified zero detection
    assign result_is_zero = (out == 8'b0);

endmodule