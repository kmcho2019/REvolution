module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to store the product
reg [7:0] A_reg;  // Internal register to store the multiplicand
reg [7:0] B_reg;  // Internal register to store the multiplier
integer i;  // Loop counter

always @(A or B) begin
    product_reg = 0;  // Initialize product to zero
    A_reg = A;  // Initialize multiplicand
    B_reg = B;  // Initialize multiplier

    for (i = 0; i < 8; i = i + 1) begin
        if (B_reg[0]) begin  // Check if current bit of multiplier is set
            product_reg = product_reg + (A_reg << i);  // Add shifted multiplicand to product
        end
        B_reg = B_reg >> 1;  // Shift multiplier right by one bit
    end

    product = product_reg;  // Assign final product to output port
end

endmodule