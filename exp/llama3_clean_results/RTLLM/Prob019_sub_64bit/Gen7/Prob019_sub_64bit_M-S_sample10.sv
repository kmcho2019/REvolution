module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    assign result = A - B;

    // Simplified overflow detection using the most significant bit (MSB) of A, B, and result
    assign overflow = (A[63] && ~B[63] && ~result[63]) || (~A[63] && B[63] && result[63]);

endmodule