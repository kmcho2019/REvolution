module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Pad input to 256 bits for uniform 8-bit chunks
    wire [255:0] padded_in = {in, 1'b0};

    // First level: Count 1s in 32x 8-bit chunks
    wire [3:0] level1 [0:31];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : count_8bit
            assign level1[i] = 
                padded_in[i*8 + 0] + padded_in[i*8 + 1] + 
                padded_in[i*8 + 2] + padded_in[i*8 + 3] + 
                padded_in[i*8 + 4] + padded_in[i*8 + 5] + 
                padded_in[i*8 + 6] + padded_in[i*8 + 7];
        end
    endgenerate

    // Second level: 8 groups of 4 counts
    wire [5:0] level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : combine_4x4bit
            assign level2[i] = level1[i*4] + level1[i*4+1] + 
                              level1[i*4+2] + level1[i*4+3];
        end
    endgenerate

    // Third level: 2 groups of 4 counts
    wire [7:0] level3 [0:1];
    assign level3[0] = level2[0] + level2[1] + level2[2] + level2[3];
    assign level3[1] = level2[4] + level2[5] + level2[6] + level2[7];

    // Final accumulation
    assign out = level3[0] + level3[1];

endmodule