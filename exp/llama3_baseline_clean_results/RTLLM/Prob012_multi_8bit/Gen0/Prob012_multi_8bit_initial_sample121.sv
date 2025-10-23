module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

always @(*) begin
    product = 16'd0;  // Initialize product to 0
    reg [7:0] temp_A; // Temporary register to hold A
    temp_A = A;       // Initialize temp_A with A
    
    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin  // Check if the current bit of B is set
            product = product + (temp_A << i);  // Add temp_A shifted left by i bits to product
        end
        // No need to explicitly shift temp_A here, as it's only used in the addition operation
    end
end

endmodule