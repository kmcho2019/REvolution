module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    wire [15:0] partial_product;
    assign partial_product = (B[0]? A         : 16'd0) +
                             (B[1]? (A << 1)   : 16'd0) +
                             (B[2]? (A << 2)   : 16'd0) +
                             (B[3]? (A << 3)   : 16'd0) +
                             (B[4]? (A << 4)   : 16'd0) +
                             (B[5]? (A << 5)   : 16'd0) +
                             (B[6]? (A << 6)   : 16'd0) +
                             (B[7]? (A << 7)   : 16'd0);

    assign product = partial_product;

endmodule