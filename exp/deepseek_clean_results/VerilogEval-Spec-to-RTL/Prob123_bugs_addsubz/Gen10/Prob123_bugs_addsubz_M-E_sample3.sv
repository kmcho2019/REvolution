module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Parallel arithmetic paths
    wire [7:0] sum = a + b;
    wire [7:0] diff = a - b;
    
    // Early zero detection
    wire sum_zero = ~(|sum);
    wire diff_zero = ~(|diff);
    
    // Result selection
    assign out = do_sub ? diff : sum;
    assign result_is_zero = do_sub ? diff_zero : sum_zero;

endmodule