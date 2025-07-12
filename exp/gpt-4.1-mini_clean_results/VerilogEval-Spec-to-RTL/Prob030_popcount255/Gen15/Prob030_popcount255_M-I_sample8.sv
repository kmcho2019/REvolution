module popcount16 (
    input  [15:0] in,
    output [4:0]  out  // max popcount 16 fits in 5 bits
);
    // Simple balanced adder tree for 16 bits
    wire [3:0] sum_2[7:0];
    wire [3:0] sum_4[3:0];
    wire [4:0] sum_8[1:0];

    // pairwise sum of bits (1-bit + 1-bit = 2-bit result max 2)
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : pair_sum
            assign sum_2[i] = in[i*2] + in[i*2+1];
        end
    endgenerate

    // sum pairs of sum_2 (max 2 + 2 = 3-bit max 4)
    generate
        for (i=0; i<4; i=i+1) begin : quad_sum
            assign sum_4[i] = sum_2[i*2] + sum_2[i*2+1];
        end
    endgenerate

    // sum pairs of sum_4 (max 4 + 4 = 5-bit max 8)
    generate
        for (i=0; i<2; i=i+1) begin : oct_sum
            assign sum_8[i] = sum_4[i*2] + sum_4[i*2+1];
        end
    endgenerate

    // final sum of two sum_8
    assign out = sum_8[0] + sum_8[1]; // max 16 fits in 5 bits
endmodule

module popcount15 (
    input  [14:0] in,
    output [4:0]  out  // max popcount 15 fits in 4 bits but keep 5 bits for consistency
);
    // Use same approach as popcount16 but for 15 bits
    wire [3:0] sum_2[7:0];
    wire [3:0] sum_4[3:0];
    wire [4:0] sum_8[1:0];

    // pairwise sum of bits (last bit padded with zero)
    genvar i;
    generate
        for (i=0; i<7; i=i+1) begin : pair_sum_15
            assign sum_2[i] = in[i*2] + in[i*2+1];
        end
    endgenerate
    assign sum_2[7] = in[14] + 1'b0; // last bit + 0

    // sum pairs of sum_2
    generate
        for (i=0; i<4; i=i+1) begin : quad_sum_15
            assign sum_4[i] = sum_2[i*2] + sum_2[i*2+1];
        end
    endgenerate

    // sum pairs of sum_4
    generate
        for (i=0; i<2; i=i+1) begin : oct_sum_15
            assign sum_8[i] = sum_4[i*2] + sum_4[i*2+1];
        end
    endgenerate

    assign out = sum_8[0] + sum_8[1];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0]   out
);
    // Partition input into 15 chunks of 16 bits + 1 chunk of 15 bits
    // Each chunk popcount is 5 bits

    localparam CHUNKS_16 = 15;
    wire [4:0] partial_counts [CHUNKS_16:0]; // 16 elements: 15x16-bit + 1x15-bit

    genvar i;
    generate
        for (i=0; i<CHUNKS_16; i=i+1) begin : gen_pop16
            popcount16 pc16_inst (
                .in(in[i*16 +: 16]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    popcount15 pc15_inst (
        .in(in[254 -: 15]), // bits [254:240]
        .out(partial_counts[CHUNKS_16])
    );

    // Sum all 16 partial_counts (5-bit each) with a balanced adder tree

    // Stage 1: sum pairs -> 8 sums (5+5=6 bits)
    wire [5:0] stage1_sums [7:0];
    generate
        for (i=0; i<8; i=i+1) begin : stage1
            if (2*i+1 <= CHUNKS_16) begin
                assign stage1_sums[i] = partial_counts[2*i] + partial_counts[2*i+1];
            end else begin
                assign stage1_sums[i] = partial_counts[2*i]; // last odd element
            end
        end
    endgenerate

    // Stage 2: sum pairs -> 4 sums (6+6=7 bits)
    wire [6:0] stage2_sums [3:0];
    generate
        for (i=0; i<4; i=i+1) begin : stage2
            assign stage2_sums[i] = stage1_sums[2*i] + stage1_sums[2*i+1];
        end
    endgenerate

    // Stage 3: sum pairs -> 2 sums (7+7=8 bits)
    wire [7:0] stage3_sums [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : stage3
            assign stage3_sums[i] = stage2_sums[2*i] + stage2_sums[2*i+1];
        end
    endgenerate

    // Stage 4: final sum (8+8=9 bits, but output max 255 so 8 bits enough)
    wire [8:0] final_sum = stage3_sums[0] + stage3_sums[1];

    assign out = final_sum[7:0]; // output 8-bit popcount

endmodule