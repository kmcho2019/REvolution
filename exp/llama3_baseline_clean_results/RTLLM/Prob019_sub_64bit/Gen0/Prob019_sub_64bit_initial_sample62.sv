module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output          overflow
);

// Perform binary subtraction
assign result = A - B;

// Detect overflow conditions
always @(*) begin
    // Check for positive overflow
    if ((~A[63]) && (B[63]) && (result[63])) begin
        overflow = 1'b1;
    // Check for negative overflow
    end else if ((A[63]) && (~B[63]) && (~result[63])) begin
        overflow = 1'b1;
    // No overflow
    end else begin
        overflow = 1'b0;
    end
end

endmodule