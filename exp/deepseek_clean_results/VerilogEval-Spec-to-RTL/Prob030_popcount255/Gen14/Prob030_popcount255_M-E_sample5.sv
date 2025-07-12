module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Level 1: Count 1s in all possible 2-bit windows (127 windows)
    wire [7:0] level1 [0:126];
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : COUNT_2BITS
            assign level1[i] = {6'b0, in[2*i]} + {6'b0, in[2*i+1]};
        end
    endgenerate

    // Level 2: Sum adjacent pairs (63 windows)
    wire [7:0] level2 [0:62];
    generate
        for (i = 0; i < 63; i = i + 1) begin : SUM_LEVEL1
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
    endgenerate

    // Level 3: Sum adjacent pairs (31 windows)
    wire [7:0] level3 [0:30];
    generate
        for (i = 0; i < 31; i = i + 1) begin : SUM_LEVEL2
            assign level3[i] = level2[2*i] + level2[2*i+1];
        end
    endgenerate

    // Level 4: Sum adjacent pairs (15 windows)
    wire [7:0] level4 [0:14];
    generate
        for (i = 0; i < 15; i = i + 1) begin : SUM_LEVEL3
            assign level4[i] = level3[2*i] + level3[2*i+1];
        end
    endgenerate

    // Level 5: Sum adjacent pairs (7 windows)
    wire [7:0] level5 [0:6];
    generate
        for (i = 0; i < 7; i = i + 1) begin : SUM_LEVEL4
            assign level5[i] = level4[2*i] + level4[2*i+1];
        end
    endgenerate

    // Level 6: Sum adjacent pairs (3 windows)
    wire [7:0] level6 [0:2];
    generate
        for (i = 0; i < 3; i = i + 1) begin : SUM_LEVEL5
            assign level6[i] = level5[2*i] + level5[2*i+1];
        end
    endgenerate

    // Level 7: Sum adjacent pairs (1 window) + remaining bits
    wire [7:0] level7 = level6[0] + level6[1] + {6'b0, in[254]};

    assign out = level7;

endmodule