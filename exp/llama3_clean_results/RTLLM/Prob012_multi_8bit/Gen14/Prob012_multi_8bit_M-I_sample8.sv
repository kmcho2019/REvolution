module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary variable to store the product
    reg [7:0] temp_A;  // Temporary variable to store the multiplicand
    reg [7:0] temp_B;  // Temporary variable to store the multiplier
    integer i;  // Loop counter

    initial begin
        temp_product = 0;  // Initialize the product to 0
        temp_A = A;  // Initialize the multiplicand
        temp_B = B;  // Initialize the multiplier
    end

    always @(A or B) begin
        temp_product = 0;  // Reset the product
        temp_A = A;  // Reset the multiplicand
        temp_B = B;  // Reset the multiplier

        for (i = 0; i < 8; i = i + 1) begin
            if (temp_B[0] == 1) begin
                temp_product = temp_product + temp_A;  // Add the multiplicand to the product
            end
            temp_A = temp_A << 1;  // Shift the multiplicand left by 1 bit
            temp_B = temp_B >> 1;  // Shift the multiplier right by 1 bit
        end
    end

    assign product = temp_product;  // Assign the product to the output

endmodule