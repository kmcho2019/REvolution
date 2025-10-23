module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Perform subtraction
    assign result = A - B;

    // Temporary wire to store the result of the comparison between A and B's sign bits
    wire same_sign_AB;
    assign same_sign_AB = (A[63] == B[63]);

    // Temporary wire to store the result of the comparison between A's sign bit and the result's sign bit
    wire same_sign_AR;
    assign same_sign_AR = (A[63] == result[63]);

    // Simplified overflow detection using bitwise operations
    assign overflow = (same_sign_AB == 1'b0) && (same_sign_AR == 1'b0);

endmodule