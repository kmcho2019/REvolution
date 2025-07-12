module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Bitwise tree multiplier architecture
    wire [7:0]  seg_a1, seg_a2, seg_a3, seg_a4;
    wire [3:0]  prod1, prod2, prod3, prod4;
    wire [7:0]  temp1, temp2, temp3;
    wire [15:0] temp4;

    // Divide the multiplicand (A) into smaller segments
    assign seg_a1 = A[7:6];
    assign seg_a2 = A[5:4];
    assign seg_a3 = A[3:2];
    assign seg_a4 = A[1:0];

    // Multiply each segment by the corresponding bits of the multiplier (B)
    assign prod1 = (seg_a1 & B[7:6]) << 6;
    assign prod2 = (seg_a2 & B[5:4]) << 4;
    assign prod3 = (seg_a3 & B[3:2]) << 2;
    assign prod4 = (seg_a4 & B[1:0]);

    // Combine the results using a tree-like structure
    assign temp1 = prod1 + prod2;
    assign temp2 = prod3 + prod4;
    assign temp3 = temp1 + temp2;
    assign temp4 = {8'b0, seg_a1} * B[7] + {8'b0, seg_a2} * B[5] + {8'b0, seg_a3} * B[3] + {8'b0, seg_a4} * B[1];

    // Final product
    assign product = temp3 + temp4;

endmodule