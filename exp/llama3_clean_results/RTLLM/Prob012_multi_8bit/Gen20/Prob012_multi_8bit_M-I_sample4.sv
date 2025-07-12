// Module: multi_8bit
// Description: 8-bit multiplier using shift-and-add method
module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary product register
    reg [7:0] temp_A;  // Temporary multiplicand register
    reg [7:0] temp_B;  // Temporary multiplier register
    integer i;  // Loop counter

    // Initialize temporary product and multiplicand registers
    initial begin
        temp_product = 0;
        temp_A = A;
    end

    // Perform multiplication using shift-and-add method
    always @(*) begin
        temp_B = B;
        temp_product = 0;
        for (i = 0; i < 8; i = i + 1) begin
            // Check if current bit of multiplier is set
            if (temp_B[0] == 1'b1) begin
                // Add shifted multiplicand to product
                temp_product = temp_product + {8'd0, temp_A};
            end
            // Shift multiplicand left by one bit
            temp_A = temp_A << 1;
            // Shift multiplier right by one bit
            temp_B = temp_B >> 1;
        end
    end

    // Assign final product to output
    assign product = temp_product;

endmodule