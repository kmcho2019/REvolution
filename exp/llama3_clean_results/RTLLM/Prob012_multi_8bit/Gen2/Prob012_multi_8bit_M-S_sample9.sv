module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    // Perform multiplication using shift-and-add method
    always @(*) begin
        product = 0;  // Reset product at the start of each multiplication
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                // Add A shifted by i positions to the product
                product = product + (A << i);
            end
        end
    end

endmodule