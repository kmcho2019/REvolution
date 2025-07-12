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
    localparam N_GROUPS = 51;
    localparam GROUP_SIZE = 5;

    // Stage 1: popcount5 instances on 5-bit chunks
    wire [2:0] pop5_counts [0:N_GROUPS-1];

    genvar i;
    generate
        for (i = 0; i < N_GROUPS; i = i + 1) begin : pop5_block
            popcount5 pc5 (
                .in(in[i*GROUP_SIZE +: GROUP_SIZE]),
                .out(pop5_counts[i])
            );
        end
    endgenerate

    // Binary tree summation of pop5_counts to get final out
    // First, sum pairs of popcount5 outputs to reduce from 51 to 26 sums:
    //   25 pairs + 1 leftover (51 is odd)
    // Each popcount5 is 3 bits max 5, so sum of pair max 10 needs 4 bits.

    localparam stage1_pairs = N_GROUPS / 2;    // 25 pairs
    localparam stage1_leftover = N_GROUPS % 2; // 1 leftover

    wire [3:0] stage1_sums [0:stage1_pairs-1]; // 4-bit sums of pairs
    wire [3:0] stage1_leftover_val; // leftover count zero-extended to 4 bits

    generate
        for (i = 0; i < stage1_pairs; i = i + 1) begin : stage1_sum_pairs
            assign stage1_sums[i] = pop5_counts[2*i] + pop5_counts[2*i+1];
        end
    endgenerate

    // Assign leftover or zero if none
    assign stage1_leftover_val = stage1_leftover ? {1'b0, pop5_counts[N_GROUPS-1]} : 4'd0;

    // Stage 2: sum stage1 sums + leftover => total stage2 inputs = 26 (25 +1)
    // Sum pairs again to reduce from 26 to 13 sums:
    // Each sum is 4 bits max 10, sum of pair max 20 needs 5 bits

    localparam stage2_inputs = stage1_pairs + stage1_leftover; // 26
    localparam stage2_pairs = stage2_inputs / 2; // 13
    localparam stage2_leftover = stage2_inputs % 2; // 0, since 26 even

    wire [4:0] stage2_sums [0:stage2_pairs-1]; // 5-bit sums
    // Build stage2 inputs array to sum pairs:
    wire [3:0] stage2_inputs_arr [0:stage2_inputs-1];
    generate
        for (i = 0; i < stage1_pairs; i = i + 1) begin : stage2_input_from_stage1
            assign stage2_inputs_arr[i] = stage1_sums[i];
        end
        if (stage1_leftover) begin : stage2_input_leftover
            assign stage2_inputs_arr[stage1_pairs] = stage1_leftover_val;
        end
    endgenerate

    generate
        for (i = 0; i < stage2_pairs; i = i + 1) begin : stage2_sum_pairs
            assign stage2_sums[i] = stage2_inputs_arr[2*i] + stage2_inputs_arr[2*i+1];
        end
    endgenerate

    // Stage 3: sum 13 sums (5-bit each) to final output
    // We'll use a simple binary tree for sums:
    // We can proceed recursively by summing pairs, zero-padding last if odd.

    // Function for ceiling division by 2
    function integer ceil_div2;
        input integer x; begin
            ceil_div2 = (x + 1) / 2;
        end
    endfunction

    // Define arrays for stages of sums, max needed depth is log2(13) ~=4
    // Width increases by 1 bit per addition (worst case)
    // Start width = 5 (stage2_sums)
    // Max width = 8 bits is enough (max 255 total count)

    localparam int max_depth = 4;
    // Declare reg arrays for summation tree wires
    wire [7:0] sum_tree [0:max_depth][0:12]; // maximum 13 inputs at stage2, pad with zeros

    // Assign stage 3 inputs (level 0)
    genvar idx;
    generate
        for (idx = 0; idx < stage2_pairs; idx = idx + 1) begin : sum_tree_level0
            assign sum_tree[0][idx] = {3'b0, stage2_sums[idx]}; // zero extend 5 to 8 bits
        end
        // Pad unused entries with zeros
        for (idx = stage2_pairs; idx < 13; idx = idx +1) begin : sum_tree_level0_pad
            assign sum_tree[0][idx] = 8'd0;
        end
    endgenerate

    // Iteratively build the binary tree sums:
    // At each level n, number of inputs = ceil_div2(inputs at level n-1)

    generate
        for (genvar level = 1; level <= max_depth; level = level + 1) begin : tree_levels
            // Compute number of inputs at previous level
            localparam int prev_count = (level == 1) ? 13 : ceil_div2(ceil_div2(ceil_div2(ceil_div2(13))));
            // Instead, compute dynamically using a loop:
            integer in_count_prev;
            initial begin
                in_count_prev = 13;
                integer l;
                for (l = 1; l < level; l = l + 1)
                    in_count_prev = ceil_div2(in_count_prev);
            end

            // Number of sums at this level:
            integer out_count;
            initial begin
                out_count = ceil_div2(in_count_prev);
            end

            // Because Verilog generate doesn't allow dynamic loops, hardcode counts:
            // level=1: inputs=13 outputs=7
            // level=2: inputs=7 outputs=4
            // level=3: inputs=4 outputs=2
            // level=4: inputs=2 outputs=1

            localparam int in_count = (level == 1) ? 13 :
                                     (level == 2) ? 7  :
                                     (level == 3) ? 4  :
                                     (level == 4) ? 2  : 1;
            localparam int out_count = ceil_div2(in_count);

            for (idx = 0; idx < out_count; idx = idx + 1) begin : sum_pairs
                localparam int idx0 = idx*2;
                localparam int idx1 = idx*2 + 1;
                wire [7:0] in0 = (idx0 < in_count) ? sum_tree[level-1][idx0] : 8'd0;
                wire [7:0] in1 = (idx1 < in_count) ? sum_tree[level-1][idx1] : 8'd0;
                assign sum_tree[level][idx] = in0 + in1;
            end
            // Pad remaining sums if any (for idx >= out_count) with zero
            for (idx = out_count; idx < 13; idx = idx + 1) begin : pad_sums
                assign sum_tree[level][idx] = 8'd0;
            end
        end
    endgenerate

    // Final output is sum_tree[max_depth][0]
    assign out = sum_tree[max_depth][0];

endmodule