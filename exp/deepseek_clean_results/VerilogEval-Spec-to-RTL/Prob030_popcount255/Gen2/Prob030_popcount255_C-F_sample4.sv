module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: count '1's in 8-bit chunks (31 chunks) + 7-bit chunk
    wire [3:0] partial_counts [0:31];  // Max 8 '1's per chunk -> needs 4 bits
    
    genvar i;
    generate
        // Count 8-bit chunks (0-30)
        for (i = 0; i < 31; i = i + 1) begin : count_8bit
            assign partial_counts[i] = 
                in[i*8 + 0] + in[i*8 + 1] + in[i*8 + 2] + in[i*8 + 3] +
                in[i*8 + 4] + in[i*8 + 5] + in[i*8 + 6] + in[i*8 + 7];
        end
        
        // Count remaining 7-bit chunk (31)
        assign partial_counts[31] = 
            in[248] + in[249] + in[250] + in[251] +
            in[252] + in[253] + in[254];
    endgenerate

    // Second level: binary tree of adders
    wire [7:0] level2 [0:15];  // 32 inputs -> 16 outputs
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            assign level2[i] = partial_counts[i*2] + partial_counts[i*2+1];
        end
    endgenerate

    // Third level: binary tree continues
    wire [7:0] level3 [0:7];  // 16 inputs -> 8 outputs
    generate
        for (i = 0; i < 8; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*2] + level2[i*2+1];
        end
    endgenerate

    // Fourth level: binary tree continues
    wire [7:0] level4 [0:3];  // 8 inputs -> 4 outputs
    generate
        for (i = 0; i < 4; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*2] + level3[i*2+1];
        end
    endgenerate

    // Fifth level: binary tree continues
    wire [7:0] level5 [0:1];  // 4 inputs -> 2 outputs
    generate
        assign level5[0] = level4[0] + level4[1];
        assign level5[1] = level4[2] + level4[3];
    endgenerate

    // Final addition
    assign out = level5[0] + level5[1];

endmodule