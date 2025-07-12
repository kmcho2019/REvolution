module popcount5 (
    input  [4:0] in,
    output [2:0] out // max 5 ones, needs 3 bits
);
    // Sum 5 bits combinationally
    wire [2:0] sum4 = in[3] + in[2] + in[1] + in[0];
    wire       bit4 = in[4];
    assign out = sum4 + bit4;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    localparam N_GROUPS = 51;
    localparam GROUP_SIZE = 5;

    // Stage 1: Popcount5 modules for 5-bit groups (51 groups)
    wire [2:0] pop5_counts [N_GROUPS-1:0];
    genvar i;
    generate
        for (i = 0; i < N_GROUPS; i = i + 1) begin : pop5_blocks
            popcount5 pc5 (
                .in(in[i*GROUP_SIZE +: GROUP_SIZE]),
                .out(pop5_counts[i])
            );
        end
    endgenerate

    // Stage 2 and beyond: Binary adder tree summing 51 3-bit numbers into final 8-bit output.
    // Max sum = 255 fits in 8 bits.

    // We'll build a binary reduction tree summing pairs of values until only one sum remains.
    // Each stage reduces number of sums by ~2 (ceil division by 2).

    // Create a parametrized function for ceil divide by 2
    function integer ceil_div2(input integer x);
        begin
            ceil_div2 = (x + 1) >> 1;
        end
    endfunction

    // Maximum tree depth for 51 inputs:
    // Level0: 51 sums (3-bit each)
    // Level1: ceil(51/2)=26 sums (width 4 bits min), but to be safe use 8 bits for all sums at all stages
    // Subsequent levels continue until 1 sum remains

    // We'll create arrays for each level:
    // Level 0 width: 3 bits
    // Level 1 and beyond: 8 bits wide (max sum grows but max total is 255)

    // Calculate number of levels needed
    function integer tree_levels(input integer n);
        integer levels, count;
        begin
            levels = 0;
            count = n;
            while (count > 1) begin
                count = ceil_div2(count);
                levels = levels + 1;
            end
            tree_levels = levels;
        end
    endfunction

    localparam LEVELS = tree_levels(N_GROUPS);

    // Declare arrays of sums per level
    // Level 0: 3-bit pop5_counts
    // Other levels: 8-bit sums

    // To hold sums per level, maximum size per level is ceil_div2 of previous level
    // We'll declare max 51 elements per level for simplicity

    // Level 0 sums: 3 bits wide, 51 elements
    wire [2:0] sums_level0 [0:N_GROUPS-1];
    generate
        for (i = 0; i < N_GROUPS; i = i + 1) begin
            assign sums_level0[i] = pop5_counts[i];
        end
    endgenerate

    // Declare sums arrays for each subsequent level
    // Level 1..LEVELS : 8-bit wide sums

    // To hold sizes per level, we can precompute sizes:
    integer level_sizes [0:LEVELS];
    initial begin
        level_sizes[0] = N_GROUPS;
        integer l;
        for (l = 1; l <= LEVELS; l = l +1) begin
            level_sizes[l] = ceil_div2(level_sizes[l-1]);
        end
    end

    // Unfortunately, Verilog does not allow variable array sizes easily,
    // so we'll define maximum size 51 for all levels and only use valid indices.

    wire [7:0] sums_level [0:LEVELS][0:50];

    // Assign level 0 sums: zero-extend 3-bit values to 8 bits
    generate
        for (i = 0; i < N_GROUPS; i = i + 1) begin : assign_level0_ext
            assign sums_level[0][i] = {5'b0, sums_level0[i]};
        end
        // Pad unused indices in level 0 with zero
        for (i = N_GROUPS; i < 51; i = i + 1) begin : pad_level0
            assign sums_level[0][i] = 8'b0;
        end
    endgenerate

    // Build the binary summation tree for levels 1 to LEVELS
    genvar lvl, idx;
    generate
        for (lvl = 1; lvl <= LEVELS; lvl = lvl + 1) begin : sum_levels
            // Number of inputs at previous level
            // We use a localparam for valid input count at this level:
            localparam integer in_count = (lvl == 1) ? ((N_GROUPS+1)/2*2/2) : 0; // placeholder, will override below

            // We can't define localparam from variable array, so we re-calc here:
            // Use a function to get level_sizes[lvl-1] instead:
            function integer get_level_size(input integer l);
                integer j, val;
                begin
                    val = N_GROUPS;
                    for (j = 1; j <= l; j = j + 1) begin
                        val = ceil_div2(val);
                    end
                    get_level_size = val;
                end
            endfunction

            localparam integer prev_count = get_level_size(lvl-1);
            localparam integer curr_count = get_level_size(lvl);

            for (idx = 0; idx < curr_count; idx = idx + 1) begin : sum_pairs
                localparam integer idx0 = idx*2;
                localparam integer idx1 = idx*2 + 1;

                wire [7:0] in0 = (idx0 < prev_count) ? sums_level[lvl-1][idx0] : 8'b0;
                wire [7:0] in1 = (idx1 < prev_count) ? sums_level[lvl-1][idx1] : 8'b0;

                assign sums_level[lvl][idx] = in0 + in1;
            end
            // Pad unused sums at this level with zero
            for (idx = curr_count; idx < 51; idx = idx + 1) begin : pad_unused_sums
                assign sums_level[lvl][idx] = 8'b0;
            end
        end
    endgenerate

    // Final output is sums_level[LEVELS][0], already 8 bits wide
    assign out = sums_level[LEVELS][0];

endmodule