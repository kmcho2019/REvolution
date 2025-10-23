module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // We'll perform a binary tree reduction summing the bits in stages.
    // Stage 0: input bits are 1 bit each.
    // At each stage, sum pairs of elements, resulting in half the number of elements with double bit width (plus one).
    // Continue until one element remains, which is the total popcount.

    // Stage 0: 255 x 1-bit
    // Stage 1: 127 x 2-bit (127 pairs + 1 leftover)
    // Stage 2: 64 x 3-bit (64 pairs)
    // Stage 3: 32 x 4-bit
    // Stage 4: 16 x 5-bit
    // Stage 5: 8 x 6-bit
    // Stage 6: 4 x 7-bit
    // Stage 7: 2 x 8-bit
    // Stage 8: 1 x 8-bit (final sum)

    // To handle odd sizes, propagate the leftover directly to next stage.

    // Define intermediate wires for each stage
    // Use localparam arrays for sizes

    // Stage 0: 255 elements of 1 bit
    wire [0:0] stage0 [254:0];
    genvar i;
    generate
        for(i = 0; i < 255; i = i +1) begin
            assign stage0[i] = in[i];
        end
    endgenerate

    // Helper macro to define stages to avoid repeated code
    // We'll build stage1 to stage8

    // Define widths of each stage element
    localparam w1 = 2;
    localparam w2 = 3;
    localparam w3 = 4;
    localparam w4 = 5;
    localparam w5 = 6;
    localparam w6 = 7;
    localparam w7 = 8;

    // Stage 1: sum pairs of stage0 (255 elements of 1 bit)
    // 127 pairs + 1 leftover
    wire [w1-1:0] stage1 [127:0];
    generate
        for(i=0; i<127; i=i+1) begin
            assign stage1[i] = stage0[2*i] + stage0[2*i+1];
        end
    endgenerate
    wire [w1-1:0] stage1_leftover = stage0[254];

    // Stage 2: sum pairs of stage1 plus leftover
    // stage1 has 128 elements (127 + leftover)
    // We'll append leftover as last element for next stage
    wire [w2-1:0] stage2 [63:0];
    generate
        for(i=0; i<63; i=i+1) begin
            assign stage2[i] = stage1[2*i] + stage1[2*i+1];
        end
    endgenerate
    wire [w2-1:0] stage2_leftover = stage1[127] + stage1_leftover;

    // Stage 3: sum pairs of stage2 + leftover
    // stage2 has 64 elements (63 + leftover combined as one)
    wire [w3-1:0] stage3 [31:0];
    generate
        for(i=0; i<31; i=i+1) begin
            assign stage3[i] = stage2[2*i] + stage2[2*i+1];
        end
    endgenerate
    wire [w3-1:0] stage3_leftover = stage2[62] + stage2_leftover;

    // Stage 4: sum pairs of stage3 + leftover
    // 32 elements (31 + leftover)
    wire [w4-1:0] stage4 [15:0];
    generate
        for(i=0; i<15; i=i+1) begin
            assign stage4[i] = stage3[2*i] + stage3[2*i+1];
        end
    endgenerate
    wire [w4-1:0] stage4_leftover = stage3[30] + stage3_leftover;

    // Stage 5: sum pairs of stage4 + leftover
    // 16 elements (15 + leftover)
    wire [w5-1:0] stage5 [7:0];
    generate
        for(i=0; i<7; i=i+1) begin
            assign stage5[i] = stage4[2*i] + stage4[2*i+1];
        end
    endgenerate
    wire [w5-1:0] stage5_leftover = stage4[14] + stage4_leftover;

    // Stage 6: sum pairs of stage5 + leftover
    // 8 elements (7 + leftover)
    wire [w6-1:0] stage6 [3:0];
    generate
        for(i=0; i<3; i=i+1) begin
            assign stage6[i] = stage5[2*i] + stage5[2*i+1];
        end
    endgenerate
    wire [w6-1:0] stage6_leftover = stage5[6] + stage5_leftover;

    // Stage 7: sum pairs of stage6 + leftover
    // 4 elements (3 + leftover)
    wire [w7-1:0] stage7 [1:0];
    assign stage7[0] = stage6[0] + stage6[1];
    assign stage7[1] = stage6[2] + stage6_leftover;

    // Stage 8: final sum of stage7 elements
    assign out = stage7[0] + stage7[1];

endmodule