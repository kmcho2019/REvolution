module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output reg signed [63:0] result,
    output reg overflow
);

always @(*) begin
    // Perform the subtraction
    result = A - B;
    
    // Simplified overflow detection
    overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);
end

endmodule