module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] sum = a + b;
    wire [7:0] diff = a - b;
    
    wire sum_is_zero = (sum == 8'b0);
    wire diff_is_zero = (diff == 8'b0);
    
    assign out = do_sub ? diff : sum;
    assign result_is_zero = do_sub ? diff_is_zero : sum_is_zero;

endmodule