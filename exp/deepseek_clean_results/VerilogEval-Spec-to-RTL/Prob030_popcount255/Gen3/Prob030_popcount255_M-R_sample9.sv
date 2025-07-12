module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Pad input to 256 bits (255 original + 1 zero)
    wire [255:0] padded_in = {1'b0, in};

    // First level: Count '1's in each 8-bit chunk (32 chunks)
    wire [7:0] chunk_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : count_chunks
            assign chunk_counts[i] = 
                padded_in[i*8 + 0] + padded_in[i*8 + 1] + 
                padded_in[i*8 + 2] + padded_in[i*8 + 3] + 
                padded_in[i*8 + 4] + padded_in[i*8 + 5] + 
                padded_in[i*8 + 6] + padded_in[i*8 + 7];
        end
    endgenerate

    // Second level: Balanced binary adder tree
    wire [7:0] level1 [0:15];
    wire [7:0] level2 [0:7];
    wire [7:0] level3 [0:3];
    wire [7:0] level4 [0:1];
    wire [7:0] level5;

    // Level 1: Sum pairs of chunk counts (32 -> 16)
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_level1
            assign level1[i] = chunk_counts[2*i] + chunk_counts[2*i + 1];
        end
    endgenerate

    // Level 2: Sum pairs (16 -> 8)
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_level2
            assign level2[i] = level1[2*i] + level1[2*i + 1];
        end
    endgenerate

    // Level 3: Sum pairs (8 -> 4)
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_level3
            assign level3[i] = level2[2*i] + level2[2*i + 1];
        end
    endgenerate

    // Level 4: Sum pairs (4 -> 2)
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_level4
            assign level4[i] = level3[2*i] + level3[2*i + 1];
        end
    endgenerate

    // Level 5: Final sum (2 -> 1)
    assign level5 = level4[0] + level4[1];

    assign out = level5;

endmodule