module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Parameters for grouping
    localparam GROUP_SIZE = 10;
    localparam NUM_GROUPS = 100 / GROUP_SIZE;  // 10 groups

    // First-level partial reductions using reduction operators on 10-bit slices
    wire [NUM_GROUPS-1:0] and_part;
    wire [NUM_GROUPS-1:0] or_part;
    wire [NUM_GROUPS-1:0] xor_part;

    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : partial_reduction
            assign and_part[i] = &in[i*GROUP_SIZE +: GROUP_SIZE];
            assign or_part[i]  = |in[i*GROUP_SIZE +: GROUP_SIZE];
            assign xor_part[i] = ^in[i*GROUP_SIZE +: GROUP_SIZE];
        end
    endgenerate

    // Now iteratively reduce these partial signals until one output remains for each function
    // We use a variable-length array and reduce in stages by combining pairs

    // Maximum number of stages needed = ceil(log2(NUM_GROUPS))
    localparam MAX_STAGES = 4; // since 2^4 = 16 > 10

    // Declare arrays to hold intermediate reduction results for each stage
    // Each stage will have half the number of signals (rounded up) of the previous stage
    wire [NUM_GROUPS-1:0] and_stage [0:MAX_STAGES];
    wire [NUM_GROUPS-1:0] or_stage  [0:MAX_STAGES];
    wire [NUM_GROUPS-1:0] xor_stage [0:MAX_STAGES];

    // Stage 0 is the first-level partial signals
    assign and_stage[0] = and_part;
    assign or_stage[0]  = or_part;
    assign xor_stage[0] = xor_part;

    integer stage, idx;
    // Generate loop for iterative reduction stages
    generate
        for (stage = 0; stage < MAX_STAGES; stage = stage + 1) begin : reduce_stages
            // Number of elements in next stage (rounded up)
            localparam int NEXT_NUM = (NUM_GROUPS + (1 << stage) - 1) >> (stage + 1);
            for (idx = 0; idx < NEXT_NUM; idx = idx + 1) begin : combine_pairs
                // Calculate index of first and second element to combine in current stage
                localparam int first_idx = idx * 2;
                localparam int second_idx = idx * 2 + 1;

                // Combine AND: if second_idx exists, AND both, else propagate first_idx
                if (second_idx < (NUM_GROUPS >> stage)) begin
                    assign and_stage[stage+1][idx] = and_stage[stage][first_idx] & and_stage[stage][second_idx];
                    assign or_stage[stage+1][idx]  = or_stage[stage][first_idx]  | or_stage[stage][second_idx];
                    assign xor_stage[stage+1][idx] = xor_stage[stage][first_idx] ^ xor_stage[stage][second_idx];
                end else begin
                    assign and_stage[stage+1][idx] = and_stage[stage][first_idx];
                    assign or_stage[stage+1][idx]  = or_stage[stage][first_idx];
                    assign xor_stage[stage+1][idx] = xor_stage[stage][first_idx];
                end
            end
        end
    endgenerate

    // Final outputs: the single remaining signal at last valid stage
    // Calculate number of valid elements per stage, stop when 1 element remains
    // We'll pick outputs from the stage where number of elements is 1

    // Compute stage output selector
    // Since NUM_GROUPS=10, reduction goes as: 10->5->3->2->1
    // Last stage index is 4 with 1 element
    assign out_and = and_stage[MAX_STAGES][0];
    assign out_or  = or_stage[MAX_STAGES][0];
    assign out_xor = xor_stage[MAX_STAGES][0];

endmodule