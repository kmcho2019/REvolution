module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary variable to hold the product

    always @(*) begin
        temp_product = 0;  // Initialize the product to zero for each new calculation
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                // Add the multiplicand (A) shifted left by i bits to the product
                temp_product = temp_product + (A << i);
            end
        end
        product = temp_product;  // Assign the final product to the output
    end

endmodule