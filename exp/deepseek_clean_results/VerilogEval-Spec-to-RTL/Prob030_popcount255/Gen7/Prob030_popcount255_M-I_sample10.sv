module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Pad input to 256 bits (next power of 2) for balanced tree
    wire [255:0] padded_in = {1'b0, in};

    // Level 1: Count '1's in 3-bit chunks (85 chunks + 1 extra)
    wire [1:0] level1 [0:85];  // 2 bits per counter (max 3)
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1_counters
            assign level1[i] = padded_in[i*3] + padded_in[i*3+1] + padded_in[i*3+2];
        end
        // Handle last partial chunk (just 1 bit)
        assign level1[85] = {1'b0, padded_in[255]};
    endgenerate

    // Level 2: Sum 3 level1 counters (29 groups)
    wire [3:0] level2 [0:28];  // 4 bits needed (max 9)
    generate
        for (i = 0; i < 28; i = i + 1) begin : level2_adders
            assign level2[i] = level1[i*3] + level1[i*3+1] + level1[i*3+2];
        end
        // Last group has 2 counters
        assign level2[28] = level1[84] + level1[85];
    endgenerate

    // Level 3: Sum 3 level2 counters (10 groups)
    wire [5:0] level3 [0:9];  // 6 bits needed (max 27)
    generate
        for (i = 0; i < 9; i = i + 1) begin : level3_adders
            assign level3[i] = level2[i*3] + level2[i*3+1] + level2[i*3+2];
        end
        // Last group has 1 counter
        assign level3[9] = level2[27] + level2[28];
    endgenerate

    // Level 4: Sum 3 level3 counters (4 groups)
    wire [7:0] level4 [0:3];  // 8 bits needed (max 256)
    generate
        for (i = 0; i < 3; i = i + 1) begin : level4_adders
            assign level4[i] = level3[i*3] + level3[i*3+1] + level3[i*3+2];
        end
        // Last group has 1 counter
        assign level4[3] = level3[9];
    endgenerate

    // Final balanced binary tree addition
    wire [7:0] sum01, sum23;
    assign sum01 = level4[0] + level4[1];
    assign sum23 = level4[2] + level4[3];
    assign out = sum01 + sum23;

endmodule