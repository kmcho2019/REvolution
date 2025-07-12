module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Parallel computation paths
    wire [7:0] add_result = a + b;
    wire [7:0] sub_result = a - b;
    
    // Early zero detection for both paths
    wire add_zero = (add_result == 8'b0);
    wire sub_zero = (sub_result == 8'b0);
    
    // Select appropriate result and zero flag
    assign out = do_sub ? sub_result : add_result;
    assign result_is_zero = do_sub ? sub_zero : add_zero;

endmodule