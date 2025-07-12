module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

always @(A or B) begin
    product = 0;  // Initialize product to 0 at the start of each calculation
    reg [7:0] temp_A = A;  // Temporary variable to hold the shifting value of A
    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin  // If the current bit of B is 1
            product = product + (temp_A << i);  // Add shifted A to the product
        end
        // No need to explicitly shift temp_A here since we are using it shifted in the if condition
    end
end

endmodule