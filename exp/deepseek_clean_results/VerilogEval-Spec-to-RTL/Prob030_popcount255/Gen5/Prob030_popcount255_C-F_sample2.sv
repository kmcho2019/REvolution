module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Pad input to 256 bits (simplifies tree structure)
    wire [255:0] padded_in = {1'b0, in};

    // Level 1: Count '1's in 4-bit chunks (64 chunks)
    wire [2:0] level1 [0:63];  // 3 bits needed (max 4)
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : level1_counters
            assign level1[i] = padded_in[i*4] + padded_in[i*4+1] + 
                              padded_in[i*4+2] + padded_in[i*4+3];
        end
    endgenerate

    // Level 2: Sum 3 level1 counters (21 groups of 3, 1 group of 1)
    wire [4:0] level2 [0:21];  // 5 bits needed (max 12)
    generate
        for (i = 0; i < 21; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        assign level2[21] = {2'b0, level1[63]};  // Zero extend last counter
    endgenerate

    // Level 3: Sum 3 level2 counters (7 groups of 3, 1 group of 1)
    wire [6:0] level3 [0:7];  // 7 bits needed (max 36)
    generate
        for (i = 0; i < 7; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        assign level3[7] = {2'b0, level2[21]};  // Zero extend last counter
    endgenerate

    // Level 4: Sum 3 level3 counters (2 groups of 3, 1 group of 2)
    wire [7:0] level4 [0:2];  // 8 bits needed (max 108)
    generate
        for (i = 0; i < 2; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*3] + level3[i*3+1] + level3[i*3+2];
        end
        assign level4[2] = level3[6] + level3[7];
    endgenerate

    // Final level: Carry-save addition then final sum
    wire [7:0] sum_ab, sum_cd;
    assign sum_ab = level4[0] + level4[1];
    assign sum_cd = level4[2];
    assign out = sum_ab + sum_cd;

endmodule