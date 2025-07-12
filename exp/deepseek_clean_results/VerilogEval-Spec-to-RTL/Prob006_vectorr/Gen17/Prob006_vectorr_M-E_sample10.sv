module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Intermediate signals for swap stages
    wire [7:0] stage0, stage1, stage2;

    // Stage 0: Swap adjacent bits (distance 1)
    assign stage0[0] = in[1];
    assign stage0[1] = in[0];
    assign stage0[2] = in[3];
    assign stage0[3] = in[2];
    assign stage0[4] = in[5];
    assign stage0[5] = in[4];
    assign stage0[6] = in[7];
    assign stage0[7] = in[6];

    // Stage 1: Swap bits at distance 2
    assign stage1[0] = stage0[2];
    assign stage1[1] = stage0[3];
    assign stage1[2] = stage0[0];
    assign stage1[3] = stage0[1];
    assign stage1[4] = stage0[6];
    assign stage1[5] = stage0[7];
    assign stage1[6] = stage0[4];
    assign stage1[7] = stage0[5];

    // Stage 2: Swap bits at distance 4
    assign stage2[0] = stage1[4];
    assign stage2[1] = stage1[5];
    assign stage2[2] = stage1[6];
    assign stage2[3] = stage1[7];
    assign stage2[4] = stage1[0];
    assign stage2[5] = stage1[1];
    assign stage2[6] = stage1[2];
    assign stage2[7] = stage1[3];

    // Final output
    assign out = stage2;

endmodule