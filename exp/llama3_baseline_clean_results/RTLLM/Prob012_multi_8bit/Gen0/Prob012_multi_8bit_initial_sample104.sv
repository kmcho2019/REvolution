module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to hold the product
reg [7:0] A_reg;  // Internal register to hold the multiplicand
reg [7:0] B_reg;  // Internal register to hold the multiplier
integer i;  // Loop counter

initial begin
    product_reg = 0;  // Initialize product register
    A_reg = A;  // Initialize multiplicand register
    B_reg = B;  // Initialize multiplier register
end

always @(*) begin
    product_reg = 0;  // Reset product register
    A_reg = A;  // Reset multiplicand register
    B_reg = B;  // Reset multiplier register

    for (i = 0; i < 8; i = i + 1) begin
        if (B_reg[0] == 1) begin  // Check if the current bit of the multiplier is set
            product_reg = product_reg + (A_reg << i);  // Add the multiplicand to the product at the correct position
        end
        B_reg = B_reg >> 1;  // Shift the multiplier right by one bit
    end
    product = product_reg;  // Assign the final product to the output port
end

endmodule