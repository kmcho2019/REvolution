module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in pairs (127 adders)
    wire [7:0] level1 [0:126];
    genvar i;
    generate
        for (i = 0; i < 127; i = i + 1) begin : L1
            assign level1[i] = in[i*2] + in[i*2+1];
        end
    endgenerate

    // Second level: Sum pairs of level1 results (63 adders)
    wire [7:0] level2 [0:62];
    generate
        for (i = 0; i < 63; i = i + 1) begin : L2
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
    endgenerate

    // Third level: Sum pairs of level2 results (31 adders)
    wire [7:0] level3 [0:30];
    generate
        for (i = 0; i < 31; i = i + 1) begin : L3
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    // Fourth level: Sum pairs of level3 results (15 adders)
    wire [7:0] level4 [0:14];
    generate
        for (i = 0; i < 15; i = i + 1) begin : L4
            assign level4[i] = level3[i*2] + level3[i*2+1];
        end
    endgenerate

    // Fifth level: Sum pairs of level4 results (7 adders)
    wire [7:0] level5 [0:6];
    generate
        for (i = 0; i < 7; i = i + 1) begin : L5
            assign level5[i] = level4[i*2] + level4[i*2+1];
        end
    endgenerate

    // Sixth level: Sum pairs of level5 results (3 adders)
    wire [7:0] level6 [0:2];
    generate
        for (i = 0; i < 3; i = i + 1) begin : L6
            assign level6[i] = level5[i*2] + level5[i*2+1];
        end
    endgenerate

    // Seventh level: Sum remaining results
    wire [7:0] level7 = level6[0] + level6[1] + level6[2] + level5[6];

    // Final sum including the 255th bit
    assign out = level7 + in[254];

endmodule