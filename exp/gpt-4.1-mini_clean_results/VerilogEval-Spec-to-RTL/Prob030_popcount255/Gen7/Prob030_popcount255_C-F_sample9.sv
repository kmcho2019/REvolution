module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    // Explicit popcount by summing bits, no loops or functions
    wire [2:0] sum_lo;
    wire [2:0] sum_hi;

    // Sum lower 4 bits (max 4)
    assign sum_lo = in[0] + in[1] + in[2] + in[3];

    // Sum upper 4 bits (max 4)
    assign sum_hi = in[4] + in[5] + in[6] + in[7];

    // sum_lo and sum_hi max 4; sum total max 8, so 4 bits needed
    assign out = sum_lo + sum_hi;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Number of 8-bit chunks to cover 255 bits = 32 (31 full + 1 partial)
    localparam CHUNKS = 32;

    // Array of outputs from popcount8 modules: each 4 bits
    wire [3:0] partial_counts [0:CHUNKS-1];

    genvar i;
    generate
        for (i = 0; i < CHUNKS-1; i = i + 1) begin : pc8_blocks
            // Full 8-bit chunks
            popcount8 pc8_inst(
                .in(in[8*i +: 8]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Handle last partial chunk: 7 bits zero-padded MSB
    wire [7:0] last_chunk;
    assign last_chunk = {1'b0, in[254:248]};

    popcount8 last_pc8_inst (
        .in(last_chunk),
        .out(partial_counts[CHUNKS-1])
    );

    // Balanced adder tree summation of 32 partial_counts (each 4 bits)
    // Each level sums pairs of values, width increases by 1 at each level

    // Level 1: sum 16 pairs of 4-bit numbers -> 16 sums of 5 bits
    wire [4:0] sum_level1 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_l1
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Level 2: sum 8 pairs of 5-bit numbers -> 8 sums of 6 bits
    wire [5:0] sum_level2 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : sum_l2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum 4 pairs of 6-bit numbers -> 4 sums of 7 bits
    wire [6:0] sum_level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : sum_l3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum 2 pairs of 7-bit numbers -> 2 sums of 8 bits
    wire [7:0] sum_level4 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : sum_l4
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
        end
    endgenerate

    // Level 5: final sum of two 8-bit numbers -> output 8 bits (max 255)
    assign out = sum_level4[0] + sum_level4[1];

endmodule