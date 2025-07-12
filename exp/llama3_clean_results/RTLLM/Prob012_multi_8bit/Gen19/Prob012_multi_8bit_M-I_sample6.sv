module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] product_reg;  // Internal register to store the product

    always @(*) begin
        product_reg = 0;  // Initialize the product to 0
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                product_reg <= product_reg + (A << i);  // Add A shifted by i bits to the product if the current bit of B is set
            end
        end
    end

    assign product = product_reg;  // Assign the product register to the output port

endmodule