module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Pad input to 256 bits (32 chunks of 8 bits) by adding a zero MSB
    wire [255:0] padded_in = {1'b0, in};

    // First level: Count '1's in each 8-bit chunk
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

    // Second level: Binary tree summation
    wire [7:0] level1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_level1
            assign level1[i] = chunk_counts[i*2] + chunk_counts[i*2 + 1];
        end
    endgenerate

    // Third level: Binary tree summation
    wire [7:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_level2
            assign level2[i] = level1[i*2] + level1[i*2 + 1];
        end
    endgenerate

    // Fourth level: Binary tree summation
    wire [7:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_level3
            assign level3[i] = level2[i*2] + level2[i*2 + 1];
        end
    endgenerate

    // Fifth level: Binary tree summation
    wire [7:0] level4 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_level4
            assign level4[i] = level3[i*2] + level3[i*2 + 1];
        end
    endgenerate

    // Final sum
    assign out = level4[0] + level4[1];

endmodule