module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire [63:0] diff;
    wire is_a_positive, is_b_positive, is_result_positive;

    // Determine the sign of A, B, and the result
    assign is_a_positive = ~A[63];
    assign is_b_positive = ~B[63];
    assign diff = A - B;
    assign is_result_positive = ~diff[63];

    // Perform subtraction
    assign result = diff;

    // Detect overflow
    assign overflow = (is_a_positive && is_b_positive && !is_result_positive) ||
                     (!is_a_positive && !is_b_positive && is_result_positive);

endmodule