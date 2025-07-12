module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product of A and B
);

reg [15:0] product_reg;  // Internal register to store the product

always @(A or B) begin
    product_reg = 0;  // Initialize the product register to 0
    reg [7:0] A_reg = A;  // Create a copy of input A

    for (int i = 0; i < 8; i++) begin
        if (B[i]) begin  // Check if the current bit of B is set
            product_reg = product_reg + (A_reg << i);  // Add the shifted A to the product
        end
        // No need for explicit shift here, as we're using the shifted value of A in the next iteration
    end

    product = product_reg;  // Assign the final product to the output port
end

endmodule