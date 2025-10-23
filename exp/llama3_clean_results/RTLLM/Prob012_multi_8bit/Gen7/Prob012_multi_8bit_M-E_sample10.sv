module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Define the LUTs for higher and lower 4 bits of the multiplier
    reg [15:0] lut_higher [0:15];
    reg [15:0] lut_lower [0:15];
    integer i;
    always @(A) begin
        for (i = 0; i < 16; i++) begin
            lut_higher[i] = A * (i << 4); // Pre-compute for higher 4 bits
            lut_lower[i] = A * i; // Pre-compute for lower 4 bits
        end
    end

    // Calculate the final product using the LUTs
    assign product = lut_higher[B[7:4]] + lut_lower[B[3:0]];

endmodule