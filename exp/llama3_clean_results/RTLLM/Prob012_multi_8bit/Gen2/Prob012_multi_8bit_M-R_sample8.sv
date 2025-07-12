module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] product_reg;  // Internal register to hold the product

    always @(*) begin
        product_reg = 16'b0;  // Initialize product register to zero
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                product_reg = product_reg + (A << i);  // Add shifted multiplicand to product
            end
        end
    end

    assign product = product_reg;  // Assign product register to output

endmodule