module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] sum;
    wire carry_out;

    // Ripple-carry implementation
    assign {carry_out, sum} = A + B_comp + 1'b1;
    assign result = sum;

    // Overflow occurs when carry into MSB != carry out of MSB
    assign overflow = (A[63] ^ B_comp[63]) & (A[63] ^ result[63]);

endmodule