module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: Count 1s in 3-bit chunks (85 chunks)
    wire [1:0] chunk_counts [0:84];
    
    // Count each 3-bit chunk
    assign chunk_counts[0] = in[0] + in[1] + in[2];
    assign chunk_counts[1] = in[3] + in[4] + in[5];
    assign chunk_counts[2] = in[6] + in[7] + in[8];
    // ... (pattern continues for all 85 chunks)
    assign chunk_counts[84] = in[252] + in[253] + in[254];

    // Second level: Sum 3 chunk counts (28 groups of 3, 1 group of 1)
    wire [3:0] group_counts [0:28];
    
    // Sum groups of 3 chunks
    assign group_counts[0] = chunk_counts[0] + chunk_counts[1] + chunk_counts[2];
    assign group_counts[1] = chunk_counts[3] + chunk_counts[4] + chunk_counts[5];
    // ... (pattern continues for 28 groups)
    assign group_counts[28] = {2'b0, chunk_counts[84]};  // Last single chunk

    // Third level: Sum 3 groups (9 groups of 3, 1 group of 2)
    wire [5:0] supergroup_counts [0:9];
    
    // Sum groups of 3
    assign supergroup_counts[0] = group_counts[0] + group_counts[1] + group_counts[2];
    assign supergroup_counts[1] = group_counts[3] + group_counts[4] + group_counts[5];
    // ... (pattern continues for 9 groups)
    assign supergroup_counts[9] = group_counts[27] + group_counts[28];  // Last 2 groups

    // Final level: Sum all supergroups (4 groups)
    assign out = supergroup_counts[0] + supergroup_counts[1] + 
                 supergroup_counts[2] + supergroup_counts[3] + 
                 supergroup_counts[4] + supergroup_counts[5] + 
                 supergroup_counts[6] + supergroup_counts[7] + 
                 supergroup_counts[8] + supergroup_counts[9];

endmodule