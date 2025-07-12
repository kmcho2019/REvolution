module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Level 0: 256 candidates
    wire [3:0] level0 [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : input_mapping
            assign level0[i] = in[i*4 +: 4];
        end
    endgenerate

    // Level 1: 128 candidates (sel[0] decides)
    wire [3:0] level1 [0:127];
    generate
        for (i = 0; i < 128; i = i + 1) begin : level1_mux
            assign level1[i] = sel[0] ? level0[i*2+1] : level0[i*2];
        end
    endgenerate

    // Level 2: 64 candidates (sel[1] decides)
    wire [3:0] level2 [0:63];
    generate
        for (i = 0; i < 64; i = i + 1) begin : level2_mux
            assign level2[i] = sel[1] ? level1[i*2+1] : level1[i*2];
        end
    endgenerate

    // Level 3: 32 candidates (sel[2] decides)
    wire [3:0] level3 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : level3_mux
            assign level3[i] = sel[2] ? level2[i*2+1] : level2[i*2];
        end
    endgenerate

    // Level 4: 16 candidates (sel[3] decides)
    wire [3:0] level4 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level4_mux
            assign level4[i] = sel[3] ? level3[i*2+1] : level3[i*2];
        end
    endgenerate

    // Level 5: 8 candidates (sel[4] decides)
    wire [3:0] level5 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level5_mux
            assign level5[i] = sel[4] ? level4[i*2+1] : level4[i*2];
        end
    endgenerate

    // Level 6: 4 candidates (sel[5] decides)
    wire [3:0] level6 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level6_mux
            assign level6[i] = sel[5] ? level5[i*2+1] : level5[i*2];
        end
    endgenerate

    // Level 7: 2 candidates (sel[6] decides)
    wire [3:0] level7 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level7_mux
            assign level7[i] = sel[6] ? level6[i*2+1] : level6[i*2];
        end
    endgenerate

    // Final level: 1 output (sel[7] decides)
    assign out = sel[7] ? level7[1] : level7[0];

endmodule