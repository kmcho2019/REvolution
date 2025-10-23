module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Number of inputs
    localparam N = 100;

    // Calculate number of stages needed in balanced binary tree
    // ceil(log2(N)) = 7
    localparam STAGES = 7;

    // We'll build balanced reduction trees for AND, OR, XOR.
    // At each stage, we combine pairs of signals from previous stage
    // If number of signals is odd, pass the last signal through unchanged.

    // Stage 0 arrays: each bit of input as a separate wire for each logic type
    wire [N-1:0] and_stage [0:STAGES];
    wire [N-1:0] or_stage  [0:STAGES];
    wire [N-1:0] xor_stage [0:STAGES];

    genvar i, stage;

    // Initialize stage 0 with direct input bits
    generate
        for (i = 0; i < N; i = i + 1) begin : init_stage0
            assign and_stage[0][i] = in[i];
            assign or_stage[0][i]  = in[i];
            assign xor_stage[0][i] = in[i];
        end
    endgenerate

    // Iteratively reduce at each stage by combining pairs of signals
    generate
        for (stage = 1; stage <= STAGES; stage = stage + 1) begin : stages_loop
            localparam int prev_count = (N + (1 << (stage - 1)) - 1) >> (stage - 1);
            localparam int curr_count = (prev_count + 1) >> 1;

            for (i = 0; i < curr_count; i = i + 1) begin : pair_combine
                // Calculate indices of the pair to combine from previous stage
                localparam int left_idx  = 2*i;
                localparam int right_idx = 2*i + 1;

                // If right index exists, combine pair; else pass left signal through
                if (right_idx < prev_count) begin
                    assign and_stage[stage][i] = and_stage[stage-1][left_idx] & and_stage[stage-1][right_idx];
                    assign or_stage[stage][i]  = or_stage[stage-1][left_idx] | or_stage[stage-1][right_idx];
                    assign xor_stage[stage][i] = xor_stage[stage-1][left_idx] ^ xor_stage[stage-1][right_idx];
                end else begin
                    assign and_stage[stage][i] = and_stage[stage-1][left_idx];
                    assign or_stage[stage][i]  = or_stage[stage-1][left_idx];
                    assign xor_stage[stage][i] = xor_stage[stage-1][left_idx];
                end
            end

            // For remaining unused bits in current stage arrays (if any), tie off to zero
            for (i = curr_count; i < N; i = i + 1) begin : fill_unused
                assign and_stage[stage][i] = 1'b1;  // neutral for AND
                assign or_stage[stage][i]  = 1'b0;  // neutral for OR
                assign xor_stage[stage][i] = 1'b0;  // neutral for XOR
            end
        end
    endgenerate

    // The final result is at stage STAGES, index 0
    assign out_and = and_stage[STAGES][0];
    assign out_or  = or_stage[STAGES][0];
    assign out_xor = xor_stage[STAGES][0];

endmodule