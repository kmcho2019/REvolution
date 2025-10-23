module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Parallel computation of both operations
    wire [7:0] add_result = a + b;
    wire [7:0] sub_result = a - b;
    
    // Select result based on operation
    assign out = do_sub ? sub_result : add_result;
    
    // Optimized zero detection with tree structure
    wire z3 = ~(out[7] | out[6] | out[5] | out[4]);
    wire z2 = ~(out[3] | out[2] | out[1] | out[0]);
    assign result_is_zero = z3 & z2;

endmodule