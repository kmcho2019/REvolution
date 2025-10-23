module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: count 1s in each 8-bit chunk (31 chunks) and one 7-bit chunk
    wire [7:0] level0 [0:31];
    
    genvar i;
    generate
        // Process 31 full 8-bit chunks
        for (i = 0; i < 31; i = i + 1) begin : count_8bit
            assign level0[i] = 
                in[i*8 + 0] + in[i*8 + 1] + in[i*8 + 2] + in[i*8 + 3] +
                in[i*8 + 4] + in[i*8 + 5] + in[i*8 + 6] + in[i*8 + 7];
        end
        
        // Process remaining 7-bit chunk
        assign level0[31] = 
            in[248] + in[249] + in[250] + in[251] +
            in[252] + in[253] + in[254];
    endgenerate

    // Second level: sum pairs from first level (16 sums)
    wire [7:0] level1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1_adders
            assign level1[i] = level0[i*2] + level0[i*2 + 1];
        end
    endgenerate

    // Third level: sum pairs from second level (8 sums)
    wire [7:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*2] + level1[i*2 + 1];
        end
    endgenerate

    // Fourth level: sum pairs from third level (4 sums)
    wire [7:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*2] + level2[i*2 + 1];
        end
    endgenerate

    // Fifth level: sum pairs from fourth level (2 sums)
    wire [7:0] level4 [0:1];
    assign level4[0] = level3[0] + level3[1];
    assign level4[1] = level3[2] + level3[3];

    // Final sum
    assign out = level4[0] + level4[1];

endmodule