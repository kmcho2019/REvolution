module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] z
);
    assign z = (x < y) ? x : y;
endmodule

module TopModule #(
    parameter N = 4  // Number of inputs; fixed to 4 for this problem
)(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);
    // Pack inputs into an array for indexed access
    wire [7:0] vals [0:N-1];
    assign vals[0] = a;
    assign vals[1] = b;
    assign vals[2] = c;
    assign vals[3] = d;

    // Calculate number of stages needed for a balanced min tree
    // For N=4 inputs, number of stages = ceil(log2(N)) = 2
    localparam STAGES = (N>1) ? ($clog2(N)) : 0;

    // Stage wire arrays: stage_wires[stage][index]
    // Stage 0: inputs = vals
    // Next stages halve number of elements until 1 element remains at final stage

    // Max size needed is N, so declare array of arrays:
    wire [7:0] stage_wires [0:STAGES][0:N-1];

    // Initialize stage 0 with inputs
    genvar i;
    generate
        for (i = 0; i < N; i = i +1) begin : init_stage0
            assign stage_wires[0][i] = vals[i];
        end
    endgenerate

    // Build reduction tree stages using min2 modules
    genvar stage, idx;
    generate
        for (stage = 1; stage <= STAGES; stage = stage + 1) begin : stages_loop
            localparam int stage_size = (N + (1 << stage) - 1) >> stage; // ceil(N/2^stage)

            for (idx = 0; idx < stage_size; idx = idx + 1) begin : min2_instances
                // Inputs to min2 are two elements from previous stage:
                // If odd number of elements, last element propagates unchanged (no pair to compare)
                localparam int left_idx  = 2*idx;
                localparam int right_idx = 2*idx + 1;

                if (right_idx < (N + (1 << (stage-1)) - 1) >> (stage-1)) begin
                    // Two valid inputs: instantiate min2
                    min2 u_min2 (
                        .x(stage_wires[stage-1][left_idx]),
                        .y(stage_wires[stage-1][right_idx]),
                        .z(stage_wires[stage][idx])
                    );
                end else begin
                    // Only one input left: propagate it forward without comparison
                    assign stage_wires[stage][idx] = stage_wires[stage-1][left_idx];
                end
            end
        end
    endgenerate

    // Output final min from last stage, which has single element
    assign min = stage_wires[STAGES][0];

endmodule