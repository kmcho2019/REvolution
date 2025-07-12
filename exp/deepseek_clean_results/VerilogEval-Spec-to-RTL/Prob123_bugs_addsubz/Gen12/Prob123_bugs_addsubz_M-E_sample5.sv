module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] b_adj = do_sub ? ~b : b;
    wire cin = do_sub;
    
    // Process lower nibble
    wire [3:0] sum_lo = a[3:0] + b_adj[3:0] + cin;
    wire zero_lo = (sum_lo == 4'b0);
    wire cout_lo = (a[3:0] + b_adj[3:0] + cin) >> 4;
    
    // Process upper nibble
    wire [3:0] sum_hi = a[7:4] + b_adj[7:4] + cout_lo;
    wire zero_hi = (sum_hi == 4'b0);
    
    // Combine results
    assign out = {sum_hi, sum_lo};
    assign result_is_zero = zero_hi & zero_lo;

endmodule