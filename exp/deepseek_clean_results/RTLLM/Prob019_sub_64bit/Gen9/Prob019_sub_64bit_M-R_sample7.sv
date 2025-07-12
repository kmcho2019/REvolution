module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Perform the subtraction
    assign result = A - B;
    
    // Overflow detection:
    // Occurs when signs of A and B differ and result sign differs from A
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

endmodule