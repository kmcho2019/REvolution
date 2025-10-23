module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Parallel operation computation
    wire [7:0] sum = a + b;
    wire [7:0] diff = a - b;
    
    // Operation selection
    assign out = do_sub ? diff : sum;
    
    // Early zero detection
    wire sum_zero = (sum == 8'b0);
    wire diff_zero = (diff == 8'b0);
    assign result_is_zero = do_sub ? diff_zero : sum_zero;

endmodule