module popcount5 (
    input  [4:0] in,
    output [2:0] out // max 5 ones, fits in 3 bits
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

    // Step 1: Partition input into 51 groups of 5 bits, apply popcount5
    localparam N_POP5 = 51;
    wire [2:0] popcount5_outs [N_POP5-1:0];

    genvar i;
    generate
        for (i = 0; i < N_POP5; i = i + 1) begin : popcount5_blocks
            popcount5 pc5_inst (
                .in(in[i*5 +: 5]),
                .out(popcount5_outs[i])
            );
        end
    endgenerate

    // Step 2: Sum the 51 partial counts (3-bit each) via a balanced binary tree of adders.

    // Function to compute next level size when summing pairs
    function integer div2_ceil;
        input integer x;
        begin
            div2_ceil = (x + 1) / 2;
        end
    endfunction

    // Calculate number of levels for binary reduction from 51 elements to 1
    // Keep dividing by 2 until we reach 1
    function integer log2_ceil;
        input integer x;
        integer count;
        begin
            count = 0;
            while (x > 1) begin
                x = (x + 1) / 2;
                count = count + 1;
            end
            log2_ceil = count;
        end
    endfunction

    localparam LEVELS = log2_ceil(N_POP5);

    // Arrays of wires for each level:
    // level_counts[level] = number of sums at that level
    // The width of sums at level 'level' grows because max possible sum doubles approximately each level
    // At level 0: 3 bits (popcount5_outs)
    // At each next level, width increases by 1 bit to account for sum of two operands

    integer lvl;
    integer lvl_count [0:LEVELS];
    integer lvl_width [0:LEVELS];

    initial begin
        lvl_count[0] = N_POP5;
        lvl_width[0] = 3;
        for (lvl = 1; lvl <= LEVELS; lvl = lvl + 1) begin
            lvl_count[lvl] = div2_ceil(lvl_count[lvl-1]);
            // width grows by 1 because summing two n-bit numbers yields n+1 bits max
            lvl_width[lvl] = lvl_width[lvl-1] + 1;
        end
    end

    // Declare nets for all levels
    // Use packed arrays for clarity: sums_level[level][index]
    wire [7:0] sums_level [0:LEVELS][0:50]; // Max 51 sums at level 0, max needed size at other levels <= 51

    // Assign level 0 inputs from popcount5_outs, zero-extend from 3 to 8 bits
    generate
        for (i = 0; i < N_POP5; i = i + 1) begin : lvl0_assign
            assign sums_level[0][i] = { (8-3){1'b0} , popcount5_outs[i]};
        end
        // Fill unused entries at level 0 with zero
        for (i = N_POP5; i < 51; i = i + 1) begin : lvl0_pad
            assign sums_level[0][i] = 8'd0;
        end
    endgenerate

    // Generate sums for levels 1 to LEVELS
    genvar level_idx, idx;

    generate
        for (level_idx = 1; level_idx <= LEVELS; level_idx = level_idx + 1) begin : level_tree
            // Number of sums at previous level and current level
            localparam int prev_count = (level_idx == 1) ? N_POP5 : div2_ceil(lvl_count[level_idx-1]);
            localparam int curr_count = div2_ceil(lvl_count[level_idx]);
            localparam int curr_width = lvl_width[level_idx];
            // Actually we can't use lvl_count[]/lvl_width[] directly here since initial block sets them, but initial blocks
            // are ignored by synthesis and genvar requires constants.
            // So, re-compute inside generate with functions for synthesis compatibility.

            function integer get_prev_count;
                input integer l;
                integer c;
                begin
                    c = N_POP5;
                    while (l > 0) begin
                        c = div2_ceil(c);
                        l = l - 1;
                    end
                    get_prev_count = c;
                end
            endfunction

            function integer get_level_count;
                input integer l;
                begin
                    get_level_count = div2_ceil(get_prev_count(l-1));
                end
            endfunction

            function integer get_level_width;
                input integer l;
                begin
                    get_level_width = 3 + l; // each level adds 1 bit width starting at 3 bits at level 0
                end
            endfunction

            localparam int p_count = get_prev_count(level_idx-1);
            localparam int c_count = get_level_count(level_idx);
            localparam int c_width = get_level_width(level_idx);

            for (idx = 0; idx < c_count; idx = idx + 1) begin : sum_pairs
                localparam int i0 = idx*2;
                localparam int i1 = idx*2 + 1;

                wire [c_width-1:0] in0 = (i0 < p_count) ? sums_level[level_idx-1][i0][c_width-1:0] : {c_width{1'b0}};
                wire [c_width-1:0] in1 = (i1 < p_count) ? sums_level[level_idx-1][i1][c_width-1:0] : {c_width{1'b0}};
                assign sums_level[level_idx][idx] = in0 + in1;
            end
            // Pad unused sums_level entries at this level to zero
            for (idx = c_count; idx < 51; idx = idx + 1) begin : pad_unused
                assign sums_level[level_idx][idx] = {c_width{1'b0}};
            end
        end
    endgenerate

    // The final result is sums_level[LEVELS][0], must fit in 8 bits.
    // Assert that lvl_width[LEVELS] <= 8 for correctness.
    assign out = sums_level[LEVELS][0];

endmodule