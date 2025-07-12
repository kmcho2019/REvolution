module multi_8bit(
    input [7:0] A, // First 8-bit input operand (multiplicand)
    input [7:0] B, // Second 8-bit input operand (multiplier)
    output [15:0] product // 16-bit output representing the product of A and B
);

reg [15:0] product_reg; // Internal register to hold the product
reg [7:0] A_reg; // Internal register for A to be shifted
reg [7:0] B_reg; // Internal register for B, used for iteration
integer i; // Loop counter

initial begin
    product_reg = 16'd0; // Initialize product to 0
    A_reg = A; // Load A into internal register
    B_reg = B; // Load B into internal register
    for (i = 0; i < 8; i = i + 1) begin // Iterate through each bit of B
        if (B_reg[0] == 1'b1) begin // Check if the current bit of B is 1
            product_reg = product_reg + {{8{i}}, A_reg}; // Add A (shifted) to product if bit is 1
        end
        A_reg = A_reg << 1; // Shift A one bit to the left for next iteration
        B_reg = B_reg >> 1; // Shift B one bit to the right to move to the next bit
    end
    product = product_reg; // Assign the final product to the output
end

endmodule