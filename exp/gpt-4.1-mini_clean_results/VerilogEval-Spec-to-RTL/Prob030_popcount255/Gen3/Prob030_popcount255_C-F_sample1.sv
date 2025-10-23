module popcount17 (
    input  [16:0] in,
    output [5:0] out // max 17 ones => need 5 bits, use 6 bits for margin
);
    // Popcount 4 bits function: sum bits explicitly
    function [2:0] popcount4;
        input [3:0] bits;
        begin
            popcount4 = bits[0] + bits[1] + bits[2] + bits[3];
        end
    endfunction

    wire [2:0] sum0 = popcount4(in[3:0]);
    wire [2:0] sum1 = popcount4(in[7:4]);
    wire [2:0] sum2 = popcount4(in[11:8]);
    wire [2:0] sum3 = popcount4(in[15:12]);
    wire       sum4 = in[16];

    // sum0 and sum1: 3 bits each -> max 4'b1000 (8 decimal), sum is 4 bits wide
    wire [3:0] sum01 = sum0 + sum1;
    wire [3:0] sum23 = sum2 + sum3;

    // sum01 + sum23: 4 bits + 4 bits = 5 bits max
    wire [4:0] sum0123 = sum01 + sum23;

    // final sum: sum0123 (5 bits) + sum4 (1 bit) = 6 bits
    wire [5:0] total = sum0123 + sum4;

    assign out = total;
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // 15 blocks of 17 bits each
    wire [5:0] partial_counts [14:0];

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Helper function to calculate the ceiling of log2 at compile time
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value-1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    // The number of partial counts
    localparam N = 15;

    // Sum partial_counts using a balanced adder tree via generate loops

    // We use an array of wires to hold intermediate sums at each level
    // Each level halves the number of sums until one remains
    // Each sum width grows as needed: max sum is N * 17 = 255, fits in 8 bits

    // Max bit-width per sum = 8 bits
    localparam SUM_WIDTH = 8;

    // Calculate number of tree levels needed
    localparam LEVELS = clog2(N);

    // Declare arrays for each level (max size N at level 0, halves each level)
    // Use a 2D array indexed [level][index]
    wire [SUM_WIDTH-1:0] sum_level [0:LEVELS][0:N-1];

    // Level 0: zero-extend partial_counts[0..14] to 8 bits, fill unused indices with zero
    generate
        for (gi = 0; gi < N; gi = gi + 1) begin : level0_assign
            assign sum_level[0][gi] = {2'b00, partial_counts[gi]}; // 6-bit to 8-bit zero-extend
        end
        for (gi = N; gi < N; gi = gi + 1) begin : level0_pad_unused
            // no unused entries since we sized arrays for N exactly
            // empty
        end
    endgenerate

    // Build the tree levels: from 1 to LEVELS
    genvar level, idx;
    generate
        for (level = 1; level <= LEVELS; level = level + 1) begin : levels
            // number of sums at this level = ceil(N / (2^level))
            localparam integer LEVEL_SIZE = (N + (1 << level) - 1) >> level;
            for (idx = 0; idx < LEVEL_SIZE; idx = idx + 1) begin : sums
                // indices of operands in previous level
                localparam integer idx0 = 2 * idx;
                localparam integer idx1 = idx0 + 1;
                wire [SUM_WIDTH-1:0] in0 = (idx0 < ((N + (1 << (level-1)) - 1) >> (level-1))) ? sum_level[level-1][idx0] : {SUM_WIDTH{1'b0}};
                wire [SUM_WIDTH-1:0] in1 = (idx1 < ((N + (1 << (level-1)) - 1) >> (level-1))) ? sum_level[level-1][idx1] : {SUM_WIDTH{1'b0}};
                assign sum_level[level][idx] = in0 + in1;
            end
            // Pad unused outputs if any, but unnecessary since array sized to LEVEL_SIZE exactly
        end
    endgenerate

    // Final output is the single sum at highest level index 0
    assign out = sum_level[LEVELS][0];

endmodule