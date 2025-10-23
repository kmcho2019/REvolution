module popcount8 (
    input  [7:0] in,
    output [3:0] out  // max 8 ones => 4 bits
);
    // LUT-based simple bit count using adders (adder tree)
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum46 = in[4] + in[5];
    wire [1:0] sum57 = in[6] + in[7];

    wire [2:0] sum0123 = sum02 + sum13; // max 4
    wire [2:0] sum4567 = sum46 + sum57; // max 4

    assign out = sum0123 + sum4567; // max 8
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out  // max 7 ones => 4 bits (uniform width)
);
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum45 = in[4] + in[5];
    wire       bit6 = in[6];

    wire [2:0] sum0123 = sum02 + sum13;  // max 4
    wire [2:0] sum4546 = sum45 + bit6;   // max 3

    assign out = sum0123 + sum4546;      // max 7
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    localparam NUM_CHUNKS = 32;
    localparam CHUNK_BITS = 8; // except last chunk is 7 bits
    localparam PARTIAL_WIDTH = 4; // bits to represent partial counts (0..8)

    // Partial counts from chunks
    wire [PARTIAL_WIDTH-1:0] partial_counts [0:NUM_CHUNKS-1];

    genvar i;
    generate
        // Generate 31 chunks of 8 bits popcount8
        for (i = 0; i < NUM_CHUNKS-1; i = i + 1) begin : gen_pop8_chunks
            popcount8 u_pop8 (
                .in(in[i*CHUNK_BITS +: CHUNK_BITS]),
                .out(partial_counts[i])
            );
        end
        // Last chunk with 7 bits popcount7
        popcount7 u_pop7 (
            .in(in[254:248]),
            .out(partial_counts[NUM_CHUNKS-1])
        );
    endgenerate

    // Flatten partial counts into a vector for summation tree
    wire [PARTIAL_WIDTH*NUM_CHUNKS-1:0] partial_counts_flat;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : flatten_pc
            assign partial_counts_flat[(i+1)*PARTIAL_WIDTH-1 -: PARTIAL_WIDTH] = partial_counts[i];
        end
    endgenerate

    // Iterative balanced summation tree (non-recursive)
    // Number of levels = clog2(NUM_CHUNKS) = 5 for 32 chunks
    // At each level, number of sums halves, width increases by 1 (due to addition)
    localparam LEVELS = 5;

    // Define array of wires for each level: level 0 is partial_counts, level LEVELS is final sum
    // Level 0 width: PARTIAL_WIDTH bits per element
    // Each next level width = prev_level_width + 1
    // We'll store levels as packed vectors: [num_elements * width_per_element -1 : 0]

    // Calculate widths and counts per level at compile time
    function integer get_width(input integer level);
        get_width = PARTIAL_WIDTH + level; // width grows by 1 bit each level
    endfunction
    function integer get_count(input integer level);
        get_count = NUM_CHUNKS >> level;  // elements halve each level
    endfunction

    // Create wires for levels
    // We'll use generate arrays of wires for each level
    // Level 0 initialized with partial_counts_flat

    // Declare reg arrays to hold sums at each level (as wires, combinational)
    // Level 0:
    wire [get_width(0)*get_count(0)-1:0] level_data[0:LEVELS];

    // Assign level 0 data: partial_counts_flat, zero extend each partial count from 4 bits to 4 bits (no extension needed)
    // But for uniformity, assign partial_counts_flat into level_data[0]
    // partial_counts_flat has 32 elements *4 bits = 128 bits
    // level_data[0] width = get_width(0)*get_count(0) = 4*32=128 bits
    assign level_data[0] = partial_counts_flat;

    genvar lvl, idx;
    generate
        for (lvl = 1; lvl <= LEVELS; lvl = lvl + 1) begin : sum_levels
            // Number of elements and width at this level
            localparam integer CNT = get_count(lvl);
            localparam integer WIDTH = get_width(lvl);

            // At previous level:
            localparam integer PREV_CNT = get_count(lvl - 1);
            localparam integer PREV_WIDTH = get_width(lvl - 1);

            wire [PREV_WIDTH-1:0] elem0;
            wire [PREV_WIDTH-1:0] elem1;
            // Declare wire for this level's data
            wire [WIDTH-1:0] sums [0:CNT-1];

            for (idx = 0; idx < CNT; idx = idx + 1) begin : sums
                // Extract two operands from previous level_data
                // Elements at lvl-1 are packed sequentially in level_data[lvl-1]
                // Slice indices:
                // elem0 index = idx*2
                // elem1 index = idx*2 +1

                // Extract elem0 bits
                wire [PREV_WIDTH-1:0] op0 = level_data[lvl-1][ ( (idx*2)+1 ) * PREV_WIDTH -1 -: PREV_WIDTH ];
                wire [PREV_WIDTH-1:0] op1 = level_data[lvl-1][ ( (idx*2)+2 ) * PREV_WIDTH -1 -: PREV_WIDTH ];

                // Sum operands: width increases by 1 bit
                assign sums[idx] = op0 + op1;
            end

            // Pack sums into level_data[lvl]
            wire [WIDTH*CNT-1:0] packed_sums;
            for (idx = 0; idx < CNT; idx = idx + 1) begin : pack_sums
                assign packed_sums[(idx+1)*WIDTH-1 -: WIDTH] = sums[idx];
            end

            assign level_data[lvl] = packed_sums;
        end
    endgenerate

    // level_data[LEVELS] has 1 element, final sum, width = PARTIAL_WIDTH + LEVELS = 4+5=9 bits
    wire [8:0] total_count = level_data[LEVELS][8:0];

    // Output lower 8 bits (max 255)
    assign out = total_count[7:0];

endmodule