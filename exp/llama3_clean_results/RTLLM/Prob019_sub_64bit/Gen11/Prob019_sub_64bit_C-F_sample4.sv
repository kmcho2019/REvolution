module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Perform subtraction and assign result directly
    assign result = A - B;

    // Use continuous assignment with conditional operator for overflow detection
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]) ? 1'b1 : 1'b0;

endmodule