module popcount17 (
    input  [16:0] in,
    output [4:0] out // max 17 ones => 5 bits
);
    // Sum all bits in in[16:0] using a tree of adders
    // Level 1: sum pairs -> 8 sums of 2 bits + 1 leftover bit
    wire [1:0] sum0 [0:7];
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : sum_pairs
            assign sum0[i] = in[2*i] + in[2*i+1];
        end
    endgenerate
    // sum the leftover bit in in[16]
    wire leftover_bit = in[16];

    // Level 2: sum sum0 in pairs (4 sums)
    wire [2:0] sum1 [0:3];
    generate
        for(i=0; i<4; i=i+1) begin : sum_pairs_level2
            assign sum1[i] = sum0[2*i] + sum0[2*i+1];
        end
    endgenerate

    // Level 3: sum sum1 in pairs (2 sums)
    wire [3:0] sum2 [0:1];
    generate
        for(i=0; i<2; i=i+1) begin : sum_pairs_level3
            assign sum2[i] = sum1[2*i] + sum1[2*i+1];
        end
    endgenerate

    // Level 4: sum the two sums + leftover bit
    wire [4:0] sum3 = sum2[0] + sum2[1] + leftover_bit;

    assign out = sum3;
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    localparam CHUNKS = 15;
    localparam CHUNK_WIDTH = 17;

    // Partial popcounts: 5 bits each
    wire [4:0] partial_counts [0:CHUNKS-1];

    genvar i;
    generate
        for (i=0; i<CHUNKS; i=i+1) begin : gen_pop17_chunks
            popcount17 pc17(
                .in(in[i*CHUNK_WIDTH +: CHUNK_WIDTH]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Pad to 16 partial counts by adding zero count
    wire [4:0] padded_partial_counts [0:15];
    generate
        for(i=0; i<CHUNKS; i=i+1) begin
            assign padded_partial_counts[i] = partial_counts[i];
        end
        assign padded_partial_counts[15] = 5'd0; // zero padding
    endgenerate

    // Each partial count is 5 bits
    // Summation tree will have 4 levels (since 16 inputs)
    // Level 0: 16 sums, width=5 bits
    // Level 1: 8 sums, width=6 bits
    // Level 2: 4 sums, width=7 bits
    // Level 3: 2 sums, width=8 bits
    // Level 4: 1 sum, width=9 bits (final output)

    // Level 0: assign padded partial counts
    wire [5-1:0] level0 [0:15];
    generate
        for(i=0; i<16; i=i+1) begin
            assign level0[i] = padded_partial_counts[i];
        end
    endgenerate

    // Level 1 sums: 8 sums, each is sum of 2x5-bit inputs -> 6 bits output
    wire [6-1:0] level1 [0:7];
    generate
        for(i=0; i<8; i=i+1) begin
            assign level1[i] = level0[2*i] + level0[2*i+1];
        end
    endgenerate

    // Level 2 sums: 4 sums, each sum of 2x6-bit inputs -> 7 bits output
    wire [7-1:0] level2 [0:3];
    generate
        for(i=0; i<4; i=i+1) begin
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
    endgenerate

    // Level 3 sums: 2 sums, each sum of 2x7-bit inputs -> 8 bits output
    wire [8-1:0] level3 [0:1];
    generate
        for(i=0; i<2; i=i+1) begin
            assign level3[i] = level2[2*i] + level2[2*i+1];
        end
    endgenerate

    // Level 4 sum: sum of 2x8-bit inputs -> 9 bits output
    wire [9-1:0] level4;
    assign level4 = level3[0] + level3[1];

    // Output is 8 bits, max population count is 255
    assign out = level4[7:0];
endmodule