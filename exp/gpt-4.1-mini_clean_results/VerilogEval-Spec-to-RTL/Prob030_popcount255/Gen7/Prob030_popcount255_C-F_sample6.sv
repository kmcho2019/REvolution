module popcount5 (
    input  [4:0] in,
    output [2:0] out // max 5 ones, needs 3 bits
);
    // Sum lower 4 bits
    wire [2:0] sum4 = in[0] + in[1] + in[2] + in[3]; // max 4, 3 bits
    // Add bit 4
    assign out = sum4 + in[4];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Constants
    localparam N_GROUPS = 51; // 255/5=51 groups of 5 bits

    // Stage 1: Instantiate 51 popcount5 units
    wire [2:0] pc5 [0:N_GROUPS-1];
    genvar i;
    generate
        for (i = 0; i < N_GROUPS; i = i + 1) begin : gen_pop5
            popcount5 pc5_inst (
                .in(in[i*5 +: 5]),
                .out(pc5[i])
            );
        end
    endgenerate

    // Stage 2 and up: Explicit balanced binary addition tree summing 51 3-bit values
    // Since 51 inputs, pad to next power of two: 64 inputs
    // Pad unused inputs with zero

    // First, widen pc5 counts to 8 bits for easy summation
    wire [7:0] level0 [0:63];
    generate
        for (i = 0; i < N_GROUPS; i = i + 1) begin : level0_assign
            assign level0[i] = {5'b0, pc5[i]}; // zero-extend to 8 bits
        end
        for (i = N_GROUPS; i < 64; i = i + 1) begin : level0_pad
            assign level0[i] = 8'd0;
        end
    endgenerate

    // Level 1: sum pairs from level0 => 32 sums, each 9 bits max (2*7 max =14 < 9 bits)
    wire [8:0] level1 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : level1_add
            assign level1[i] = level0[2*i] + level0[2*i + 1];
        end
    endgenerate

    // Level 2: sum pairs from level1 => 16 sums
    // Max sum per input level1: 14, so max sum level2: 28 < 9 bits, but for safety use 10 bits
    wire [9:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_add
            assign level2[i] = level1[2*i] + level1[2*i + 1];
        end
    endgenerate

    // Level 3: sum pairs from level2 => 8 sums
    // Max sum level2: 28, sum level3 max: 56 < 10 bits, but use 11 bits for safety
    wire [10:0] level3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : level3_add
            assign level3[i] = level2[2*i] + level2[2*i + 1];
        end
    endgenerate

    // Level 4: sum pairs from level3 => 4 sums
    // Max level3: 56, level4 max: 112 < 11 bits, use 12 bits
    wire [11:0] level4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level4_add
            assign level4[i] = level3[2*i] + level3[2*i + 1];
        end
    endgenerate

    // Level 5: sum pairs from level4 => 2 sums
    // Max level4: 112, level5 max: 224 < 12 bits, use 12 bits
    wire [11:0] level5 [0:1];
    assign level5[0] = level4[0] + level4[1];
    assign level5[1] = level4[2] + level4[3];

    // Level 6: final sum
    // Max level5: 224, sum final max: 448 < 9 bits would be too small, so use 12 bits again
    wire [11:0] level6;
    assign level6 = level5[0] + level5[1];

    // Assign final output (only 8 bits needed since max popcount is 255)
    assign out = level6[7:0];

endmodule