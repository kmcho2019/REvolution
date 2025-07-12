module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize the product to 0
    reg [15:0] prod;
    always @(*) begin
        prod = 16'd0;
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                // For each set bit in B, add A shifted left by i bits to the product
                prod = prod + (A << i);
            end
        end
        product = prod;
    end

endmodule