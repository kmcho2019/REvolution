module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to hold the product

always @(A or B) begin
    reg [7:0] A_reg;  // Internal register to hold the multiplicand
    reg [7:0] B_reg;  // Internal register to hold the multiplier
    reg [15:0] product_temp;  // Temporary variable to hold the product during calculation

    A_reg = A;  // Initialize multiplicand register
    B_reg = B;  // Initialize multiplier register
    product_temp = 16'd0;  // Initialize product to zero

    for (int i = 0; i < 8; i++) begin
        if (B_reg[0]) begin  // Check if the least significant bit of the multiplier is set
            product_temp = product_temp + {8'd0, A_reg};  // Add the multiplicand to the product
        end
        A_reg = A_reg << 1;  // Shift the multiplicand left by one bit
        B_reg = B_reg >> 1;  // Shift the multiplier right by one bit
    end

    product_reg = product_temp;  // Assign the calculated product to the internal register
end

assign product = product_reg;  // Assign the internal register to the output port

endmodule