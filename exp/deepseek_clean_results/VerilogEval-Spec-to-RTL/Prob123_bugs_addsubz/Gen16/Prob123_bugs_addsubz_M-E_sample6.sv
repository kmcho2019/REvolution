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
    
    // Result selection
    assign out = do_sub ? diff : sum;
    
    // Early zero prediction
    wire sum_zero = (a == ~b + 1);  // a + b == 0
    wire diff_zero = (a == b);      // a - b == 0
    
    // Final zero flag
    assign result_is_zero = do_sub ? diff_zero : sum_zero;

endmodule