module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Perform addition or subtraction
    assign out = do_sub ? (a - b) : (a + b);
    
    // Zero flag is set when output equals zero
    assign result_is_zero = (out == 8'b0);

endmodule