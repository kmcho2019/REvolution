module popcount17 (
    input  [16:0] in,
    output [4:0] out
);
    // Count bits in 17-bit input
    // Sum bits using parallel adders
    wire [4:0] bit_counts [16:0];
    genvar i;
    generate
        for (i = 0; i < 17; i = i +1) begin : BIT_TO_CNT
            assign bit_counts[i] = in[i] ? 5'd1 : 5'd0;
        end
    endgenerate

    // Sum bits stepwise
    // Sum adjacent pairs repeatedly to reduce additions

    // Stage 1: sum pairs (will produce up to 5 bits)
    wire [5:0] sum_level1 [7:0];
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_L1
            assign sum_level1[i] = bit_counts[2*i] + bit_counts[2*i+1];
        end
    endgenerate
    // Note: 17 bits means one leftover bit (index 16)
    wire [4:0] leftover = bit_counts[16];

    // Stage 2: sum pairs of sum_level1
    wire [6:0] sum_level2 [3:0];
    generate
        for (i = 0; i < 4; i = i +1) begin : SUM_L2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Stage 3: sum pairs of sum_level2
    wire [7:0] sum_level3 [1:0];
    generate
        for (i = 0; i < 2; i = i +1) begin : SUM_L3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Stage 4: sum the last two sums + leftover
    wire [8:0] sum_level4;
    assign sum_level4 = sum_level3[0] + sum_level3[1] + leftover;

    // Output is sum_level4 lower 5 bits (max 17 ones is max 17, fits in 5 bits)
    assign out = sum_level4[4:0];
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split into 15 chunks of 17 bits (15*17=255)
    wire [4:0] chunk_counts [14:0];
    genvar idx;
    generate
        for (idx=0; idx < 15; idx = idx + 1) begin : CHUNKS
            popcount17 u_popcount17 (
                .in(in[idx*17 +: 17]),
                .out(chunk_counts[idx])
            );
        end
    endgenerate

    // Sum the 15 partial counts in a balanced tree
    // Level 1: sum pairs -> 7 sums + 1 leftover
    wire [6:0] level1 [6:0];
    genvar i;
    generate
        for (i=0; i<7; i=i+1) begin : SUM_LEVEL1
            assign level1[i] = chunk_counts[2*i] + chunk_counts[2*i+1];
        end
    endgenerate
    wire [4:0] leftover1 = chunk_counts[14];

    // Level 2: sum pairs of level1 -> 3 sums + 1 leftover
    wire [7:0] level2 [2:0];
    generate
        for (i=0; i<3; i=i+1) begin : SUM_LEVEL2
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
    endgenerate
    wire [6:0] leftover2 = level1[6];

    // Level 3: sum pairs of level2 -> 1 sum + 1 leftover
    wire [8:0] level3 [0:1];
    assign level3[0] = level2[0] + level2[1];
    assign level3[1] = level2[2] + leftover2;

    // Level 4: final sum all
    wire [9:0] final_sum;
    assign final_sum = level3[0] + level3[1] + leftover1;

    // Output is 8 bits (max 255 ones, fits in 8 bits)
    assign out = final_sum[7:0];
endmodule