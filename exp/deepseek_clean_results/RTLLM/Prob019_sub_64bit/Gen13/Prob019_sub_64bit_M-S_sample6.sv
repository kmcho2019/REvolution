module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Perform subtraction directly
    always_comb begin
        result = A - B;
        
        // Overflow detection:
        // 1. Positive overflow: A positive, B negative, result negative
        // 2. Negative overflow: A negative, B positive, result positive
        overflow = (A[63] != B[63]) && (A[63] != result[63]);
    end

endmodule