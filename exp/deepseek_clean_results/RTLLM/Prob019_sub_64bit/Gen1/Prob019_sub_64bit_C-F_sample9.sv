module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output reg overflow
);

    // Main subtraction operation (continuous assignment for efficiency)
    assign result = A - B;

    // Overflow detection (using always block for better synthesis control)
    always @(*) begin
        // Positive overflow: A positive, B negative, result negative
        // Negative overflow: A negative, B positive, result positive
        overflow = ((~A[63] & B[63] & result[63]) |  // Positive overflow
                    (A[63] & ~B[63] & ~result[63])); // Negative overflow
    end

endmodule