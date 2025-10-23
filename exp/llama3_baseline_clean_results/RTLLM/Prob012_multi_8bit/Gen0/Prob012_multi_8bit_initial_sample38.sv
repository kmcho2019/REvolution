module multi_8bit (
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to hold the product
reg [7:0] A_reg;  // Internal register to hold the multiplicand
reg [7:0] B_reg;  // Internal register to hold the multiplier
integer i;  // Loop counter

always @(A or B) begin
    product_reg = 0;  // Initialize the product register
    A_reg = A;  // Initialize the multiplicand register
    B_reg = B;  // Initialize the multiplier register

    for (i = 0; i < 8; i = i + 1) begin
        if (B_reg[0] == 1) begin
            product_reg = product_reg + (A_reg << i);  // Add the multiplicand to the product at the corresponding shifted position
        end
        B_reg = B_reg >> 1;  // Shift the multiplier right by one bit
    end
    product = product_reg;  // Assign the final product to the output port
end

endmodule