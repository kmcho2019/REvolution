module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count '1's in 4-bit chunks (64 chunks, last one padded)
    wire [2:0] chunk_counts [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : count_chunks
            if (i < 63) begin : normal_chunks
                assign chunk_counts[i] = 
                    in[i*4 + 0] + in[i*4 + 1] + 
                    in[i*4 + 2] + in[i*4 + 3];
            end
            else begin : last_chunk  // Last chunk has only 3 bits (255 = 63*4 + 3)
                assign chunk_counts[i] = 
                    in[i*4 + 0] + in[i*4 + 1] + 
                    in[i*4 + 2];
            end
        end
    endgenerate

    // Second level: Binary tree of adders (6 levels)
    // Level 1: 32 adders (64 inputs)
    wire [3:0] level1 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : level1_adders
            assign level1[i] = chunk_counts[i*2] + chunk_counts[i*2 + 1];
        end
    endgenerate

    // Level 2: 16 adders (32 inputs)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*2] + level1[i*2 + 1];
        end
    endgenerate

    // Level 3: 8 adders (16 inputs)
    wire [5:0] level3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*2] + level2[i*2 + 1];
        end
    endgenerate

    // Level 4: 4 adders (8 inputs)
    wire [6:0] level4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*2] + level3[i*2 + 1];
        end
    endgenerate

    // Level 5: 2 adders (4 inputs)
    wire [7:0] level5 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level5_adders
            assign level5[i] = level4[i*2] + level4[i*2 + 1];
        end
    endgenerate

    // Final adder (2 inputs)
    assign out = level5[0] + level5[1];

endmodule