module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

    always @(*) begin
        product = 0;  // Initialize product to 0 for each new calculation
        reg [7:0] temp_A = A;  // Temporary register to hold A for shifting
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin  // If current bit of B is set (1)
                product = product + (temp_A << i);  // Add shifted A to product
            end
            // No need to explicitly shift temp_A here, as it's used in the next iteration already shifted by the loop's nature
        end
    end

endmodule