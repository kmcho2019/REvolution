module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] min_out
);
    assign min_out = (x < y) ? x : y;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);
    localparam N = 4;
    localparam STAGES = $clog2(N);

    // Pack inputs into an array for indexed access
    wire [7:0] vals [0:N-1];
    assign vals[0] = a;
    assign vals[1] = b;
    assign vals[2] = c;
    assign vals[3] = d;

    // Declare wires for each stage with exact sizing to avoid over-provisioning
    // stage_sizes[stage] = ceil(N / 2^stage)
    function integer stage_size(input integer stage);
        stage_size = (N + (1 << stage) - 1) >> stage;
    endfunction

    // Declare wires for each stage
    // stage 0: inputs, stage STAGES: one output
    wire [7:0] stage_wires [0:STAGES-1] [0:stage_size(STAGES-1)-1];
    wire [7:0] last_stage_wire;

    genvar stage, idx;

    // Initialize stage 0 wires with inputs
    generate
        for (idx = 0; idx < N; idx = idx + 1) begin : init_stage0
            assign stage_wires[0][idx] = vals[idx];
        end
    endgenerate

    // Generate min2 tree for intermediate stages except last
    generate
        for (stage = 1; stage < STAGES; stage = stage + 1) begin : gen_stages
            localparam prev_size = stage_size(stage-1);
            localparam curr_size = stage_size(stage);

            for (idx = 0; idx < curr_size; idx = idx + 1) begin : gen_min2
                localparam left_idx  = 2*idx;
                localparam right_idx = 2*idx + 1;

                if (right_idx < prev_size) begin
                    min2 u_min2 (
                        .x(stage_wires[stage-1][left_idx]),
                        .y(stage_wires[stage-1][right_idx]),
                        .min_out(stage_wires[stage][idx])
                    );
                end else begin
                    // propagate if no pair
                    assign stage_wires[stage][idx] = stage_wires[stage-1][left_idx];
                end
            end
        end
    endgenerate

    // Final stage: reduce from last intermediate stage to one output
    // If STAGES=0 (N=1), assign directly; else do final min2 or propagate.
    generate
        if (STAGES == 0) begin
            assign min = vals[0];
        end else begin
            localparam last_stage_size = stage_size(STAGES - 1);

            if (last_stage_size == 1) begin
                // Only one element at last stage, assign directly
                assign min = stage_wires[STAGES-1][0];
            end else begin
                // Exactly two elements, one final min2
                min2 u_min_final (
                    .x(stage_wires[STAGES-1][0]),
                    .y(stage_wires[STAGES-1][1]),
                    .min_out(min)
                );
            end
        end
    endgenerate

endmodule