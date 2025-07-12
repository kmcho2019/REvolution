module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Pad input to 256 bits with 0
    wire [255:0] padded_in = {1'b0, in};

    // First level: Count 1s in each 8-bit group (32 groups)
    wire [3:0] group_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : COUNT_8BITS
            wire [7:0] group = padded_in[i*8 +: 8];
            assign group_counts[i] = group[0] + group[1] + group[2] + group[3] +
                                     group[4] + group[5] + group[6] + group[7];
        end
    endgenerate

    // Second level: Sum counts in binary tree fashion
    wire [7:0] level1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : SUM_LEVEL1
            assign level1[i] = group_counts[i*2] + group_counts[i*2+1];
        end
    endgenerate

    wire [7:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_LEVEL2
            assign level2[i] = level1[i*2] + level1[i*2+1];
        end
    endgenerate

    wire [7:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUM_LEVEL3
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    wire [7:0] level4 [0:1];
    assign level4[0] = level3[0] + level3[1];
    assign level4[1] = level3[2] + level3[3];

    assign out = level4[0] + level4[1];

endmodule