module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in groups of 3 (85 groups)
    wire [6:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : LEVEL1
            assign level1[i] = (i*3+2 <= 254) ? (in[i*3] + in[i*3+1] + in[i*3+2]) : 
                               (i*3+1 <= 254) ? (in[i*3] + in[i*3+1]) : 
                               in[i*3];
        end
    endgenerate

    // Second level: Sum level1 results in groups of 5 (17 groups)
    wire [8:0] level2 [0:16];
    generate
        for (i = 0; i < 17; i = i + 1) begin : LEVEL2
            assign level2[i] = (i*5+4 <= 84) ? (level1[i*5] + level1[i*5+1] + level1[i*5+2] + level1[i*5+3] + level1[i*5+4]) :
                               (i*5+3 <= 84) ? (level1[i*5] + level1[i*5+1] + level1[i*5+2] + level1[i*5+3]) :
                               (i*5+2 <= 84) ? (level1[i*5] + level1[i*5+1] + level1[i*5+2]) :
                               (i*5+1 <= 84) ? (level1[i*5] + level1[i*5+1]) :
                               level1[i*5];
        end
    endgenerate

    // Final sum of all level2 results
    assign out = level2[0] + level2[1] + level2[2] + level2[3] + level2[4] +
                 level2[5] + level2[6] + level2[7] + level2[8] + level2[9] +
                 level2[10] + level2[11] + level2[12] + level2[13] + level2[14] +
                 level2[15] + level2[16];

endmodule