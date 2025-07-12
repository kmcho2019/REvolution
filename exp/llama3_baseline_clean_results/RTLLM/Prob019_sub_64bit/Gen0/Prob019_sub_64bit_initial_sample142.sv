module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform subtraction
assign result = A - B;

// Check for overflow
always @(*) begin
    if (($signed(A[63]) == 0 && $signed(B[63]) == 1 && $signed(result[63]) == 1) || 
        ($signed(A[63]) == 1 && $signed(B[63]) == 0 && $signed(result[63]) == 0)) begin
        overflow = 1'b1; // Set overflow flag
    end else begin
        overflow = 1'b0; // Clear overflow flag
    end
end

endmodule