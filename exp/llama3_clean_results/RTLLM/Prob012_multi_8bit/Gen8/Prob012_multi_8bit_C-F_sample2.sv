module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary variable to store the product
    reg [7:0] temp_A;  // Temporary variable to store the multiplicand
    reg [7:0] temp_B;  // Temporary variable to store the multiplier
    integer i;  // Loop counter

    // Initialize the temporary variables
    initial begin
        temp_product = 0;
        temp_A = A;
        temp_B = B;
    end

    // Perform the multiplication using the shift-and-add method
    always @(*) begin
        temp_product = 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (temp_B[i] == 1) begin
                temp_product = temp_product + (temp_A << i);
            end
        end
    end

    // Assign the final product to the output port
    assign product = temp_product;

endmodule