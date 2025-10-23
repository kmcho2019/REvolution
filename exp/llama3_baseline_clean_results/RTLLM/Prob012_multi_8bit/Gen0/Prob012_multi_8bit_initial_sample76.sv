module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] temp_product;  // Temporary register to hold the product
reg [7:0] temp_A;  // Temporary register for A, used for shifting

always @(A or B) begin
    temp_product = 0;  // Reset product for new calculation
    temp_A = A;  // Initialize temp_A with A for shifting
    
    // Iterate through each bit of the multiplier (B)
    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin  // If the current bit of B is set
            temp_product = temp_product + (temp_A << i);  // Add shifted A to product
        end
        // No need to explicitly shift temp_A here as it's done in the next iteration
    end
    
    product = temp_product;  // Assign final product to output
end

endmodule