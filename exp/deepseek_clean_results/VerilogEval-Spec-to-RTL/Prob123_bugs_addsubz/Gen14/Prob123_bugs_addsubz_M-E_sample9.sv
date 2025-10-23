module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Parallel computation (carry-save format)
    wire [7:0] sum_add = a + b;
    wire [7:0] sum_sub = a - b;
    
    // Early zero prediction
    wire zero_add = (a == ~b + 1);  // a + b = 0
    wire zero_sub = (a == b);       // a - b = 0
    wire zero_spec = do_sub ? zero_sub : zero_add;
    
    // Result selection
    assign out = do_sub ? sum_sub : sum_add;
    
    // Final zero detection (combines speculative and exact)
    assign result_is_zero = zero_spec | (&(~out));

endmodule