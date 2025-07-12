module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    wire [15:0] temp;
    assign product[0] = (A[0] && B[0]) ? 1'b1 : 1'b0;

    // Shift and add for each bit position
    assign product[1] = (A[1] && B[0]) ? 1'b1 : 1'b0;
    assign product[2] = (A[2] && B[0]) ? 1'b1 : 1'b0;
    assign product[3] = (A[3] && B[0]) ? 1'b1 : 1'b0;
    assign product[4] = (A[4] && B[0]) ? 1'b1 : 1'b0;
    assign product[5] = (A[5] && B[0]) ? 1'b1 : 1'b0;
    assign product[6] = (A[6] && B[0]) ? 1'b1 : 1'b0;
    assign product[7] = (A[7] && B[0]) ? 1'b1 : 1'b0;

    assign product[8] = (A[0] && B[1]) ? 1'b1 : 1'b0;
    assign product[9] = (A[1] && B[1]) ? 1'b1 : 1'b0;
    assign product[10] = (A[2] && B[1]) ? 1'b1 : 1'b0;
    assign product[11] = (A[3] && B[1]) ? 1'b1 : 1'b0;
    assign product[12] = (A[4] && B[1]) ? 1'b1 : 1'b0;
    assign product[13] = (A[5] && B[1]) ? 1'b1 : 1'b0;
    assign product[14] = (A[6] && B[1]) ? 1'b1 : 1'b0;
    assign product[15] = (A[7] && B[1]) ? 1'b1 : 1'b0;

    // ... repeat the pattern for all bits of B

endmodule