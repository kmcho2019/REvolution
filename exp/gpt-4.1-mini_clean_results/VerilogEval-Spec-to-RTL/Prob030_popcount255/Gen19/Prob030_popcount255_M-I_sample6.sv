module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module popcount_255_flat (
    input  [254:0] in,
    output [7:0] out // max count is 255 fits in 8 bits
);
    // Break input into 32 chunks: 31 of 8 bits + 1 of 7 bits padded to 8 bits
    // Use popcount8 for each chunk to get 4-bit partial sums
    // Then sum these 32 partial sums in a balanced adder tree to produce final 8-bit result

    // Partial counts for 32 chunks
    wire [3:0] chunk_popcount [31:0];

    genvar idx;
    generate
        for (idx = 0; idx < 31; idx = idx + 1) begin : pc8_chunks
            popcount8 pc8_inst (
                .in(in[8*idx +: 8]),
                .out(chunk_popcount[idx])
            );
        end
    endgenerate

    // Last chunk: bits 248 to 254 (7 bits), zero pad MSB to 8 bits
    wire [7:0] last_chunk = {1'b0, in[254:248]};
    popcount8 last_pc8_inst (
        .in(last_chunk),
        .out(chunk_popcount[31])
    );

    // Now sum all 32 partial sums (4-bit each) in a balanced adder tree
    // 32 x 4-bit numbers sum max = 32*8=256 (9 bits), but output is 8 bits,
    // max count is 255, so 8 bits sufficient.
    // Use intermediate wires for partial sums with enough width to avoid overflow.

    // Level 1: sum pairs -> 16 sums, each max = 8+8=16 (5 bits)
    wire [4:0] sum_l1 [15:0];
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_level1
            assign sum_l1[idx] = chunk_popcount[2*idx] + chunk_popcount[2*idx+1];
        end
    endgenerate

    // Level 2: sum pairs -> 8 sums, each max = 16+16=32 (6 bits)
    wire [5:0] sum_l2 [7:0];
    generate
        for (idx = 0; idx < 8; idx = idx + 1) begin : sum_level2
            assign sum_l2[idx] = sum_l1[2*idx] + sum_l1[2*idx+1];
        end
    endgenerate

    // Level 3: sum pairs -> 4 sums, each max = 32+32=64 (7 bits)
    wire [6:0] sum_l3 [3:0];
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : sum_level3
            assign sum_l3[idx] = sum_l2[2*idx] + sum_l2[2*idx+1];
        end
    endgenerate

    // Level 4: sum pairs -> 2 sums, each max = 64+64=128 (8 bits)
    wire [7:0] sum_l4 [1:0];
    generate
        for (idx = 0; idx < 2; idx = idx + 1) begin : sum_level4
            assign sum_l4[idx] = sum_l3[2*idx] + sum_l3[2*idx+1];
        end
    endgenerate

    // Final level: sum two 8-bit numbers -> max 128+128=256 (9 bits, but max 255, so 8 bits output sufficient)
    wire [8:0] sum_final;
    assign sum_final = sum_l4[0] + sum_l4[1];

    // Truncate the 9-bit sum_final to 8 bits (saturates at 255 max count)
    // Since max count is 255, bit 8 should not be set; if set, clamp to 255.
    assign out = (sum_final[8] == 1'b1) ? 8'hFF : sum_final[7:0];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate flattened and unrolled popcount for 255 bits
    popcount_255_flat u_popcount (
        .in(in),
        .out(out)
    );
endmodule