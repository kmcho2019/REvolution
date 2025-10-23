module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to hold the product

always @(*) begin
    product_reg = 16'd0;  // Initialize product to 0
    reg [7:0] A_shifted = A;  // Shifted version of A
    
    // Iterate through each bit of the multiplier (B)
    for (int i = 0; i < 8; i++) begin
        // If the current bit of B is set (1), add A_shifted to the product
        if (B[i]) begin
            product_reg = product_reg + (A_shifted << i);
        end
        
        // Shift A left by one bit for the next iteration
        A_shifted = A_shifted << 1;
    end
    
    // Assign the final product to the output port
    product = product_reg;
end

endmodule