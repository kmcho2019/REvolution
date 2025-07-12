module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform the subtraction
assign result = A - B;

// Check for overflow
always @(*) begin
    // If A is positive and B is negative and result is negative, it's an overflow
    if ((~A[63] && B[63] && result[63])) begin
        overflow = 1'b1; // Positive overflow
    // If A is negative and B is positive and result is positive, it's an underflow
    end else if ((A[63] && ~B[63] && ~result[63])) begin
        overflow = 1'b1; // Negative overflow
    end else begin
        overflow = 1'b0; // No overflow
    end
end

endmodule