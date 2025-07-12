module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Sum bits in groups of 8 (32 groups)
    wire [3:0] level1 [0:31];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : LEVEL1
            localparam start = i*8;
            localparam end_bit = (start+7 > 254) ? 254 : start+7;
            localparam width = end_bit - start + 1;
            
            case (width)
                8: assign level1[i] = in[start] + in[start+1] + in[start+2] + in[start+3] +
                                     in[start+4] + in[start+5] + in[start+6] + in[start+7];
                7: assign level1[i] = in[start] + in[start+1] + in[start+2] + in[start+3] +
                                     in[start+4] + in[start+5] + in[start+6];
                6: assign level1[i] = in[start] + in[start+1] + in[start+2] + in[start+3] +
                                     in[start+4] + in[start+5];
                5: assign level1[i] = in[start] + in[start+1] + in[start+2] + in[start+3] +
                                     in[start+4];
                4: assign level1[i] = in[start] + in[start+1] + in[start+2] + in[start+3];
                3: assign level1[i] = in[start] + in[start+1] + in[start+2];
                2: assign level1[i] = in[start] + in[start+1];
                1: assign level1[i] = in[start];
            endcase
        end
    endgenerate

    // Level 2: Sum level1 results in groups of 4 (8 groups)
    wire [5:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL2
            localparam start = i*4;
            localparam end_group = (start+3 > 31) ? 31 : start+3;
            localparam width = end_group - start + 1;
            
            case (width)
                4: assign level2[i] = level1[start] + level1[start+1] + 
                                     level1[start+2] + level1[start+3];
                3: assign level2[i] = level1[start] + level1[start+1] + level1[start+2];
                2: assign level2[i] = level1[start] + level1[start+1];
                1: assign level2[i] = level1[start];
            endcase
        end
    endgenerate

    // Level 3: Sum level2 results in groups of 2 (4 groups)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            localparam start = i*2;
            localparam end_group = (start+1 > 7) ? 7 : start+1;
            localparam width = end_group - start + 1;
            
            case (width)
                2: assign level3[i] = level2[start] + level2[start+1];
                1: assign level3[i] = level2[start];
            endcase
        end
    endgenerate

    // Final sum in two stages for better timing
    wire [7:0] partial_sum1 = level3[0] + level3[1];
    wire [7:0] partial_sum2 = level3[2] + level3[3];

    // Final output
    assign out = partial_sum1 + partial_sum2;

endmodule