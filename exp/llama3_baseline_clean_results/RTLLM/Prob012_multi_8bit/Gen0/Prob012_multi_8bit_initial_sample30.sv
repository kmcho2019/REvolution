module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary variable to hold the product

    always @(A or B) begin  // Run the multiplication process whenever A or B changes
        temp_product = 16'd0;  // Initialize the product to 0
        reg [7:0] temp_A;  // Temporary variable to hold A
        temp_A = A;  // Initialize temp_A with A

        for (int i = 0; i < 8; i++) begin  // Iterate through each bit of the multiplier (B)
            if (B[i]) begin  // Check if the current bit of B is set (1)
                temp_product = temp_product + (temp_A << i);  // Add temp_A shifted by i positions to the product
            end
            // No need for else, as we only add when the bit is set
        end

        product = temp_product;  // Assign the final product to the output port
    end

endmodule