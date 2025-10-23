module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp;
    reg [7:0] shifted_A;

    always @(*) begin
        temp = 0;
        shifted_A = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                temp = temp + (shifted_A << i);
            end
            shifted_A = shifted_A << 1;
        end
        product = temp;
    end

endmodule