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

// Parameterized adder module adding two unsigned vectors and outputting sum with width = max input widths + 1
module adder #(
    parameter WIDTHA = 8,
    parameter WIDTHB = 8
) (
    input  [WIDTHA-1:0] a,
    input  [WIDTHB-1:0] b,
    output [((WIDTHA > WIDTHB) ? WIDTHA : WIDTHB):0] sum
);
    assign sum = a + b;
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Constants
    localparam CHUNK_SIZE = 8;
    localparam NUM_FULL_CHUNKS = 31;  // 8*31=248 bits
    localparam LEFTOVER_SIZE = 7;     // 255 - 248 = 7 bits

    // Wires for popcount8 outputs of full chunks (each 4 bits)
    wire [3:0] chunk_pops [0:NUM_FULL_CHUNKS-1];
    // Wire for leftover popcount8 output (4 bits)
    wire [3:0] leftover_pop;

    genvar i;
    generate
        // Popcount for full 8-bit chunks
        for (i = 0; i < NUM_FULL_CHUNKS; i = i + 1) begin : full_chunks_popcount
            popcount8 u_popcount8 (
                .in(in[CHUNK_SIZE*i +: CHUNK_SIZE]),
                .out(chunk_pops[i])
            );
        end
    endgenerate

    // Popcount for leftover bits, zero-padded MSB to 8 bits
    wire [7:0] leftover_in = { {(CHUNK_SIZE-LEFTOVER_SIZE){1'b0}}, in[254:CHUNK_SIZE*NUM_FULL_CHUNKS] };
    popcount8 leftover_popcount (
        .in(leftover_in),
        .out(leftover_pop)
    );

    // Combine all 32 counts (31 full + 1 leftover) into a balanced adder tree
    // We'll build successive layers summing pairs until one final sum remains.

    // Level 0: 32 inputs of 4 bits each
    localparam NUM_COUNTS = NUM_FULL_CHUNKS + 1; // 32

    // Because each count is max 8, 4 bits each, sum of 32 counts max = 255 (8*32=256 theoretically, max 255)
    // Final sum width is 8 bits, so outputs in the adder tree grow by 1 bit per stage since sums increase.

    // We'll implement a generate block building the adder tree dynamically.

    // First create an array of sums at level 0 (inputs)
    wire [3:0] level0 [0:NUM_COUNTS-1];
    generate
        for(i=0; i<NUM_FULL_CHUNKS; i=i+1) begin : assign_level0_full
            assign level0[i] = chunk_pops[i];
        end
        assign level0[NUM_COUNTS-1] = leftover_pop;
    endgenerate

    // Recursive parameterized adder tree function as generate block
    // We define a macro to build balanced tree levels until only one sum remains.

    // We'll use a generate block with params: input array of width W and length L,
    // each output sum width is W+1, then next level input width is W+1, length = ceil(L/2).
    // Last level sum width used for output.

    // To manage widths, define a function returning sum width at each stage:
    // Stage 0 width = 4
    // Stage n width = 4 + n (since each addition can increase width by 1)

    // We'll unroll the tree level by level, each level halves the number of sums.

    // Maximum tree depth = ceil(log2(32)) = 5 levels

    // Create arrays for each level:
    // level0: 32 sums @4 bits
    // level1: 16 sums @5 bits
    // level2: 8 sums @6 bits
    // level3: 4 sums @7 bits
    // level4: 2 sums @8 bits
    // level5: 1 sum  @9 bits (but 255 max sum fits in 8 bits, so we can safely truncate the MSB here)

    // To keep outputs widths consistent and avoid over-wide signals, keep widths minimal:

    // The max count is 255 (8 bits), so final sum output width is 8 bits, no 9th bit needed.

    // We'll implement adders with correct widths and truncate final output to 8 bits.

    // Use arrays of wires per level:

    // LEVEL 0: 32 sums of 4 bits
    // LEVEL 1: 16 sums of 5 bits
    // LEVEL 2: 8 sums of 6 bits
    // LEVEL 3: 4 sums of 7 bits
    // LEVEL 4: 2 sums of 8 bits
    // LEVEL 5: 1 sum  of 8 bits (final output)

    // Define widths per level:
    localparam LEVEL0_WIDTH = 4;
    localparam LEVEL1_WIDTH = 5;
    localparam LEVEL2_WIDTH = 6;
    localparam LEVEL3_WIDTH = 7;
    localparam LEVEL4_WIDTH = 8;
    localparam LEVEL5_WIDTH = 8;

    // Define wire arrays
    wire [LEVEL1_WIDTH-1:0] level1 [0:15];
    wire [LEVEL2_WIDTH-1:0] level2 [0:7];
    wire [LEVEL3_WIDTH-1:0] level3 [0:3];
    wire [LEVEL4_WIDTH-1:0] level4 [0:1];
    wire [LEVEL5_WIDTH-1:0] level5;

    // Level 1 adders: sum pairs of level0 inputs (4 bits each)
    generate
        for(i=0; i<16; i=i+1) begin : level1_adders
            adder #(.WIDTHA(LEVEL0_WIDTH), .WIDTHB(LEVEL0_WIDTH)) add_l1 (
                .a(level0[2*i]),
                .b(level0[2*i+1]),
                .sum(level1[i])
            );
        end
    endgenerate

    // Level 2 adders: sum pairs of level1 outputs (5 bits each)
    generate
        for(i=0; i<8; i=i+1) begin : level2_adders
            adder #(.WIDTHA(LEVEL1_WIDTH), .WIDTHB(LEVEL1_WIDTH)) add_l2 (
                .a(level1[2*i]),
                .b(level1[2*i+1]),
                .sum(level2[i])
            );
        end
    endgenerate

    // Level 3 adders: sum pairs of level2 outputs (6 bits each)
    generate
        for(i=0; i<4; i=i+1) begin : level3_adders
            adder #(.WIDTHA(LEVEL2_WIDTH), .WIDTHB(LEVEL2_WIDTH)) add_l3 (
                .a(level2[2*i]),
                .b(level2[2*i+1]),
                .sum(level3[i])
            );
        end
    endgenerate

    // Level 4 adders: sum pairs of level3 outputs (7 bits each)
    generate
        for(i=0; i<2; i=i+1) begin : level4_adders
            adder #(.WIDTHA(LEVEL3_WIDTH), .WIDTHB(LEVEL3_WIDTH)) add_l4 (
                .a(level3[2*i]),
                .b(level3[2*i+1]),
                .sum(level4[i])
            );
        end
    endgenerate

    // Level 5 adder: sum the two level4 outputs (8 bits each)
    adder #(.WIDTHA(LEVEL4_WIDTH), .WIDTHB(LEVEL4_WIDTH)) add_l5 (
        .a(level4[0]),
        .b(level4[1]),
        .sum(level5)
    );

    // level5 sum width is 9 bits (8+8+1), but max sum is 255, fits in 8 bits.
    // So truncate the MSB if exists:
    assign out = level5[7:0];

endmodule