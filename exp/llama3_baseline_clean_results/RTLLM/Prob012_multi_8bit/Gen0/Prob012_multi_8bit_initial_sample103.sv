module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

always @(*) begin
    product = 16'd0;  // Initialize the product to zero
    reg [7:0] temp_A = A;  // Temporary variable for shifting A
    
    // Iterate through each bit of the multiplier (B)
    for (int i = 0; i < 8; i++) begin
        // If the current bit of B is 1, add the shifted A to the product
        if (B[i]) begin
            product = product + (temp_A << i);
        end
        
        // Shift A left by one bit for the next iteration
        if (i < 7) begin
            temp_A = temp_A << 1;
        end
    end
end

endmodule