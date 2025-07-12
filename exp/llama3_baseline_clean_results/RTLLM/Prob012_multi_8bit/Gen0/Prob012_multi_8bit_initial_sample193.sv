module multi_8bit(
    input [7:0] A, // First 8-bit input operand (multiplicand)
    input [7:0] B, // Second 8-bit input operand (multiplier)
    output [15:0] product // 16-bit output representing the product of A and B
);

    reg [15:0] product_reg; // Internal register to hold the product
    reg [7:0] A_reg; // Internal register to hold the multiplicand
    reg [7:0] B_reg; // Internal register to hold the multiplier
    reg [2:0] count; // Counter to iterate through each bit of the multiplier

    always @(*) begin
        product_reg = 16'd0; // Initialize product to 0
        A_reg = A; // Initialize multiplicand
        B_reg = B; // Initialize multiplier
        count = 3'd0; // Initialize counter

        while (count < 8) begin
            if (B_reg[0] == 1'b1) begin // Check if LSB of multiplier is '1'
                product_reg = product_reg + {{8{1'b0}}, A_reg}; // Add multiplicand to product
            end

            // Shift multiplicand left by one bit
            A_reg = {1'b0, A_reg[7:1]};

            // Shift multiplier right by one bit
            B_reg = {B_reg[6:0], 1'b0};

            count = count + 1; // Increment counter
        end

        product = product_reg; // Assign final product to output
    end

endmodule