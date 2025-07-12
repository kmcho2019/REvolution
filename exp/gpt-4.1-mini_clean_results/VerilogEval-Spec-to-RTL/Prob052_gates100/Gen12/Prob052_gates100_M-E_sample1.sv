module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Parameters to define group size and number of groups
    localparam GROUP_SIZE = 10;
    localparam NUM_GROUPS = 100 / GROUP_SIZE; // 10 groups

    // Intermediate signals for group-level reductions
    wire [NUM_GROUPS-1:0] group_and;
    wire [NUM_GROUPS-1:0] group_or;
    wire [NUM_GROUPS-1:0] group_xor;

    genvar gi, li;

    // Generate group-level reductions: each group reduces 10 bits
    generate
        for (gi = 0; gi < NUM_GROUPS; gi = gi + 1) begin : group_reduction
            wire [GROUP_SIZE-1:0] chunk = in[gi*GROUP_SIZE +: GROUP_SIZE];

            // Perform reductions inside each chunk
            assign group_and[gi] = &chunk;
            assign group_or[gi]  = |chunk;
            assign group_xor[gi] = ^chunk;
        end
    endgenerate

    // Now reduce the 10 group signals to final outputs using balanced binary tree

    // Level 1: reduce 10 signals to 5 signals
    wire [4:0] level1_and;
    wire [4:0] level1_or;
    wire [4:0] level1_xor;
    generate
        for (gi = 0; gi < 5; gi = gi + 1) begin : level1_reduce
            assign level1_and[gi] = group_and[gi*2] & group_and[gi*2+1];
            assign level1_or[gi]  = group_or[gi*2]  | group_or[gi*2+1];
            assign level1_xor[gi] = group_xor[gi*2] ^ group_xor[gi*2+1];
        end
    endgenerate

    // Level 2: reduce 5 signals to 3 signals (handle odd number carefully)
    wire [2:0] level2_and;
    wire [2:0] level2_or;
    wire [2:0] level2_xor;

    assign level2_and[0] = level1_and[0] & level1_and[1];
    assign level2_or[0]  = level1_or[0]  | level1_or[1];
    assign level2_xor[0] = level1_xor[0] ^ level1_xor[1];

    assign level2_and[1] = level1_and[2] & level1_and[3];
    assign level2_or[1]  = level1_or[2]  | level1_or[3];
    assign level2_xor[1] = level1_xor[2] ^ level1_xor[3];

    // Pass through last element for odd group count
    assign level2_and[2] = level1_and[4];
    assign level2_or[2]  = level1_or[4];
    assign level2_xor[2] = level1_xor[4];

    // Level 3: reduce 3 signals to 2 signals
    wire [1:0] level3_and;
    wire [1:0] level3_or;
    wire [1:0] level3_xor;

    assign level3_and[0] = level2_and[0] & level2_and[1];
    assign level3_or[0]  = level2_or[0]  | level2_or[1];
    assign level3_xor[0] = level2_xor[0] ^ level2_xor[1];

    // Pass through last element
    assign level3_and[1] = level2_and[2];
    assign level3_or[1]  = level2_or[2];
    assign level3_xor[1] = level2_xor[2];

    // Level 4: final reduction (2 signals to 1)
    assign out_and = level3_and[0] & level3_and[1];
    assign out_or  = level3_or[0]  | level3_or[1];
    assign out_xor = level3_xor[0] ^ level3_xor[1];

endmodule