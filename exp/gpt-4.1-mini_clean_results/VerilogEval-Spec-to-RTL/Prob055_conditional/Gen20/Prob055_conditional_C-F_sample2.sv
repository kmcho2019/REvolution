module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] min_out
);
    assign min_out = (x < y) ? x : y;
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

    // Calculate number of stages = ceil(log2(N))
    localparam STAGES = (N > 1) ? $clog2(N) : 0;

    // Declare stage wire arrays dynamically sized per stage to minimize area
    // stage_sizes[stage] = number of elements at that stage
    // stage 0 size = N
    // stage i size = ceil(stage_sizes[i-1]/2)
    // We generate a localparam array to hold sizes
    localparam integer stage_sizes [0:STAGES] = gen_stage_sizes(N, STAGES);

    // Function to compute stage sizes recursively (function outside module scope not allowed,
    // So implement locally using generate)
    // We will emulate it by a generate block that declares localparams per stage

    // Declare wires per stage with minimal widths
    // Using generate block with named genvars
    // wires per stage
    // stage_wires[stage][index]
    // Cannot declare multi-dimensional wire arrays with variable dimensions,
    // So we declare separate wire arrays per stage with fixed sizes.

    // Stage 0 wires: inputs already in vals[]

    // Stage 1 wires
    wire [7:0] stage1 [0:((N + 1) / 2) -1];
    // Stage 2 wires if needed
    generate
        if (STAGES > 1) begin
            wire [7:0] stage2 [0:(( ( (N + 1) / 2) +1 ) / 2) -1];
        end
    endgenerate

    // Because dynamic multidimensional arrays and variable localparams are tricky in Verilog,
    // we implement a fully general structure using generate loops with local variables.
    // Since N=4 is fixed, we can declare wires stage1 and stage2 explicitly.

    // For general parameterization, a more complex approach or SystemVerilog is needed,
    // but here we optimize for N=4.

    // Implement combinational min tree:

    // Stage 1: Compare pairs from vals
    min2 min_ab(.x(vals[0]), .y(vals[1]), .min_out(stage1[0]));
    min2 min_cd(.x(vals[2]), .y(vals[3]), .min_out(stage1[1]));

    // Stage 2: Compare stage1 outputs
    min2 min_final(.x(stage1[0]), .y(stage1[1]), .min_out(min));

endmodule