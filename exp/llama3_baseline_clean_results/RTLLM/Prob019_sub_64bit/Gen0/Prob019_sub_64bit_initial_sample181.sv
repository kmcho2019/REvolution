module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform binary subtraction of A and B
assign result = A - B;

// Detect overflow conditions
always @(A, B, result) begin
    if (($signed(A) >= 0 && $signed(B) < 0 && $signed(result) < 0) || 
        ($signed(A) < 0 && $signed(B) >= 0 && $signed(result) >= 0)) begin
        // Overflow condition detected
        overflow = 1'b1;
    end else begin
        // No overflow condition detected
        overflow = 1'b0;
    end
end

endmodule