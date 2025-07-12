module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Level 1: Count '1's in 3-bit chunks (85 chunks)
    wire [1:0] level1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1_counters
            assign level1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
        end
    endgenerate

    // Level 2: Sum 3 level1 counters (29 groups, pad last with zeros)
    wire [3:0] level2 [0:28];
    generate
        for (i = 0; i < 28; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        // Pad last group with zeros to maintain balanced tree
        assign level2[28] = level1[84] + 2'b00;
    endgenerate

    // Level 3: Sum 3 level2 counters (10 groups, pad last with zeros)
    wire [5:0] level3 [0:9];
    generate
        for (i = 0; i < 9; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        // Pad last group with zeros
        assign level3[9] = level2[27] + level2[28] + 4'b0000;
    endgenerate

    // Level 4: Sum 3 level3 counters (4 groups, pad last with zeros)
    wire [7:0] level4 [0:3];
    generate
        for (i = 0; i < 3; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*3] + level3[i*3+1] + level3[i*3+2];
        end
        // Pad last group with zeros
        assign level4[3] = level3[9] + 6'b000000;
    endgenerate

    // Final addition - optimized single stage
    assign out = level4[0] + level4[1] + level4[2] + level4[3];

endmodule