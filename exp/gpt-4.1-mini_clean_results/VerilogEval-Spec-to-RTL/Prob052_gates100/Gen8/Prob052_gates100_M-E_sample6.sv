module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Calculate how many levels needed to reduce 100 inputs down to 1 by pairwise combination
    // Level 0: 100 inputs
    // Each subsequent level halves (round up) the number of signals
    localparam integer LEVELS = 7; // 2^7 = 128 > 100; enough levels

    // Declare arrays of wires for each level and each operation
    // To simplify indexing, use vectors sized to 2^(LEVELS), though only part used
    wire [2**LEVELS-1:0] and_level [0:LEVELS];
    wire [2**LEVELS-1:0] or_level  [0:LEVELS];
    wire [2**LEVELS-1:0] xor_level [0:LEVELS];

    integer i, idx;

    // Initialize level 0 with inputs (pads unused bits to 1 for AND and 0 for OR and XOR identity)
    // AND identity = 1, OR identity = 0, XOR identity = 0
    // This padding ensures padded bits do not affect the reduction result
    generate
        for (i = 0; i < 2**LEVELS; i = i + 1) begin : init_level0
            assign and_level[0][i] = (i < 100) ? in[i] : 1'b1;
            assign or_level [0][i] = (i < 100) ? in[i] : 1'b0;
            assign xor_level[0][i] = (i < 100) ? in[i] : 1'b0;
        end
    endgenerate

    // Generate the tree levels
    generate
        for (idx = 0; idx < LEVELS; idx = idx + 1) begin : gen_tree_levels
            localparam integer WIDTH = (2**LEVELS) >> idx;       // Number of signals at current level
            localparam integer NEXT_WIDTH = WIDTH >> 1;          // Number of signals at next level

            for (i = 0; i < NEXT_WIDTH; i = i + 1) begin : combine_pairs
                assign and_level[idx+1][i] = and_level[idx][2*i] & and_level[idx][2*i+1];
                assign or_level [idx+1][i] = or_level [idx][2*i] | or_level [idx][2*i+1];
                assign xor_level[idx+1][i] = xor_level[idx][2*i] ^ xor_level[idx][2*i+1];
            end

            // Handle odd number of signals by propagating last if WIDTH is odd
            if (WIDTH % 2 == 1) begin : odd_signal
                assign and_level[idx+1][NEXT_WIDTH] = and_level[idx][WIDTH-1];
                assign or_level [idx+1][NEXT_WIDTH] = or_level [idx][WIDTH-1];
                assign xor_level[idx+1][NEXT_WIDTH] = xor_level[idx][WIDTH-1];
            end
        end
    endgenerate

    // The final outputs come from the top level (LEVELS)
    // Note: Due to padding, the final index is 0 (tree root)
    assign out_and = and_level[LEVELS][0];
    assign out_or  = or_level[LEVELS][0];
    assign out_xor = xor_level[LEVELS][0];

endmodule