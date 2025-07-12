module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First level: Divide into 4 groups of 25 bits
    wire [3:0] group_and, group_or, group_xor;
    
    // Group 0: bits 24:0
    assign group_and[0] = &in[24:0];
    assign group_or[0]  = |in[24:0];
    assign group_xor[0] = ^in[24:0];
    
    // Group 1: bits 49:25
    assign group_and[1] = &in[49:25];
    assign group_or[1]  = |in[49:25];
    assign group_xor[1] = ^in[49:25];
    
    // Group 2: bits 74:50
    assign group_and[2] = &in[74:50];
    assign group_or[2]  = |in[74:50];
    assign group_xor[2] = ^in[74:50];
    
    // Group 3: bits 99:75
    assign group_and[3] = &in[99:75];
    assign group_or[3]  = |in[99:75];
    assign group_xor[3] = ^in[99:75];
    
    // Second level: Combine groups in pairs
    wire [1:0] stage2_and, stage2_or, stage2_xor;
    
    // Pair 0: groups 0 and 1
    assign stage2_and[0] = group_and[0] & group_and[1];
    assign stage2_or[0]  = group_or[0]  | group_or[1];
    assign stage2_xor[0] = group_xor[0] ^ group_xor[1];
    
    // Pair 1: groups 2 and 3
    assign stage2_and[1] = group_and[2] & group_and[3];
    assign stage2_or[1]  = group_or[2]  | group_or[3];
    assign stage2_xor[1] = group_xor[2] ^ group_xor[3];
    
    // Final level: Combine the pairs
    assign out_and = stage2_and[0] & stage2_and[1];
    assign out_or  = stage2_or[0]  | stage2_or[1];
    assign out_xor = stage2_xor[0] ^ stage2_xor[1];

endmodule