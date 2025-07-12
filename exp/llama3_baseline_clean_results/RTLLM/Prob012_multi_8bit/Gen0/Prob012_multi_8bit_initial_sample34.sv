module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

always @(A or B) begin
    product = 0;  // Initialize product to 0
    reg [7:0] temp_A = A;  // Temporary variable to hold the multiplicand
    
    // Iterate through each bit of the multiplier
    for (int i = 0; i < 8; i++) begin
        // Check if the current bit of the multiplier is 1
        if (B[i]) begin
            // Add the shifted multiplicand to the product
            product = product + (temp_A << i);
        end
        // Shift the multiplicand left by one bit for the next iteration
        temp_A = temp_A << 1;
    end
end

endmodule