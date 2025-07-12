module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Explicit add and subtract paths
    wire [7:0] add_result = a + b;
    wire [7:0] sub_result = a - b;
    
    // Output selection
    assign out = do_sub ? sub_result : add_result;
    
    // Zero detection
    assign result_is_zero = (out == 8'b0);

endmodule