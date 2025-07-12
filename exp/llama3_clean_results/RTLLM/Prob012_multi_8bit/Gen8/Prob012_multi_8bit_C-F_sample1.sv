module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize the product to 0
    reg [15:0] product_reg;
    always @(*) begin
        product_reg = 0;
        // Iterate over each bit of the multiplier
        for (int i = 0; i < 8; i++) begin
            // If the current bit is set, add the multiplicand shifted by the current position to the product
            if (B[i]) begin
                product_reg = product_reg + (A << i);
            end
        end
    end

    // Assign the product to the output
    assign product = product_reg;

endmodule