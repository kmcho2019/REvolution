module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Efficient arithmetic operation selection
    wire [7:0] b_operand = do_sub ? ~b : b;
    wire carry_in = do_sub;
    
    // Single arithmetic operation with proper carry handling
    assign out = a + b_operand + carry_in;
    
    // Area-optimized zero detection
    assign result_is_zero = ~|out;

endmodule