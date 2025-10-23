module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] temp_product;  // Temporary register to hold the product
reg [7:0] temp_A;  // Temporary register to hold the multiplicand
reg [7:0] temp_B;  // Temporary register to hold the multiplier
integer i;  // Loop counter

always @(A or B) begin
    temp_product = 0;  // Initialize product to 0
    temp_A = A;  // Initialize multiplicand
    temp_B = B;  // Initialize multiplier

    for (i = 0; i < 8; i = i + 1) begin
        if (temp_B[0] == 1'b1) begin
            temp_product = temp_product + {8'd0, temp_A};  // Add multiplicand to product if current bit of multiplier is 1
        end
        temp_A = temp_A << 1;  // Shift multiplicand left by 1 bit
        temp_B = temp_B >> 1;  // Shift multiplier right by 1 bit
    end

    product = temp_product;  // Assign final product to output
end

endmodule