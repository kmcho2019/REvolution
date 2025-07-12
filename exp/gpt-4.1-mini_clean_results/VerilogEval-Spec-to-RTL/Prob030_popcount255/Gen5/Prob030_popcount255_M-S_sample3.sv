module popcount5 (
    input  [4:0] in,
    output [2:0] out // max 5 ones, needs 3 bits
);
    // Sum the 5 bits combinationally
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

    wire [2:0] partial_counts [0:N_GROUPS-1];

    genvar i;
    generate
        for (i = 0; i < N_GROUPS; i = i + 1) begin : pc5_blocks
            popcount5 pc5_inst (
                .in(in[i*GROUP_SIZE +: GROUP_SIZE]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Binary tree summation of partial_counts zero-extended to 8 bits
    // We'll iteratively sum pairs until one sum remains
    // Number of elements at current level, initial = 51
    // Use generate loops unrolled in a function-like iterative approach

    // Declare a 2D array for stages; max stages needed = ceil(log2(51))=6
    // Each sum is 8 bits wide (max total count 255 fits in 8 bits)
    localparam MAX_STAGE = 6;
    localparam WIDTH = 8;

    // Declare wires for each stage; max elements at stage0 = 51, each next stage approx half
    // For simplicity, max size 51 at all stages; unused entries zero-padded
    wire [WIDTH-1:0] sums [0:MAX_STAGE][0:50];

    // Assign level 0: zero-extend partial counts to 8 bits
    generate
        for (i = 0; i < N_GROUPS; i = i + 1) begin : stage0_assign
            assign sums[0][i] = {5'b0, partial_counts[i]}; // extend 3 bits to 8 bits
        end
        for (i = N_GROUPS; i < 51; i = i + 1) begin : stage0_pad
            assign sums[0][i] = 8'b0;
        end
    endgenerate

    // Iteratively build sums for next stages by summing pairs
    genvar stage, idx;
    generate
        for (stage = 1; stage <= MAX_STAGE; stage = stage + 1) begin : sum_stages
            localparam int prev_count = (stage == 1) ? 51 : (( ( ( (MAX_STAGE+1-stage) > 0) ? ( ( (51 + (1 << (MAX_STAGE - (stage-1))) ) >> (MAX_STAGE - (stage-1)) ) ) : 0));
            // Instead of complex formula, precompute number of elements at each stage:
            // stage 0: 51
            // stage 1: ceil(51/2)=26
            // stage 2: ceil(26/2)=13
            // stage 3: ceil(13/2)=7
            // stage 4: ceil(7/2)=4
            // stage 5: ceil(4/2)=2
            // stage 6: ceil(2/2)=1

            // Use a function for element count at each stage
            function automatic int elems_at_stage(input int stg);
                int n;
                begin
                    n = 51;
                    for (int s = 1; s <= stg; s = s + 1) begin
                        n = (n + 1) >> 1; // ceil division by 2
                    end
                    elems_at_stage = n;
                end
            endfunction

            localparam int prev_stage_count = elems_at_stage(stage-1);
            localparam int curr_stage_count = elems_at_stage(stage);

            for (idx = 0; idx < curr_stage_count; idx = idx + 1) begin : sum_pairs
                wire [WIDTH-1:0] in0 = sums[stage-1][idx*2];
                wire [WIDTH-1:0] in1 = (idx*2+1 < prev_stage_count) ? sums[stage-1][idx*2+1] : {WIDTH{1'b0}};
                assign sums[stage][idx] = in0 + in1;
            end
            for (idx = curr_stage_count; idx < 51; idx = idx + 1) begin : pad_unused
                assign sums[stage][idx] = {WIDTH{1'b0}};
            end
        end
    endgenerate

    // Final output is sums[MAX_STAGE][0]
    assign out = sums[MAX_STAGE][0];

endmodule