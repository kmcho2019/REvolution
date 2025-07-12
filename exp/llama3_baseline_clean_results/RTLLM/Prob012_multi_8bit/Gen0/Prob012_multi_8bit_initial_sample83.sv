module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product of A and B
);

    always_comb begin
        product = 16'd0;  // Initialize product to 0
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                // Add A shifted left by i bits to the product
                product = product + (A << i);
            end
        end
    end

endmodule