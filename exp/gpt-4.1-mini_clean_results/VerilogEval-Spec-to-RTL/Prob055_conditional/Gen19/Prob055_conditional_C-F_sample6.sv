module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] z
);
    assign z = (x < y) ? x : y;
endmodule

module TopModule #(
    parameter N = 4  // Number of inputs (fixed to 4 for this problem)
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

    // Number of reduction stages = ceil(log2(N))
    localparam int STAGES = (N > 1) ? $clog2(N) : 0;

    // Declare wire arrays sized exactly to needed elements per stage
    // stage_wires[stage] is array of wires [7:0] with size stage_size
    // Use generate loops to declare them.

    // Helper function to compute ceil division for indexing
    function automatic int ceil_div(input int x, input int y);
        ceil_div = (x + y - 1) / y;
    endfunction

    // Declare wire arrays for each stage:
    // Stage 0 size = N
    // Stage s size = ceil(stage_{s-1}_size / 2)
    // We'll store sizes in a localparam array for clarity
    localparam int stage_sizes [0:STAGES] = '{
        N,
        (STAGES >= 1) ? ceil_div(N, 2) : 0,
        (STAGES >= 2) ? ceil_div(stage_sizes[1], 2) : 0,
        (STAGES >= 3) ? ceil_div(stage_sizes[2], 2) : 0,
        (STAGES >= 4) ? ceil_div(stage_sizes[3], 2) : 0
    };

    // Since N=4 and STAGES=2, only stage_sizes[0..2] used.

    // Use generate to declare wires for each stage except stage 0 (vals)
    // Verilog does not support array of arrays as ports directly,
    // so use a hierarchical generate to declare per-stage wires.

    // Stage wires declarations
    // Use packed arrays only per stage sized exactly
    genvar stage, idx;

    // Stage 0 is vals, already declared

    // Declare stage wires for stage 1 to STAGES
    // We cannot use dynamic arrays in Verilog easily, so unroll with generate

    // Stage 1 wires
    wire [7:0] stage1_wires [0:ceil_div(N,2)-1];

    // Stage 2 wires (if STAGES >= 2)
    generate
        if (STAGES >= 2) begin
            wire [7:0] stage2_wires [0:ceil_div(ceil_div(N,2),2)-1];
            // The last stage wire for output assignment:
            // We will assign min = stage2_wires[0];
        end
    endgenerate

    // Because Verilog doesn't allow declaration inside generate to affect outside scope,
    // we declare all stage wires before and use conditional assignments.

    // Declare all possible stage wires needed (up to STAGES=4 max for safety)
    // For N=4, only stage1 and stage2 used.

    wire [7:0] stage2_wires [0:ceil_div(ceil_div(N,2),2)-1];

    // Generate assignments for stage 1 wires
    generate
        for (idx = 0; idx < ceil_div(N, 2); idx = idx + 1) begin : gen_stage1
            localparam int left_idx  = 2*idx;
            localparam int right_idx = 2*idx + 1;
            if (right_idx < N) begin
                min2 u_min2_stage1 (
                    .x(vals[left_idx]),
                    .y(vals[right_idx]),
                    .z(stage1_wires[idx])
                );
            end else begin
                // If no right input (odd count), propagate left input
                assign stage1_wires[idx] = vals[left_idx];
            end
        end
    endgenerate

    // Generate assignments for stage 2 wires
    generate
        if (STAGES >= 2) begin
            for (idx = 0; idx < ceil_div(ceil_div(N,2), 2); idx = idx + 1) begin : gen_stage2
                localparam int left_idx  = 2*idx;
                localparam int right_idx = 2*idx + 1;
                if (right_idx < ceil_div(N, 2)) begin
                    min2 u_min2_stage2 (
                        .x(stage1_wires[left_idx]),
                        .y(stage1_wires[right_idx]),
                        .z(stage2_wires[idx])
                    );
                end else begin
                    assign stage2_wires[idx] = stage1_wires[left_idx];
                end
            end
        end
    endgenerate

    // Final output is stage2_wires[0] if STAGES >= 2, else if STAGES==1, stage1_wires[0], else vals[0]
    generate
        if (STAGES >= 2) begin
            assign min = stage2_wires[0];
        end else if (STAGES == 1) begin
            assign min = stage1_wires[0];
        end else begin
            assign min = vals[0];
        end
    endgenerate

endmodule