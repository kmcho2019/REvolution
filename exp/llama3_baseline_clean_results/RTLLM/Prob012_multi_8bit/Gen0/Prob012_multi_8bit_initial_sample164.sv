module multi_8bit (
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] product_reg;  // Internal register to store the product

    always @(*) begin
        product_reg = 0;  // Initialize the product register to 0
        reg [7:0] A_shifted = A;  // Register to store the shifted multiplicand

        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin  // Check if the current bit in the multiplier is set
                product_reg = product_reg + (A_shifted << i);  // Add the shifted multiplicand to the product
            end
            // No need to shift A_shifted here as it is already considered in the next iteration
        end

        product = product_reg;  // Assign the final product to the output port
    end

endmodule