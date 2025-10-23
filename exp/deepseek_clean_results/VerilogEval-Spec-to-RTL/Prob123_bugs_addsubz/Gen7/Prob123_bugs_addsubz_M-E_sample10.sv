module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    wire [7:0] sum_add, sum_sub;
    wire [7:0] b_compl = ~b + 1'b1;
    
    // Parallel computation of both operations
    assign sum_add = a + b;
    assign sum_sub = a + b_compl;
    
    // Select result based on operation
    assign out = do_sub ? sum_sub : sum_add;
    
    // Early zero detection (checks if all sum bits would be zero)
    wire zero_add = ~(|(a ^ b ^ {8{1'b0}}));
    wire zero_sub = ~(|(a ^ b_compl ^ {8{1'b0}}));
    assign result_is_zero = do_sub ? zero_sub : zero_add;

endmodule