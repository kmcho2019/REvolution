module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] prod;  // Internal 16-bit product register
    reg [7:0] temp_A;  // Temporary register for multiplicand A
    integer i;  // Loop counter

    // Initialize product and temp_A
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
                prod = prod + (temp_A << i);
            end
            // No need to shift temp_A here, as we are just checking each bit of B
        end
        product = prod;
    end

endmodule