module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 4-bit chunks (64 chunks, last chunk 3 bits)
    wire [2:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*4] + in[i*4+1] + in[i*4+2] + in[i*4+3];
        end
        // Last chunk handles remaining 3 bits
        assign level1[63] = in[252] + in[253] + in[254];
    endgenerate

    // Level 2: Sum 4 level1 counters (16 groups)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*4] + level1[i*4+1] + level1[i*4+2] + level1[i*4+3];
        end
    endgenerate

    // Level 3: Sum 4 level2 counters (4 groups)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*4] + level2[i*4+1] + level2[i*4+2] + level2[i*4+3];
        end
    endgenerate

    // Final addition as balanced binary tree
    wire [7:0] sum01, sum23;
    assign sum01 = level3[0] + level3[1];
    assign sum23 = level3[2] + level3[3];
    assign out = sum01 + sum23;

endmodule