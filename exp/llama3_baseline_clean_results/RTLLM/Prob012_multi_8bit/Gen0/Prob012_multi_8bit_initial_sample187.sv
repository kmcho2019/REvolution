module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // Internal register to hold the product
    reg [7:0]  temp_A;  // Temporary register to hold A for shifting
    integer i;  // Loop variable

    // Initialize product and temporary A
    initial begin
        prod = 0;
        temp_A = A;
    end

    // Perform multiplication using shift-and-add method
    always @(*) begin
        prod = 0;
        temp_A = A;
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin
                // Add shifted A to the product
                prod = prod + (temp_A << i);
            end
            // Shift A left by one bit for the next iteration
            if (i < 7) begin
                temp_A = temp_A << 1;
            end
        end
    end

    // Assign the final product to the output port
    assign product = prod;

endmodule