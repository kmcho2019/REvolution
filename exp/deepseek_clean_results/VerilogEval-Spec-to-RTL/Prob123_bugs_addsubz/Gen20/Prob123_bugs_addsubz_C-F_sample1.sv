module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Power-optimized XOR-based conditional inversion
    wire [7:0] b_operand = b ^ {8{do_sub}};
    
    // Single efficient arithmetic operation
    assign out = a + b_operand + do_sub;
    
    // Hardware-efficient zero detection
    assign result_is_zero = (out == 8'b0);

endmodule