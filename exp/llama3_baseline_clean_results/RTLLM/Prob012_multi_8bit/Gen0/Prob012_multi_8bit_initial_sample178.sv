module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize product to zero
    reg [15:0] temp_product;

    always @(A or B) begin
        temp_product = 0;
        for (int i = 0; i < 8; i++) begin
            // Check if the current bit of B is set
            if (B[i]) begin
                // Add A shifted by the current bit position to the product
                temp_product = temp_product + (A << i);
            end
        end
        // Assign the final product to the output port
        product = temp_product;
    end

endmodule