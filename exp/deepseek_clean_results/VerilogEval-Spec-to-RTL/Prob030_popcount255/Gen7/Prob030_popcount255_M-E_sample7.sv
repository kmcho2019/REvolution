module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: 255 bits -> 170 bits (85 3:2 compressors)
    wire [169:0] level1;
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : LEVEL1
            assign level1[2*i+1:2*i] = in[3*i] + in[3*i+1] + in[3*i+2];
        end
    endgenerate
    wire [4:0] level1_remain = in[254:255-5]; // Remaining 5 bits

    // Level 2: 170 bits -> 114 bits (57 3:2 compressors)
    wire [113:0] level2;
    generate
        for (i = 0; i < 57; i = i + 1) begin : LEVEL2
            assign level2[2*i+1:2*i] = level1[3*i] + level1[3*i+1] + level1[3*i+2];
        end
    endgenerate
    wire [1:0] level2_remain = level1[169:170-2]; // Remaining 2 bits

    // Level 3: 114 bits -> 76 bits (38 3:2 compressors)
    wire [75:0] level3;
    generate
        for (i = 0; i < 38; i = i + 1) begin : LEVEL3
            assign level3[2*i+1:2*i] = level2[3*i] + level2[3*i+1] + level2[3*i+2];
        end
    endgenerate
    wire [0:0] level3_remain = level2[113]; // Remaining 1 bit

    // Level 4: 76 bits -> 51 bits (25 3:2 compressors + 1 bit remaining)
    wire [50:0] level4;
    generate
        for (i = 0; i < 25; i = i + 1) begin : LEVEL4
            assign level4[2*i+1:2*i] = level3[3*i] + level3[3*i+1] + level3[3*i+2];
        end
    endgenerate
    wire [0:0] level4_remain = level3[75]; // Remaining 1 bit

    // Level 5: 51 bits -> 34 bits (17 3:2 compressors)
    wire [33:0] level5;
    generate
        for (i = 0; i < 17; i = i + 1) begin : LEVEL5
            assign level5[2*i+1:2*i] = level4[3*i] + level4[3*i+1] + level4[3*i+2];
        end
    endgenerate

    // Final accumulation with proper weighting
    wire [7:0] count_level1 = level1_remain;
    wire [7:0] count_level2 = {1'b0, level2_remain} + (level1_remain << 1);
    wire [7:0] count_level3 = {2'b0, level3_remain} + (count_level2 << 1);
    wire [7:0] count_level4 = {3'b0, level4_remain} + (count_level3 << 1);
    wire [7:0] count_level5 = level5[33:0] + (count_level4 << 1);

    assign out = count_level5;

endmodule