module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Calculate number of reduction levels needed for 100 inputs
    // ceil(log2(100)) = 7
    localparam LEVELS = 7;

    // For each level, store partial results for AND, OR, XOR
    // Max nodes at first level = 100
    // Next levels: ceil(nodes_prev / 2)
    // Use arrays of maximum size 100 for simplicity; unused entries tied to logic 1/0 as appropriate

    wire [99:0] and_level [0:LEVELS];
    wire [99:0] or_level  [0:LEVELS];
    wire [99:0] xor_level [0:LEVELS];

    genvar level, idx;

    // Initialize level 0 inputs directly from in vector
    generate
        for (idx = 0; idx < 100; idx = idx + 1) begin : init_level0
            assign and_level[0][idx] = in[idx];
            assign or_level[0][idx]  = in[idx];
            assign xor_level[0][idx] = in[idx];
        end
        // For unused indices in level 0 (idx 100 to 99), tie to identity values:
        // For AND: identity 1, for OR: identity 0, for XOR: identity 0
        for (idx = 100; idx < 100; idx = idx + 1) begin : tie_unused_level0
            assign and_level[0][idx] = 1'b1;
            assign or_level[0][idx]  = 1'b0;
            assign xor_level[0][idx] = 1'b0;
        end
    endgenerate

    // Recursive reduction: at each level, combine pairs from previous level
    // If number of inputs at a level is n, next level has ceil(n/2)
    // For odd n, last element is combined with identity element (1 for AND, 0 for OR/XOR)
    generate
        for (level = 1; level <= LEVELS; level = level + 1) begin : reduce_levels
            // Number of nodes at previous level
            // Calculate nodes as ceil(prev_nodes / 2)
            // prev_nodes = nodes at level-1 = N(level-1)
            // We compute N(level-1) as follows:
            // For level 0: 100
            // For level l>0: ceil(N(l-1)/2)
            localparam integer prev_nodes = (level == 1) ? 100 :
                (( ( ( (level-1)==1) ? 100 : 0 ) + 1 ) / 2); // We'll fix this below dynamically in code.

            // To handle varying input count per level, precompute nodes dynamically in constant function
        end
    endgenerate

    // Because Verilog generate cannot have variable ranges or dynamic parameters inside generate loops,
    // let's precompute node counts per level as constants:
    localparam integer nodes_level0 = 100;
    localparam integer nodes_level1 = (nodes_level0 + 1) / 2; // 50 + 1 = 50
    localparam integer nodes_level2 = (nodes_level1 + 1) / 2; // 25 + 1 = 25
    localparam integer nodes_level3 = (nodes_level2 + 1) / 2; // 13
    localparam integer nodes_level4 = (nodes_level3 + 1) / 2; // 7
    localparam integer nodes_level5 = (nodes_level4 + 1) / 2; // 4
    localparam integer nodes_level6 = (nodes_level5 + 1) / 2; // 2
    localparam integer nodes_level7 = (nodes_level6 + 1) / 2; // 1

    // To simplify, we define arrays indexed by level for nodes count:
    localparam integer nodes_per_level[0:LEVELS] = {
        nodes_level0,
        nodes_level1,
        nodes_level2,
        nodes_level3,
        nodes_level4,
        nodes_level5,
        nodes_level6,
        nodes_level7
    };

    // Now implement generate loops for each level combining pairs from previous level
    generate
        for (level = 1; level <= LEVELS; level = level + 1) begin : level_loop
            for (idx = 0; idx < nodes_per_level[level]; idx = idx + 1) begin : idx_loop
                // Calculate indices of two inputs from previous level
                localparam integer i0 = idx * 2;
                localparam integer i1 = idx * 2 + 1;

                // AND reduction with identity = 1 when no second input
                assign and_level[level][idx] = (i1 < nodes_per_level[level-1]) ?
                    (and_level[level-1][i0] & and_level[level-1][i1]) :
                    and_level[level-1][i0];

                // OR reduction with identity = 0 when no second input
                assign or_level[level][idx] = (i1 < nodes_per_level[level-1]) ?
                    (or_level[level-1][i0] | or_level[level-1][i1]) :
                    or_level[level-1][i0];

                // XOR reduction with identity = 0 when no second input
                assign xor_level[level][idx] = (i1 < nodes_per_level[level-1]) ?
                    (xor_level[level-1][i0] ^ xor_level[level-1][i1]) :
                    xor_level[level-1][i0];
            end
        end
    endgenerate

    // Assign outputs as the single remaining element in the last level arrays
    assign out_and = and_level[LEVELS][0];
    assign out_or  = or_level[LEVELS][0];
    assign out_xor = xor_level[LEVELS][0];

endmodule