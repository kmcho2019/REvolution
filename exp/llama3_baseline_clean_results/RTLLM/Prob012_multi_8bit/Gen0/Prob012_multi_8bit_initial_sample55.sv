module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output reg [15:0] product  // 16-bit output representing the product of A and B
);

    initial begin
        product = 0;
        reg [7:0] A_shifted;
        A_shifted = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i] == 1'b1) begin
                product = product + (A_shifted << i);
            end
            // No need to shift A_shifted here, as we're shifting in the addition itself
        end
    end

endmodule