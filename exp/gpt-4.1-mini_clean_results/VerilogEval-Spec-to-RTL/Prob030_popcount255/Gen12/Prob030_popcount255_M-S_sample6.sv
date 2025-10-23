module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Balanced popcount tree:
    // Step 1: bits grouped into pairs, sum into 1-bit partial sums
    // Step 2-n: iteratively sum adjacent partial sums, increasing bit width by 1 each level,
    // until a single sum remains representing the total number of '1's in 255 bits.
    // Number of levels needed: ceil(log2(255)) = 8; final output width 8 bits covers max 255.

    // Level 0: individual bits as 1-bit sums
    wire [0:254] level0 = in;

    // Maximum levels needed to reduce 255 inputs to 1 output:
    localparam LEVELS = 8;

    // Declare arrays for intermediate sums. 
    // Each level reduces input width roughly by half,
    // each sum width increases by 1 bit per level.

    // Use generate loops and arrays of wires for each level.
    // At each level, sum pairs from previous level.

    // Declare arrays for sums per level:
    // Level i: ( (num_inputs + 1) >> 1 ) sums of width (i+1) bits
    // Number of sums at level 0 = 255
    // Number of sums at level 1 = (255+1)/2=128, width=2
    // Level 2: (128+1)/2=64 sums, width=3
    // ...
    // Level 7: 2 sums, width=8
    // Level 8: 1 sum, width=9 (but output max 8 bits since max sum 255 < 2^8=256, 8 bits suffice)

    // We'll build levels 1 through 8, final level produces single sum assigned to 'out'.

    // Generate levels dynamically:
    genvar lvl, i;

    // Define wires for each level:
    // Use two-dimensional packed arrays of wires via generate-block-scope.

    // Level 0 (bits): 255 sums of 1-bit (already 'level0')

    // Define arrays for levels 1 to LEVELS (1 to 8)
    // Use intermediate wire arrays with fixed sizes.

    // Maximum array size needed is level 1: 128 elements
    // For simplicity, define arrays large enough and only use needed indices.

    // Using two-dimensional arrays not fully supported in older Verilog,
    // so use generate blocks with local arrays per level.

    // We'll define wires with simple naming conventions.

    // Level 1 wires: 128 sums of 2 bits
    wire [1:0] level1 [0:127];
    // Level 2 wires: 64 sums of 3 bits
    wire [2:0] level2 [0:63];
    // Level 3 wires: 32 sums of 4 bits
    wire [3:0] level3 [0:31];
    // Level 4 wires: 16 sums of 5 bits
    wire [4:0] level4 [0:15];
    // Level 5 wires: 8 sums of 6 bits
    wire [5:0] level5 [0:7];
    // Level 6 wires: 4 sums of 7 bits
    wire [6:0] level6 [0:3];
    // Level 7 wires: 2 sums of 8 bits
    wire [7:0] level7 [0:1];
    // Level 8 wires: 1 sum of 8 bits (final sum fits in 8 bits)
    wire [7:0] level8;

    // Level 1: sum pairs of level0 bits (1-bit each)
    generate
        for (i = 0; i < 127; i = i + 1) begin : gen_level1_pairs
            assign level1[i] = level0[2*i] + level0[2*i+1];
        end
        // Handle last bit alone since 255 is odd
        assign level1[127] = level0[254];
    endgenerate

    // Level 2: sum pairs of level1 (2-bit) sums
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_level2_pairs
            if (2*i+1 < 128) begin
                assign level2[i] = level1[2*i] + level1[2*i+1];
            end else begin
                assign level2[i] = level1[2*i];
            end
        end
    endgenerate

    // Level 3: sum pairs of level2 (3-bit) sums
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_level3_pairs
            if (2*i+1 < 64) begin
                assign level3[i] = level2[2*i] + level2[2*i+1];
            end else begin
                assign level3[i] = level2[2*i];
            end
        end
    endgenerate

    // Level 4: sum pairs of level3 (4-bit) sums
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level4_pairs
            if (2*i+1 < 32) begin
                assign level4[i] = level3[2*i] + level3[2*i+1];
            end else begin
                assign level4[i] = level3[2*i];
            end
        end
    endgenerate

    // Level 5: sum pairs of level4 (5-bit) sums
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_level5_pairs
            if (2*i+1 < 16) begin
                assign level5[i] = level4[2*i] + level4[2*i+1];
            end else begin
                assign level5[i] = level4[2*i];
            end
        end
    endgenerate

    // Level 6: sum pairs of level5 (6-bit) sums
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level6_pairs
            if (2*i+1 < 8) begin
                assign level6[i] = level5[2*i] + level5[2*i+1];
            end else begin
                assign level6[i] = level5[2*i];
            end
        end
    endgenerate

    // Level 7: sum pairs of level6 (7-bit) sums
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_level7_pairs
            if (2*i+1 < 4) begin
                assign level7[i] = level6[2*i] + level6[2*i+1];
            end else begin
                assign level7[i] = level6[2*i];
            end
        end
    endgenerate

    // Level 8: final sum of level7 (8-bit) sums into 8-bit output
    assign level8 = level7[0] + level7[1];

    assign out = level8;

endmodule