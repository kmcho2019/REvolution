module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // First level: sum bits in groups of 3 (85 groups of 3 bits each)
    // Because 85 * 3 = 255 exactly.
    // Each group of 3 bits sum can be represented with 2 bits (0 to 3).
    wire [1:0] sum_level1 [84:0];

    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : level1
            wire [2:0] bits = in[i*3 +: 3];
            // sum 3 bits = bits[0] + bits[1] + bits[2]
            assign sum_level1[i] = bits[0] + bits[1] + bits[2];
        end
    endgenerate

    // sum_level1 has 85 elements, each 2 bits wide
    // Next, sum these 85 2-bit numbers
    // We will use a tree reduction approach:
    // For simplicity, sum pairs of sums to form next level sums
    // sum_level2 will have ceil(85/2) = 43 elements,
    // each element wide enough to hold max sum of two 2-bit numbers: max 3+3=6 -> 3 bits needed

    localparam LEVEL2_SIZE = (85 + 1) / 2;
    wire [2:0] sum_level2 [LEVEL2_SIZE-1:0];

    generate
        for (i = 0; i < LEVEL2_SIZE; i = i + 1) begin : level2
            if (2*i+1 < 85) begin
                assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
            end else begin
                // odd element out, just pass through
                assign sum_level2[i] = sum_level1[2*i];
            end
        end
    endgenerate

    // Repeat the reduction until we get a single sum
    // Next level: sum_level3, size = ceil(LEVEL2_SIZE/2)
    localparam LEVEL3_SIZE = (LEVEL2_SIZE + 1) / 2;
    wire [3:0] sum_level3 [LEVEL3_SIZE-1:0]; // max sum at this level can be 6+6=12 (4 bits)

    generate
        for (i = 0; i < LEVEL3_SIZE; i = i + 1) begin : level3
            if (2*i+1 < LEVEL2_SIZE) begin
                assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
            end else begin
                assign sum_level3[i] = sum_level2[2*i];
            end
        end
    endgenerate

    // Next level: sum_level4, size = ceil(LEVEL3_SIZE/2)
    localparam LEVEL4_SIZE = (LEVEL3_SIZE + 1) / 2;
    wire [4:0] sum_level4 [LEVEL4_SIZE-1:0]; // max sum ~12+12=24 (5 bits)

    generate
        for (i = 0; i < LEVEL4_SIZE; i = i + 1) begin : level4
            if (2*i+1 < LEVEL3_SIZE) begin
                assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
            end else begin
                assign sum_level4[i] = sum_level3[2*i];
            end
        end
    endgenerate

    // Next level: sum_level5, size = ceil(LEVEL4_SIZE/2)
    localparam LEVEL5_SIZE = (LEVEL4_SIZE + 1) / 2;
    wire [5:0] sum_level5 [LEVEL5_SIZE-1:0]; // max sum ~24+24=48 (6 bits)

    generate
        for (i = 0; i < LEVEL5_SIZE; i = i + 1) begin : level5
            if (2*i+1 < LEVEL4_SIZE) begin
                assign sum_level5[i] = sum_level4[2*i] + sum_level4[2*i+1];
            end else begin
                assign sum_level5[i] = sum_level4[2*i];
            end
        end
    endgenerate

    // Next level: sum_level6, size = ceil(LEVEL5_SIZE/2)
    localparam LEVEL6_SIZE = (LEVEL5_SIZE + 1) / 2;
    wire [6:0] sum_level6 [LEVEL6_SIZE-1:0]; // max sum ~48+48=96 (7 bits)

    generate
        for (i = 0; i < LEVEL6_SIZE; i = i + 1) begin : level6
            if (2*i+1 < LEVEL5_SIZE) begin
                assign sum_level6[i] = sum_level5[2*i] + sum_level5[2*i+1];
            end else begin
                assign sum_level6[i] = sum_level5[2*i];
            end
        end
    endgenerate

    // Next level: sum_level7, size = ceil(LEVEL6_SIZE/2)
    localparam LEVEL7_SIZE = (LEVEL6_SIZE + 1) / 2;
    wire [7:0] sum_level7 [LEVEL7_SIZE-1:0]; // max sum ~96+96=192 (8 bits)

    generate
        for (i = 0; i < LEVEL7_SIZE; i = i + 1) begin : level7
            if (2*i+1 < LEVEL6_SIZE) begin
                assign sum_level7[i] = sum_level6[2*i] + sum_level6[2*i+1];
            end else begin
                assign sum_level7[i] = sum_level6[2*i];
            end
        end
    endgenerate

    // Next level: sum_level8, size = ceil(LEVEL7_SIZE/2)
    // Should get down to a single sum now
    localparam LEVEL8_SIZE = (LEVEL7_SIZE + 1) / 2;
    wire [7:0] sum_level8 [LEVEL8_SIZE-1:0];

    generate
        for (i = 0; i < LEVEL8_SIZE; i = i + 1) begin : level8
            if (2*i+1 < LEVEL7_SIZE) begin
                assign sum_level8[i] = sum_level7[2*i] + sum_level7[2*i+1];
            end else begin
                assign sum_level8[i] = sum_level7[2*i];
            end
        end
    endgenerate

    // Now LEVEL8_SIZE should be 1 (or 2 but input size 255 means it should be 1)
    // Assign output:
    assign out = sum_level8[0];

endmodule