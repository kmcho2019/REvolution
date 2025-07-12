module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire [15:0] slice_a1, slice_a2, slice_a3, slice_a4;
    wire [15:0] slice_b1, slice_b2, slice_b3, slice_b4;
    wire [15:0] diff1, diff2, diff3, diff4;
    wire        carry1, carry2, carry3;
    wire        overflow1, overflow2, overflow3, overflow4;

    assign slice_a1 = A[15:0];
    assign slice_a2 = A[31:16];
    assign slice_a3 = A[47:32];
    assign slice_a4 = A[63:48];

    assign slice_b1 = B[15:0];
    assign slice_b2 = B[31:16];
    assign slice_b3 = B[47:32];
    assign slice_b4 = B[63:48];

    assign diff1 = slice_a1 - slice_b1;
    assign overflow1 = (slice_a1[15] != slice_b1[15]) && (slice_a1[15] != diff1[15]);

    assign diff2 = slice_a2 - slice_b2 - {15'b0, carry1};
    assign carry1 = (slice_a1 < slice_b1) ? 1'b1 : 1'b0;
    assign overflow2 = (slice_a2[15] != slice_b2[15]) && (slice_a2[15] != diff2[15]);

    assign diff3 = slice_a3 - slice_b3 - {15'b0, carry2};
    assign carry2 = (slice_a2 < slice_b2) || (slice_a2 == slice_b2 && carry1) ? 1'b1 : 1'b0;
    assign overflow3 = (slice_a3[15] != slice_b3[15]) && (slice_a3[15] != diff3[15]);

    assign diff4 = slice_a4 - slice_b4 - {15'b0, carry3};
    assign carry3 = (slice_a3 < slice_b3) || (slice_a3 == slice_b3 && carry2) ? 1'b1 : 1'b0;
    assign overflow4 = (slice_a4[15] != slice_b4[15]) && (slice_a4[15] != diff4[15]);

    assign result = {diff4, diff3, diff2, diff1};
    assign overflow = overflow1 || overflow2 || overflow3 || overflow4;

endmodule