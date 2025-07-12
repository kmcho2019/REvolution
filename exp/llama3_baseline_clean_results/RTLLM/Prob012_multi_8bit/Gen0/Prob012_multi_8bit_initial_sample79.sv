module multi_8bit (
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product
);

reg [15:0] product_reg;  // Temporary register to hold the product
reg [7:0] A_shifted;  // Temporary register to hold the shifted multiplicand

always @(A or B) begin  // Procedural block sensitive to A and B
    product_reg = 16'd0;  // Initialize product to 0
    A_shifted = A;  // Initialize shifted multiplicand to A

    for (int i = 0; i < 8; i = i + 1) begin  // Loop through each bit of B
        if (B[i]) begin  // Check if current bit of B is 1
            product_reg = product_reg + {8'd0, A_shifted};  // Add shifted A to product
        end
        A_shifted = A_shifted << 1;  // Shift A left by 1 bit
    end

    product = product_reg;  // Assign final product to output
end

endmodule