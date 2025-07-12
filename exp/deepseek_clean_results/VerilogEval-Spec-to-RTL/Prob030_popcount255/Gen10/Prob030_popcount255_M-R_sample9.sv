module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in groups of 4 (64 groups, last group has 3 bits)
    wire [2:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : LEVEL1
            if (i == 63) begin
                assign level1[i] = in[254] + in[253] + in[252];  // Last group has only 3 bits
            end else begin
                assign level1[i] = in[i*4+3] + in[i*4+2] + in[i*4+1] + in[i*4];
            end
        end
    endgenerate

    // Second level: Sum level1 results in groups of 4 (16 groups)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2
            assign level2[i] = level1[i*4] + level1[i*4+1] + level1[i*4+2] + level1[i*4+3];
        end
    endgenerate

    // Final sum of all level2 results
    assign out = level2[0] + level2[1] + level2[2] + level2[3] +
                 level2[4] + level2[5] + level2[6] + level2[7] +
                 level2[8] + level2[9] + level2[10] + level2[11] +
                 level2[12] + level2[13] + level2[14] + level2[15];

endmodule