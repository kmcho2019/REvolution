module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Local parameters for overflow conditions
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;

    always_comb begin
        // Perform the subtraction
        result = A - B;
        
        // Optimized overflow detection
        // Overflow occurs when signs of A and B differ and result sign differs from A
        overflow = (A[63] != B[63]) && (A[63] != result[63]) ? OVERFLOW : NO_OVERFLOW;
    end

endmodule