module popcount5 (
    input  [4:0] in,
    output [2:0] out // max 5 ones, needs 3 bits
);
    // Explicit combinational sum of 5 bits
    wire [2:0] sum4 = in[3] + in[2] + in[1] + in[0];
    wire       bit4 = in[4];
    assign out = sum4 + bit4;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Parameters
    localparam N_GROUPS = 51;    // Number of 5-bit groups in 255 bits
    localparam GROUP_SIZE = 5;

    // Stage 1: popcount5 instances on 5-bit chunks
    wire [2:0] pop5_counts [N_GROUPS-1:0];

    genvar i;
    generate
        for (i = 0; i < N_GROUPS; i = i + 1) begin : pop5_block
            popcount5 pc5 (
                .in(in[i*GROUP_SIZE +: GROUP_SIZE]),
                .out(pop5_counts[i])
            );
        end
    endgenerate

    // Stage 2: Sum every 3 popcount5 outputs into 7-bit sums (max 3*5=15 < 7 bits)
    // Number of groups at this stage: ceil(51/3) = 17
    localparam S2_GROUPS = 17;
    wire [6:0] stage2_sums [S2_GROUPS-1:0]; // 7 bits to hold up to 15

    generate
        for (i = 0; i < S2_GROUPS; i = i + 1) begin : stage2_block
            // Indices of the 3 popcount5 outputs to sum
            wire [2:0] c0 = pop5_counts[i*3 + 0];
            wire [2:0] c1 = (i*3+1 < N_GROUPS) ? pop5_counts[i*3 + 1] : 3'b000;
            wire [2:0] c2 = (i*3+2 < N_GROUPS) ? pop5_counts[i*3 + 2] : 3'b000;

            // Sum three 3-bit values: max 15 (4 bits max needed but we use 7 bits for ease)
            wire [6:0] sum01 = c0 + c1;
            assign stage2_sums[i] = sum01 + c2;
        end
    endgenerate

    // Stage 3: Sum the 17 stage2_sums into final 8-bit out (max 51 * 5 = 255 < 8 bits)
    // We'll build a balanced adder tree summing 3 inputs at a time where possible.

    // Function to calculate next stage width and size for tree sums
    function integer ceil_div3;
        input integer x; begin
            ceil_div3 = (x + 2) / 3;
        end
    endfunction

    // Calculate number of levels needed (log base 3)
    function integer log3_ceil;
        input integer x;
        integer v;
        begin
            v = 1;
            log3_ceil = 0;
            while (v < x) begin
                v = v * 3;
                log3_ceil = log3_ceil + 1;
            end
        end
    endfunction

    localparam LEVELS = log3_ceil(S2_GROUPS);

    // We'll use a generate block to build the tree iteratively:
    // sums_level[level][index] is the sum at given level and index
    // Level 0 inputs are stage2_sums
    // Each sum is 8 bits wide (max 255)
    localparam WIDTH = 8;

    // Declare arrays of wires for sums at each level
    // Maximum number of sums at level 0 is S2_GROUPS=17, subsequent levels shrink by factor 3
    // We'll build arrays big enough for each level.

    // max sums at each level:
    // Level 0: 17 sums (inputs)
    // Level 1: ceil(17/3)=6 sums
    // Level 2: ceil(6/3)=2 sums
    // Level 3: ceil(2/3)=1 sum (final output)

    // For simplicity, declare max size 17 for all levels, unused entries tied to zero
    wire [WIDTH-1:0] sums_level [0:LEVELS][0:16]; 

    // Assign inputs at level 0
    generate
        for (i = 0; i < S2_GROUPS; i = i + 1) begin : level0_input
            assign sums_level[0][i] = stage2_sums[i];
        end
        // Pad unused with zero
        for (i = S2_GROUPS; i < 17; i = i + 1) begin : level0_pad
            assign sums_level[0][i] = {WIDTH{1'b0}};
        end
    endgenerate

    genvar lvl, idx;
    generate
        for (lvl = 1; lvl <= LEVELS; lvl = lvl + 1) begin : tree_levels
            localparam integer prev_count = (lvl == 1) ? S2_GROUPS : (( ( ( (lvl == 2) ? ceil_div3(S2_GROUPS) : 0 ) > 0) ? ceil_div3(S2_GROUPS) : 0)); 
            localparam integer prev_count_fixed = (lvl == 1) ? S2_GROUPS : (( (lvl == 2) ? ceil_div3(S2_GROUPS) : 0));
            localparam integer prev_level_count = (lvl == 1) ? S2_GROUPS : ((lvl == 2) ? ceil_div3(S2_GROUPS) : 0);

            // But we can't use localparam with genvar inside generate, so define counts manually
            // So, we'll hardcode counts per level to simplify:

            // Level 1: input count = 17, outputs = 6
            // Level 2: input count = 6, outputs = 2
            // Level 3: input count = 2, outputs = 1

            localparam integer in_count = (lvl == 1) ? 17 :
                                          (lvl == 2) ? 6  :
                                          (lvl == 3) ? 2  : 1;
            localparam integer out_count = ceil_div3(in_count);

            for (idx = 0; idx < out_count; idx = idx + 1) begin : sum3
                // Indices of three inputs to sum from previous level
                localparam integer idx0 = idx*3 + 0;
                localparam integer idx1 = idx*3 + 1;
                localparam integer idx2 = idx*3 + 2;

                wire [WIDTH-1:0] in0 = (idx0 < in_count) ? sums_level[lvl-1][idx0] : {WIDTH{1'b0}};
                wire [WIDTH-1:0] in1 = (idx1 < in_count) ? sums_level[lvl-1][idx1] : {WIDTH{1'b0}};
                wire [WIDTH-1:0] in2 = (idx2 < in_count) ? sums_level[lvl-1][idx2] : {WIDTH{1'b0}};

                assign sums_level[lvl][idx] = in0 + in1 + in2;
            end
            // Pad unused outputs with zero
            for (idx = out_count; idx < 17; idx = idx + 1) begin : pad_unused
                assign sums_level[lvl][idx] = {WIDTH{1'b0}};
            end
        end
    endgenerate

    // Final output is sums_level[LEVELS][0]
    assign out = sums_level[LEVELS][0];

endmodule