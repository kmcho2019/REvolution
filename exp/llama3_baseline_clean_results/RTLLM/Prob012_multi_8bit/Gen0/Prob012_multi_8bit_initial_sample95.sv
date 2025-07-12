module multi_8bit(
    input [7:0] A,  // First 8-bit input operand
    input [7:0] B,  // Second 8-bit input operand
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] temp_product;  // Temporary variable to hold the product during calculation
    reg [7:0] temp_A;  // Temporary variable to hold A during shifting

    integer i;  // Loop counter

    // Initialize the temporary variables
    initial begin
        temp_product = 0;
        temp_A = A;
    end

    // Perform the multiplication using the shift-and-add method
    always @(*) begin
        temp_product = 0;
        temp_A = A;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin
                temp_product = temp_product + (temp_A << i);
            end
            // No need to explicitly shift temp_A here as it's used in the next iteration with the correct shift value
        end
        product = temp_product;
    end

endmodule