module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Calculate levels needed for tree (ceil(log2(100)) = 7)
    localparam LEVELS = 7;

    // Declare arrays of wires for intermediate results at each level
    // For each level, max elements = ceil(100 / 2^level)
    // Since we can't use dynamic arrays, define max sizes fixed by the largest needed

    // Level 0 is inputs
    wire [99:0] and_level [0:LEVELS];
    wire [99:0] or_level  [0:LEVELS];
    wire [99:0] xor_level [0:LEVELS];

    // Initialize level 0 with input values
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : init_level0
            assign and_level[0][i] = in[i];
            assign or_level[0][i]  = in[i];
            assign xor_level[0][i] = in[i];
        end
        // For unused bits at level 0 (100-100=0), no assignment needed
    endgenerate

    integer level, idx, next_idx, max_idx, elem_count;

    // Build balanced binary tree for each output separately
    // At each level, pairs of bits from previous level are ANDed/ORed/XORed
    // If odd number of elements, last one passes up directly

    // Since generate loops do not support runtime iteration count,
    // we unroll the levels manually in a for-generate block using localparams.

    // This uses procedural generate block to create all levels.

    // Using a helper function to compute number of elements at each level
    function integer elements_at_level(input integer lvl);
        integer cnt;
        begin
            cnt = 100;
            repeat (lvl) cnt = (cnt + 1) >> 1;
            elements_at_level = cnt;
        end
    endfunction

    generate
        for (level = 1; level <= LEVELS; level = level +1) begin : gen_levels
            localparam integer prev_count = elements_at_level(level - 1);
            localparam integer curr_count = elements_at_level(level);
            for (idx = 0; idx < curr_count; idx = idx + 1) begin : gen_pairs
                // Calculate indices of inputs from previous level
                localparam integer left_idx  = idx*2;
                localparam integer right_idx = idx*2 + 1;

                if (right_idx < prev_count) begin
                    // Both left and right exist: combine
                    assign and_level[level][idx] = and_level[level-1][left_idx] & and_level[level-1][right_idx];
                    assign or_level[level][idx]  = or_level[level-1][left_idx]  | or_level[level-1][right_idx];
                    assign xor_level[level][idx] = xor_level[level-1][left_idx] ^ xor_level[level-1][right_idx];
                end else begin
                    // Only left exists: propagate it
                    assign and_level[level][idx] = and_level[level-1][left_idx];
                    assign or_level[level][idx]  = or_level[level-1][left_idx];
                    assign xor_level[level][idx] = xor_level[level-1][left_idx];
                end
            end
        end
    endgenerate

    // Final outputs are the single remaining bit at top level (level=LEVELS, index 0)
    assign out_and = and_level[LEVELS][0];
    assign out_or  = or_level[LEVELS][0];
    assign out_xor = xor_level[LEVELS][0];

endmodule