module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Sum bits in groups of 4 (64 groups)
    wire [2:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : LEVEL1
            assign level1[i] = in[i*4] + in[i*4+1] + in[i*4+2] + in[i*4+3];
        end
        // Last group handles remaining 3 bits (255 = 63*4 + 3)
        assign level1[63] = in[252] + in[253] + in[254];
    endgenerate

    // Second level: Sum level1 results in groups of 4 (16 groups)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2
            assign level2[i] = level1[i*4] + level1[i*4+1] + level1[i*4+2] + level1[i*4+3];
        end
    endgenerate

    // Third level: Sum level2 results in groups of 4 (4 groups)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            assign level3[i] = level2[i*4] + level2[i*4+1] + level2[i*4+2] + level2[i*4+3];
        end
    endgenerate

    // Final sum of all level3 results (balanced tree)
    wire [7:0] sum_01 = level3[0] + level3[1];
    wire [7:0] sum_23 = level3[2] + level3[3];
    assign out = sum_01 + sum_23;

endmodule