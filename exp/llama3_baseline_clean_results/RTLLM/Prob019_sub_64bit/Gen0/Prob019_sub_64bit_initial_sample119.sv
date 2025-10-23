module sub_64bit(
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output reg overflow
);

// Perform the subtraction
assign result = A - B;

// Detect overflow
always @(*) begin
    // Positive overflow occurs when A is positive, B is negative, and result is negative
    // Negative overflow occurs when A is negative, B is positive, and result is positive
    if (((A[63] == 0) && (B[63] == 1) && (result[63] == 1)) || 
        ((A[63] == 1) && (B[63] == 0) && (result[63] == 0))) begin
        overflow = 1;  // Set overflow flag
    end else begin
        overflow = 0;  // Clear overflow flag
    end
end

endmodule