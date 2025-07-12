module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Pad input to 256 bits (next power of 2)
    wire [255:0] padded_in = {in, 1'b0};

    // Level 1: Count '1's in 4-bit chunks (64 chunks)
    wire [2:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level1_counters
            wire [3:0] group = padded_in[i*4 +: 4];
            assign level1[i] = group[0] + group[1] + group[2] + group[3];
        end
    endgenerate

    // Level 2: Sum pairs of level1 counters (32 groups)
    wire [3:0] level2 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
    endgenerate

    // Level 3: Sum pairs of level2 counters (16 groups)
    wire [4:0] level3 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    // Level 4: Sum pairs of level3 counters (8 groups)
    wire [5:0] level4 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*2] + level3[i*2+1];
        end
    endgenerate

    // Level 5: Sum pairs of level4 counters (4 groups)
    wire [6:0] level5 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level5_adders
            assign level5[i] = level4[i*2] + level4[i*2+1];
        end
    endgenerate

    // Level 6: Sum pairs of level5 counters (2 groups)
    wire [7:0] level6 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level6_adders
            assign level6[i] = level5[i*2] + level5[i*2+1];
        end
    endgenerate

    // Final sum
    assign out = level6[0] + level6[1];

endmodule