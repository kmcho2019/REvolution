module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Initialize the product to zero
    reg [15:0] prod;
    initial prod = 0;

    // Perform multiplication using the shift-and-add method
    always @(*) begin
        prod = 0;
        reg [7:0] temp_A;
        temp_A = A;
        for (int i = 0; i < 8; i++) begin
            if (B[i]) begin
                prod = prod + (temp_A << i);
            end
            temp_A = temp_A << 1;
        end
    end

    // Assign the final product to the output port
    assign product = prod;

endmodule