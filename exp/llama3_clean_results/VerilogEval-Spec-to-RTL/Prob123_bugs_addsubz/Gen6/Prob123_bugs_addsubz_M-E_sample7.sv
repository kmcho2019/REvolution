module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    wire [7:0] b_twos_complement;

    // Calculate two's complement of b
    assign b_twos_complement = ~b + 1;

    // Perform addition or subtraction using a single ALU
    assign out = do_sub ? (a + b_twos_complement) : (a + b);

    // Flag generator to detect when the result is zero
    assign result_is_zero = (out == 8'd0);

endmodule