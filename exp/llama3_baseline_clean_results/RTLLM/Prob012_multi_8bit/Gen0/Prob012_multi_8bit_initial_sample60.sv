module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand
    input   [7:0] B,  // Second 8-bit input operand
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    always @(*) begin
        product = 0;  // Initialize product to zero
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin  // Check if the current bit in B is set
                product = product + (A << i);  // Add A shifted left by i bits to the product
            end
        end
    end

endmodule