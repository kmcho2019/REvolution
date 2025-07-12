module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

    always @(A or B) begin  // Recalculate product whenever A or B changes
        product = 0;  // Initialize product to 0

        for (integer i = 0; i < 8; i++) begin  // Iterate through each bit of the multiplier
            if (B[i]) begin  // Check if the current bit of the multiplier is 1
                product = product + ({8'b0, A} << i);  // Add A (shifted left by i) to the product
            end
        end
    end

endmodule