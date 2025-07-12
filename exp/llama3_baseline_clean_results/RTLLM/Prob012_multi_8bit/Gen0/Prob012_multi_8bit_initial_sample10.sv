module multi_8bit (
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary variable to store the product

    always @(*) begin
        temp_product = 16'd0;  // Initialize product to zero
        reg [7:0] temp_A;  // Temporary variable to store A
        temp_A = A;  // Initialize temp_A to A

        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin  // If the current bit of B is set
                temp_product = temp_product + (temp_A << i);  // Add temp_A shifted left by i bits to the product
            end
            // No need to shift temp_A here because we are using (temp_A << i) in the addition
        end
        product = temp_product;  // Assign the final product to the output port
    end

endmodule