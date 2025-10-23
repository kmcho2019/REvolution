module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

always @(*) begin
    product = 0;  // Initialize the product to zero
    for (int i = 0; i < 8; i++) begin
        if (B[i] == 1'b1) begin  // Check if the current bit of the multiplier is set
            product = product + (A << i);  // Add the multiplicand shifted left by the current bit position to the product
        end
    end
end

endmodule