module popcount16(
    input  wire [15:0] in,
    output wire [4:0]  out  // max count is 16 -> 5 bits
);
    // Simple adder tree for 16 bits: sum bits in pairs
    wire [7:0] sum_stage1;
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : stage1
            assign sum_stage1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [3:0] sum_stage2;
    generate
        for (i=0; i<4; i=i+1) begin : stage2
            assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
        end
    endgenerate

    wire [1:0] sum_stage3;
    generate
        for (i=0; i<2; i=i+1) begin : stage3
            assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
        end
    endgenerate

    assign out = sum_stage3[0] + sum_stage3[1]; // 5-bit result
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // Divide 255 bits into sixteen 16-bit blocks (last block is 15 bits)
    // We will zero-pad the last block to 16 bits

    localparam BLOCKS = 16;
    wire [4:0] partial_counts [BLOCKS-1:0];

    genvar idx;
    generate
        for (idx=0; idx<BLOCKS-1; idx=idx+1) begin : gen_pop16_blocks
            popcount16 pc16 (
                .in(in[16*idx +: 16]),
                .out(partial_counts[idx])
            );
        end
        // Last block: 15 bits + 1 zero bit pad
        wire [15:0] last_block_in = {1'b0, in[254:240]};
        popcount16 pc16_last (
            .in(last_block_in),
            .out(partial_counts[BLOCKS-1])
        );
    endgenerate

    // Now sum the 16 partial counts (5 bits each) using a balanced adder tree.
    // Partial counts max sum = 255 (fits in 8 bits)

    // Level 1: 8 sums (sum pairs of partial counts)
    wire [5:0] sum_level1 [7:0]; // 6 bits to hold max 31+31=62

    generate
        for (idx=0; idx<8; idx=idx+1) begin : gen_sum_level1
            assign sum_level1[idx] = partial_counts[2*idx] + partial_counts[2*idx + 1];
        end
    endgenerate

    // Level 2: 4 sums
    wire [6:0] sum_level2 [3:0]; // 7 bits to hold max 62+62=124

    generate
        for (idx=0; idx<4; idx=idx+1) begin : gen_sum_level2
            assign sum_level2[idx] = sum_level1[2*idx] + sum_level1[2*idx + 1];
        end
    endgenerate

    // Level 3: 2 sums
    wire [7:0] sum_level3 [1:0]; // 8 bits to hold max 124+124=248

    generate
        for (idx=0; idx<2; idx=idx+1) begin : gen_sum_level3
            assign sum_level3[idx] = sum_level2[2*idx] + sum_level2[2*idx + 1];
        end
    endgenerate

    // Level 4: final sum
    wire [8:0] sum_level4; // 9 bits to hold max 248+248=496 (overestimated, actual max is 255)
    assign sum_level4 = sum_level3[0] + sum_level3[1];

    // Output is 8 bits (max count 255 fits in 8 bits)
    assign out = sum_level4[7:0];

endmodule