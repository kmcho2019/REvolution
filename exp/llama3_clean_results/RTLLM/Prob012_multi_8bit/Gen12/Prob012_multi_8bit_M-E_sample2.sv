// Module: multi_8bit
// Description: 8-bit multiplier using shifting and adding operations
module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] product_reg;  // Internal register to hold the product
    reg [7:0] A_reg;  // Internal register to hold the multiplicand

    // Initialize product to zero
    initial product_reg = 0;

    // Always block to handle iteration and conditional additions
    always @(*) begin
        product_reg = 0;  // Reset product
        A_reg = A;  // Initialize multiplicand

        // Iterate through each bit of the multiplier
        for (int i = 0; i < 8; i++) begin
            // Check if the current bit is set
            if (B[i]) begin
                // Add the multiplicand shifted left by the current bit position to the product
                product_reg = product_reg + (A_reg << i);
            end

            // Shift the multiplicand one bit to the left
            A_reg = A_reg << 1;
        end
    end

    // Assign the product to the output port
    assign product = product_reg;

endmodule