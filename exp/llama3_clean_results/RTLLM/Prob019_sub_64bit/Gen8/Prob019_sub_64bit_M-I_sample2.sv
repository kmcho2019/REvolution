module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Perform subtraction directly on the output to minimize intermediate signals
    assign result = A - B;
    
    // Simplify overflow detection by directly comparing sign bits of A, B, and result
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

endmodule