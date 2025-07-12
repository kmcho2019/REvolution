module popcount #(parameter WIDTH = 16) (
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);
    // Generic balanced tree popcount for WIDTH bits
    // Recursively sum pairs of bits until one sum remains
    
    // Special cases for small WIDTH to avoid generate complexity
    generate
        if (WIDTH == 1) begin
            assign out = in;
        end else if (WIDTH == 2) begin
            assign out = in[0] + in[1];
        end else begin
            // Split input into two halves
            localparam L_WIDTH = WIDTH/2;
            localparam R_WIDTH = WIDTH - L_WIDTH;
            wire [$clog2(L_WIDTH+1)-1:0] left_count;
            wire [$clog2(R_WIDTH+1)-1:0] right_count;

            popcount #(L_WIDTH) left_popcount (
                .in(in[L_WIDTH-1:0]),
                .out(left_count)
            );

            popcount #(R_WIDTH) right_popcount (
                .in(in[WIDTH-1:L_WIDTH]),
                .out(right_count)
            );

            assign out = left_count + right_count;
        end
    endgenerate
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0] out
);
    // Partition input into 16 blocks: 15 blocks of 16 bits, 1 block of 15 bits
    localparam NUM_BLOCKS = 16;
    // Widths of each block: first 15 are 16 bits, last one 15 bits
    // Generate an array of widths for convenience
    // We'll declare wires for each partial popcount output
    wire [4:0] partial_pc [0:14]; // 16-bit popcounts max output 5 bits
    wire [4:0] partial_pc_last;    // 15-bit popcount max 4 bits, use 5 bits for uniformity

    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : gen_popcount_blocks
            popcount #(16) pc16 (
                .in(in[16*i +: 16]),
                .out(partial_pc[i])
            );
        end
    endgenerate

    popcount #(15) pc15 (
        .in(in[254:240]),
        .out(partial_pc_last)
    );

    // Combine all partial results into an array for summation
    // Concatenate partial_pc[0..14] and partial_pc_last into one array of 16 elements
    wire [4:0] partial_counts [0:15];
    generate
        for (i = 0; i < 15; i = i + 1) begin : assign_partials
            assign partial_counts[i] = partial_pc[i];
        end
    endgenerate
    assign partial_counts[15] = partial_pc_last;

    // Balanced tree summation of the 16 partial counts to get 8-bit output
    // Use a function to do iterative pairwise addition until one sum remains

    // Maximum sum = 255, so output width = 8 bits
    // Define a recursive function in Verilog-2001 way using generate and localparam

    // First, define a module that sums N inputs of W bits, recursively
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for(i = value-1; i > 0; i = i>>1)
                clog2 = clog2 + 1;
        end
    endfunction

    localparam LEVELS = clog2(NUM_BLOCKS);
    // We use a multi-dimensional array to hold sums at each level
    // Each level reduces number of elements by half (rounded up)
    // Width increases by 1 bit max per level

    // Declare wires for sum tree: sums[level][index]
    // Widths: start with 5 bits (partial_counts width), increase by 1 per level

    // To make it clean, use generate loops for levels and pairs

    // Declare array to hold sums at each level
    // Use arrays of reg/wire indexed by level and position
    // Since Verilog doesn't support multi-dim arrays of wires easily, flatten indexing

    // Level 0 sums are partial_counts (16 elements, 5 bits)
    // Level 1 sums ceil(16/2)=8 elements, width 6 bits
    // Level 2 sums 4 elements, width 7 bits
    // Level 3 sums 2 elements, width 8 bits
    // Level 4 sums 1 element, width 9 bits -> we only need 8 bits output max 255 fits in 8 bits, but safe to keep 9 bits in intermediate

    // Declare wires for sums
    wire [4:0] sums_level_0 [0:NUM_BLOCKS-1];
    wire [5:0] sums_level_1 [0:7];
    wire [6:0] sums_level_2 [0:3];
    wire [7:0] sums_level_3 [0:1];
    wire [8:0] sums_level_4;

    // Assign level 0
    generate
        for (i=0; i<NUM_BLOCKS; i=i+1) begin : assign_level_0
            assign sums_level_0[i] = partial_counts[i];
        end
    endgenerate

    // Level 1: sum pairs from level 0 (5 bits + 5 bits = 6 bits)
    generate
        for (i=0; i<8; i=i+1) begin : sum_level_1
            assign sums_level_1[i] = sums_level_0[2*i] + sums_level_0[2*i+1];
        end
    endgenerate

    // Level 2: sum pairs from level 1 (6 bits + 6 bits = 7 bits)
    generate
        for (i=0; i<4; i=i+1) begin : sum_level_2
            assign sums_level_2[i] = sums_level_1[2*i] + sums_level_1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs from level 2 (7 bits + 7 bits = 8 bits)
    generate
        for (i=0; i<2; i=i+1) begin : sum_level_3
            assign sums_level_3[i] = sums_level_2[2*i] + sums_level_2[2*i+1];
        end
    endgenerate

    // Level 4: sum the two elements from level 3 (8 bits + 8 bits = 9 bits)
    assign sums_level_4 = sums_level_3[0] + sums_level_3[1];

    // Final output is lower 8 bits (max 255)
    assign out = sums_level_4[7:0];

endmodule