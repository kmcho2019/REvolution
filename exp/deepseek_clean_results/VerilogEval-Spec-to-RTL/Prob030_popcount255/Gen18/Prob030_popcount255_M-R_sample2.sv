module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Parameters for hierarchical counting
    localparam GROUP_SIZE = 5;      // Count 1s in 5-bit groups
    localparam NUM_GROUPS = 51;     // 255 bits / 5 bits per group
    localparam COUNT_WIDTH = 3;     // Needs 3 bits to count up to 5 (max count per group)

    // First level: Count 1s in each 5-bit group
    wire [COUNT_WIDTH-1:0] group_counts [0:NUM_GROUPS-1];
    
    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : COUNT_5BITS
            localparam start = i*GROUP_SIZE;
            wire [GROUP_SIZE-1:0] group = (start+GROUP_SIZE-1 <= 254) ? 
                                         in[start +: GROUP_SIZE] : 
                                         {in[start:254], {(start+GROUP_SIZE-1-254){1'b0}}};
            
            // Count 1s in this 5-bit group
            assign group_counts[i] = 
                group[0] + group[1] + group[2] + group[3] + group[4];
        end
    endgenerate

    // Second level: Binary tree summation of partial counts
    // Implemented as a parameterized adder tree
    localparam TREE_LEVELS = $clog2(NUM_GROUPS);
    wire [7:0] sum_tree [0:TREE_LEVELS][0:NUM_GROUPS-1];
    
    // Initialize leaves with zero-extended group counts
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : INIT_TREE
            assign sum_tree[0][i] = {5'b0, group_counts[i]};
        end
    endgenerate

    // Build adder tree
    genvar level, pos;
    generate
        for (level = 1; level <= TREE_LEVELS; level = level + 1) begin : TREE_LEVEL
            for (pos = 0; pos < (NUM_GROUPS >> level); pos = pos + 1) begin : TREE_POS
                assign sum_tree[level][pos] = sum_tree[level-1][2*pos] + 
                                            sum_tree[level-1][2*pos+1];
            end
            // Handle odd number of elements at each level
            if (NUM_GROUPS >> (level-1) % 2) begin : ODD_ELEMENTS
                assign sum_tree[level][(NUM_GROUPS >> level)] = 
                    sum_tree[level-1][(NUM_GROUPS >> (level-1))-1];
            end
        end
    endgenerate

    // Final output is the root of the tree
    assign out = sum_tree[TREE_LEVELS][0];

endmodule