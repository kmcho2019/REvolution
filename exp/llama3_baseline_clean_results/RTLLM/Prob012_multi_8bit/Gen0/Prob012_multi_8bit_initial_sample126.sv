module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

always_comb begin
    product = 16'd0;  // Initialize the product to zero
    
    // Iterate through each bit of the multiplier (B)
    for (int i = 0; i < 8; i++) begin
        // If the current bit of the multiplier is set (1), add the multiplicand (A) to the product
        if (B[i]) begin
            // Shift the multiplicand (A) to the corresponding position and add it to the product
            product = product + (A << i);
        end
    end
end

endmodule