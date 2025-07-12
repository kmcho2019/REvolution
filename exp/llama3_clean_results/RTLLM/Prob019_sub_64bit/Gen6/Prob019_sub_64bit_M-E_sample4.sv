module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Calculate the two's complement of B
    wire [63:0] B_twos_complement;
    assign B_twos_complement = ~B + 1;

    // Perform subtraction by adding A and the two's complement of B
    wire [63:0] diff;
    assign diff = A + B_twos_complement;

    // Assign the result
    assign result = diff;

    // Detect overflow by comparing signs
    assign overflow = (A[63] == 1 && B[63] == 0 && result[63] == 0) || (A[63] == 0 && B[63] == 1 && result[63] == 1);

endmodule