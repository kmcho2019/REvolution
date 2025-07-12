module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Parameters for flexible sizing
    localparam GROUP_SIZE = 8;
    localparam NUM_GROUPS = 32;
    localparam LAST_GROUP_SIZE = 7;
    
    // Stage 1: Count bits in each group
    wire [3:0] group_counts [0:NUM_GROUPS-1]; // 4 bits needed (max 8)
    
    genvar i;
    generate
        // Count for complete 8-bit groups
        for (i = 0; i < NUM_GROUPS-1; i = i + 1) begin : COUNT_GROUPS
            assign group_counts[i] = 
                in[i*GROUP_SIZE+0] + in[i*GROUP_SIZE+1] + 
                in[i*GROUP_SIZE+2] + in[i*GROUP_SIZE+3] + 
                in[i*GROUP_SIZE+4] + in[i*GROUP_SIZE+5] + 
                in[i*GROUP_SIZE+6] + in[i*GROUP_SIZE+7];
        end
        // Count for last partial group (7 bits)
        assign group_counts[NUM_GROUPS-1] = 
            in[254] + in[253] + in[252] + in[251] + 
            in[250] + in[249] + in[248];
    endgenerate

    // Stage 2: Balanced adder tree to sum partial counts
    // Level 1: Sum pairs (16 sums)
    wire [4:0] level1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1
            assign level1[i] = group_counts[2*i] + group_counts[2*i+1];
        end
    endgenerate
    
    // Level 2: Sum pairs (8 sums)
    wire [5:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL2
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
    endgenerate
    
    // Level 3: Sum pairs (4 sums)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            assign level3[i] = level2[2*i] + level2[2*i+1];
        end
    endgenerate
    
    // Level 4: Sum pairs (2 sums)
    wire [7:0] level4 [0:1];
    assign level4[0] = level3[0] + level3[1];
    assign level4[1] = level3[2] + level3[3];
    
    // Final sum
    assign out = level4[0] + level4[1];

endmodule