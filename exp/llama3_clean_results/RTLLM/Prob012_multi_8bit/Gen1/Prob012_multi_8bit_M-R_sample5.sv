module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] product_reg;  // Internal register to hold the product
    reg [7:0] A_reg;  // Internal register to hold A for shifting

    always @(A or B) begin  // Recalculate product whenever A or B changes
        product_reg = 0;  // Initialize product to 0
        A_reg = A;  // Initialize A_reg with A

        for (integer i = 0; i < 8; i++) begin  // Iterate through each bit of the multiplier
            if (B[i]) begin  // Check if the current bit of the multiplier is 1
                product_reg = product_reg + ({8'b0, A_reg} << i);  // Add A (shifted left by i) to the product
            end
            A_reg = {A_reg[6:0], 1'b0};  // Shift A_reg left by one bit, filling with zero
        end

        product = product_reg;  // Assign the calculated product to the output
    end

endmodule