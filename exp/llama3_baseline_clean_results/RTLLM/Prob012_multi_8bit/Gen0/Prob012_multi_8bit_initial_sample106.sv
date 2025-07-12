module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary register to hold the product
    reg [7:0] temp_A;  // Temporary register to hold A

    always @(A or B) begin
        temp_product = 0;  // Initialize product to 0
        temp_A = A;  // Initialize temp_A to A

        // Iterate through each bit of the multiplier (B)
        for (int i = 0; i < 8; i++) begin
            // Check if the current bit of B is set (1)
            if (B[i]) begin
                // Add A (shifted left by i positions) to the product
                temp_product = temp_product + (temp_A << i);
            end
            // If not the last iteration, shift A left by one position
            if (i < 7) begin
                temp_A = temp_A << 1;  // Shift A left by one bit
            end
        end

        product = temp_product;  // Assign the final product to the output
    end

endmodule