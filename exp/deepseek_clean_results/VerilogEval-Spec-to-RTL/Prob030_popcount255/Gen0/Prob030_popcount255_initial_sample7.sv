module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // First level: sum all bits in groups of 1 (just the bits themselves)
    // Second level: sum pairs of bits (results in 128 sums of 0-2)
    wire [127:0] level1;
    genvar i;
    generate
        for (i = 0; i < 128; i = i + 1) begin : level1_gen
            assign level1[i] = in[2*i] + in[2*i+1];
        end
        // Handle the last odd bit
        wire last_bit = in[254];
    endgenerate

    // Third level: sum pairs of level1 results (64 sums of 0-4)
    wire [63:0] level2;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level2_gen
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
    endgenerate

    // Fourth level: sum pairs of level2 results (32 sums of 0-8)
    wire [31:0] level3;
    generate
        for (i = 0; i < 32; i = i + 1) begin : level3_gen
            assign level3[i] = level2[2*i] + level2[2*i+1];
        end
    endgenerate

    // Fifth level: sum pairs of level3 results (16 sums of 0-16)
    wire [15:0] level4;
    generate
        for (i = 0; i < 16; i = i + 1) begin : level4_gen
            assign level4[i] = level3[2*i] + level3[2*i+1];
        end
    endgenerate

    // Sixth level: sum pairs of level4 results (8 sums of 0-32)
    wire [7:0] level5;
    generate
        for (i = 0; i < 8; i = i + 1) begin : level5_gen
            assign level5[i] = level4[2*i] + level4[2*i+1];
        end
    endgenerate

    // Seventh level: sum pairs of level5 results (4 sums of 0-64)
    wire [3:0] level6;
    generate
        for (i = 0; i < 4; i = i + 1) begin : level6_gen
            assign level6[i] = level5[2*i] + level5[2*i+1];
        end
    endgenerate

    // Eighth level: sum pairs of level6 results (2 sums of 0-128)
    wire [1:0] level7;
    generate
        for (i = 0; i < 2; i = i + 1) begin : level7_gen
            assign level7[i] = level6[2*i] + level6[2*i+1];
        end
    endgenerate

    // Final sum and add the last bit
    assign out = level7[0] + level7[1] + last_bit;

endmodule