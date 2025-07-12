module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    assign product = 
        (B[0] ? (A << 0) : 0) +
        (B[1] ? (A << 1) : 0) +
        (B[2] ? (A << 2) : 0) +
        (B[3] ? (A << 3) : 0) +
        (B[4] ? (A << 4) : 0) +
        (B[5] ? (A << 5) : 0) +
        (B[6] ? (A << 6) : 0) +
        (B[7] ? (A << 7) : 0);

endmodule