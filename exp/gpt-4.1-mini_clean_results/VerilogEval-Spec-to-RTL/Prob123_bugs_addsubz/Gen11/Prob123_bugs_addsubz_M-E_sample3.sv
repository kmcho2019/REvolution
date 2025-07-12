module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    // Select operand: either b or two's complement of b (negation) based on do_sub
    wire [7:0] b_mod = do_sub ? (~b + 8'd1) : b;

    // Perform addition or subtraction via modified operand
    assign out = a + b_mod;

    // Zero flag: set if out is zero
    assign result_is_zero = ~|out;

endmodule