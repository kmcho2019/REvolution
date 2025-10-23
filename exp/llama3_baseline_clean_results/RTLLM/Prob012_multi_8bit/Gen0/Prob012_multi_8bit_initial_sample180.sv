module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

always @(A or B) begin
    product = 0;  // Initialize product to zero at the start of each operation
    reg [7:0] temp_A = A;  // Temporary register for A to perform shifting without modifying the input
    
    // Iterate through each bit of the multiplier (B)
    for (int i = 0; i < 8; i++) begin
        // Check if the current bit of the multiplier is set (1)
        if (B[i]) begin
            // Add the multiplicand (A) shifted left by the current bit position to the product
            product = product + (temp_A << i);
        end
        
        // Shift the multiplicand (A) left by one bit for the next iteration
        temp_A = temp_A << 1;
    end
end

endmodule