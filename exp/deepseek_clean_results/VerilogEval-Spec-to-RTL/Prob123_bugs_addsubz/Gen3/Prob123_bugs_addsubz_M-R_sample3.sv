module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output wire [7:0] out,
    output wire result_is_zero
);

    // Select addition or subtraction based on do_sub
    assign out = do_sub ? (a - b) : (a + b);
    
    // Zero detection - true when all bits are 0
    assign result_is_zero = (out == 8'b0);

endmodule