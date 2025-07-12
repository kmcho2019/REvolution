module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Level 0: Individual bits (255 inputs)
    wire [7:0] level0 [0:254];
    genvar i;
    generate
        for (i = 0; i < 255; i = i + 1) begin : BIT_LEVEL
            assign level0[i] = {7'b0, in[i]};
        end
    endgenerate

    // Level 1: Sum pairs (128 outputs)
    wire [7:0] level1 [0:127];
    generate
        for (i = 0; i < 127; i = i + 1) begin : LEVEL1
            assign level1[i] = level0[i*2] + level0[i*2+1];
        end
        assign level1[127] = level0[254]; // Last odd bit
    endgenerate

    // Level 2: Sum pairs (64 outputs)
    wire [7:0] level2 [0:63];
    generate
        for (i = 0; i < 63; i = i + 1) begin : LEVEL2
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
        assign level2[63] = level1[127]; // Last odd sum
    endgenerate

    // Level 3: Sum pairs (32 outputs)
    wire [7:0] level3 [0:31];
    generate
        for (i = 0; i < 31; i = i + 1) begin : LEVEL3
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
        assign level3[31] = level2[63];
    endgenerate

    // Level 4: Sum pairs (16 outputs)
    wire [7:0] level4 [0:15];
    generate
        for (i = 0; i < 15; i = i + 1) begin : LEVEL4
            assign level4[i] = level3[i*2] + level3[i*2+1];
        end
        assign level4[15] = level3[31];
    endgenerate

    // Level 5: Sum pairs (8 outputs)
    wire [7:0] level5 [0:7];
    generate
        for (i = 0; i < 7; i = i + 1) begin : LEVEL5
            assign level5[i] = level4[i*2] + level4[i*2+1];
        end
        assign level5[7] = level4[15];
    endgenerate

    // Level 6: Sum pairs (4 outputs)
    wire [7:0] level6 [0:3];
    generate
        for (i = 0; i < 3; i = i + 1) begin : LEVEL6
            assign level6[i] = level5[i*2] + level5[i*2+1];
        end
        assign level6[3] = level5[7];
    endgenerate

    // Level 7: Sum pairs (2 outputs)
    wire [7:0] level7 [0:1];
    generate
        for (i = 0; i < 1; i = i + 1) begin : LEVEL7
            assign level7[i] = level6[i*2] + level6[i*2+1];
        end
        assign level7[1] = level6[3];
    endgenerate

    // Final sum
    assign out = level7[0] + level7[1];

endmodule