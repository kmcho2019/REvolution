module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] p;  // Internal register to store the product
    reg [7:0] a;   // Internal register to store the multiplicand (A)
    integer i;      // Loop counter

    always @(A or B) begin
        p = 0;      // Initialize product to 0
        a = A;      // Load multiplicand (A) into internal register
        for (i = 0; i < 8; i = i + 1) begin
            if (B[i] == 1'b1) begin
                // Add the multiplicand (A) to the product at the corresponding shifted position
                p = p + (a << i);
            end
            // Shift the multiplicand (A) left by one bit for the next iteration
            a = a << 1;
        end
        product = p;  // Assign the final product to the output port
    end

endmodule