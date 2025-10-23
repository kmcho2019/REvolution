module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    // Structural popcount8: sum of 8 bits by partial sums
    wire [2:0] sum_lo = in[0] + in[1] + in[2] + in[3]; // max 4
    wire [2:0] sum_hi = in[4] + in[5] + in[6] + in[7]; // max 4
    assign out = sum_lo + sum_hi; // max 8 fits 4 bits
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Parameters for radix-3 tree summation
    localparam INPUT_WIDTH = 8;      // width of popcount8 output (4 bits), but widen to 8 for tree sums
    localparam INPUT_BITS = 255;
    localparam CHUNK_SIZE = 8;
    localparam NUM_CHUNKS = 32;      // 31 full chunks + 1 padded

    // Stage 0: popcount8 outputs
    wire [3:0] pc8 [NUM_CHUNKS-1:0];

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS-1; i = i + 1) begin : pop8_blocks
            popcount8 pc_inst (
                .in(in[i*CHUNK_SIZE +: CHUNK_SIZE]),
                .out(pc8[i])
            );
        end
    endgenerate

    // Last chunk: 7 bits from input plus 1 zero MSB
    wire [7:0] last_chunk = {1'b0, in[254:248]};
    popcount8 last_pc8 (
        .in(last_chunk),
        .out(pc8[NUM_CHUNKS-1])
    );

    // Expand pc8 outputs to 8 bits for tree summation (zero-extend)
    wire [7:0] stage0_sums [NUM_CHUNKS-1:0];
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : extend_to_8bit
            assign stage0_sums[i] = {4'b0, pc8[i]};
        end
    endgenerate

    // Function to perform ceiling division by 3
    function integer ceil_div3(input integer x);
        begin
            ceil_div3 = (x + 2) / 3;
        end
    endfunction

    // Calculate number of levels for radix-3 tree until single sum
    function integer log3_ceil(input integer x);
        integer v, level_count;
        begin
            v = 1;
            level_count = 0;
            while (v < x) begin
                v = v * 3;
                level_count = level_count + 1;
            end
            log3_ceil = level_count;
        end
    endfunction

    localparam LEVELS = log3_ceil(NUM_CHUNKS);

    // Declare sums at each level; max 32 entries at level 0, padding zeros beyond valid indices
    // Each sum is 8 bits wide (max 255 for total popcount)
    wire [7:0] sums_level [0:LEVELS][0:NUM_CHUNKS-1]; // max array size fixed at 32 for simplicity

    // Assign level 0 sums (popcount8 outputs expanded)
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : lvl0_assign
            assign sums_level[0][i] = stage0_sums[i];
        end
        for (i = NUM_CHUNKS; i < NUM_CHUNKS; i = i + 1) begin : lvl0_pad_unused
            assign sums_level[0][i] = 8'd0;
        end
    endgenerate

    genvar lvl, idx;
    generate
        for (lvl = 1; lvl <= LEVELS; lvl = lvl + 1) begin : adder_tree_levels
            localparam integer in_count = (lvl == 1) ? NUM_CHUNKS :
                                          ceil_div3( (lvl == 2) ? ceil_div3(NUM_CHUNKS) :
                                          (lvl == 3) ? ceil_div3(ceil_div3(NUM_CHUNKS)) :
                                          (lvl == 4) ? ceil_div3(ceil_div3(ceil_div3(NUM_CHUNKS))) :
                                          1); // General recursive ceil_div3 for level >4 not used here as max levels=4-5

            localparam integer out_count = ceil_div3(in_count);

            for (idx = 0; idx < out_count; idx = idx + 1) begin : sum3_adder
                // Inputs indices from previous level
                localparam integer idx0 = idx*3 + 0;
                localparam integer idx1 = idx*3 + 1;
                localparam integer idx2 = idx*3 + 2;

                wire [7:0] in0 = (idx0 < in_count) ? sums_level[lvl-1][idx0] : 8'd0;
                wire [7:0] in1 = (idx1 < in_count) ? sums_level[lvl-1][idx1] : 8'd0;
                wire [7:0] in2 = (idx2 < in_count) ? sums_level[lvl-1][idx2] : 8'd0;

                assign sums_level[lvl][idx] = in0 + in1 + in2;
            end

            // Pad unused outputs with zero to keep array size consistent
            for (idx = out_count; idx < NUM_CHUNKS; idx = idx + 1) begin : pad_unused
                assign sums_level[lvl][idx] = 8'd0;
            end
        end
    endgenerate

    // Final output is sums_level[LEVELS][0], 8 bits is sufficient for max 255
    assign out = sums_level[LEVELS][0];

endmodule