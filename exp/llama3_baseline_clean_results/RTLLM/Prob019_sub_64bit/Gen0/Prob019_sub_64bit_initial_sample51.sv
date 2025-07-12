module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

assign result = A - B;

// Check for overflow conditions
always @(A, B, result) begin
    if ((~A[63] && B[63] && result[63]) || (A[63] && ~B[63] && ~result[63])) begin
        overflow = 1'b1; // Set overflow flag to 1 if overflow condition is detected
    end else begin
        overflow = 1'b0; // Set overflow flag to 0 if no overflow condition is detected
    end
end

endmodule