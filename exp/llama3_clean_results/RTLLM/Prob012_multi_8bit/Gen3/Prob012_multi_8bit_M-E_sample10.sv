module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;
    assign product = temp_product;

    always @(*) begin
        temp_product = 16'd0;  // Initialize product to zero
        reg [7:0] temp_A = A;  // Temporary multiplicand
        reg [7:0] temp_B = B;  // Temporary multiplier

        for (int i = 0; i < 8; i++) begin
            if (temp_B[0]) begin  // Check if the least significant bit of the multiplier is set
                temp_product = temp_product + {8'd0, temp_A};  // Add the multiplicand to the product
            end
            temp_A = temp_A << 1;  // Shift the multiplicand left by one bit
            temp_B = temp_B >> 1;  // Shift the multiplier right by one bit
        end
    end

endmodule