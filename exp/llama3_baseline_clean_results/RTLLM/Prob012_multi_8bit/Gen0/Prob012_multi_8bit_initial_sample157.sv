module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary variable to hold the product

    always @(A or B) begin
        temp_product = 0;  // Initialize product to zero
        reg [7:0] temp_A;  // Temporary variable to hold the multiplicand
        temp_A = A;  // Initialize temp_A with A

        for (int i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin  // Check if the current bit of B is 1
                temp_product = temp_product + (temp_A << i);  // Add shifted A to the product
            end
            // No need to explicitly shift temp_A here as it's already considered in the loop
        end

        product = temp_product;  // Assign the final product to the output
    end

endmodule