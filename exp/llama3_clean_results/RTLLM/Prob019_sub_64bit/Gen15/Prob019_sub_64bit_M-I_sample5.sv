module sub_64bit(
    input  wire [63:0] A,  // First 64-bit input operand
    input  wire [63:0] B,  // Second 64-bit input operand
    output wire [63:0] result,  // 64-bit output representing the difference of A and B
    output wire        overflow  // 1-bit output indicating whether an overflow occurred
);

    // Perform binary subtraction of A and B
    // Using a dedicated subtractor or optimizing the adder for subtraction could potentially improve timing
    assign result = A - B;
    
    // Simplified overflow detection logic
    // This logic is already optimized for simplicity and should not introduce significant delay
    assign overflow = (A[63] == B[63] && A[63]!= result[63])? 1'b1 : 1'b0;

    // To reduce power consumption, consider using clock gating if this module is not always active
    // This would require additional control logic and a clock enable signal
    // assign result = (clock_enable)? (A - B) : 64'b0;
    // assign overflow = (clock_enable)? ((A[63] == B[63] && A[63]!= result[63])? 1'b1 : 1'b0) : 1'b0;

endmodule