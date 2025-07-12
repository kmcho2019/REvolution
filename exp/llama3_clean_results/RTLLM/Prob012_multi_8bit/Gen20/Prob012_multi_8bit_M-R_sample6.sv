module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Using continuous assignment to describe the shift-and-add method
    wire [15:0] add_0, add_1, add_2, add_3, add_4, add_5, add_6, add_7;
    assign add_0 = (B[0] == 1'b1)? A : 16'd0;
    assign add_1 = (B[1] == 1'b1)? (A << 1) : 16'd0;
    assign add_2 = (B[2] == 1'b1)? (A << 2) : 16'd0;
    assign add_3 = (B[3] == 1'b1)? (A << 3) : 16'd0;
    assign add_4 = (B[4] == 1'b1)? (A << 4) : 16'd0;
    assign add_5 = (B[5] == 1'b1)? (A << 5) : 16'd0;
    assign add_6 = (B[6] == 1'b1)? (A << 6) : 16'd0;
    assign add_7 = (B[7] == 1'b1)? (A << 7) : 16'd0;

    // Summing all the additions to get the final product
    assign product = add_0 + add_1 + add_2 + add_3 + add_4 + add_5 + add_6 + add_7;

endmodule