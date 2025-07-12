module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    // Pack inputs into array for indexed access
    wire [15:0] inputs_arr [0:8];
    assign inputs_arr[0] = a;
    assign inputs_arr[1] = b;
    assign inputs_arr[2] = c;
    assign inputs_arr[3] = d;
    assign inputs_arr[4] = e;
    assign inputs_arr[5] = f;
    assign inputs_arr[6] = g;
    assign inputs_arr[7] = h;
    assign inputs_arr[8] = i;

    // Parameterized 2-to-1 mux for 16-bit buses
    // Used to build the mux tree
    module mux2to1_16 (
        input  [15:0] in0,
        input  [15:0] in1,
        input         sel,
        output [15:0] out
    );
        assign out = sel ? in1 : in0;
    endmodule

    // Generate balanced mux tree for 9 inputs
    // Pad inputs to 16 for power-of-2 size, extra inputs tied to 16'hFFFF (per spec)
    localparam WIDTH = 16;
    localparam NINPUTS = 9;
    localparam FULL_SIZE = 16; // next power of two >= 9

    // Create padded input array with all ones for positions [9..15]
    wire [WIDTH-1:0] padded_inputs [0:FULL_SIZE-1];
    genvar idx;
    generate
        for (idx=0; idx < NINPUTS; idx=idx+1) begin : input_pad_assign
            assign padded_inputs[idx] = inputs_arr[idx];
        end
        for (idx=NINPUTS; idx < FULL_SIZE; idx=idx+1) begin : input_pad_ones
            assign padded_inputs[idx] = 16'hFFFF;
        end
    endgenerate

    // Calculate depth of mux tree: log2(FULL_SIZE) = 4
    // We'll build the mux tree iteratively in arrays of wires
    // level 0 = inputs, level 4 = single output

    // Array of mux outputs at each level: max 8 muxes (FULL_SIZE/2 at level 1)
    // Because we can't dynamically size in Verilog-2001, we use a fixed dimension
    // We'll build 5 levels: 0 (inputs), 1..4 (mux outputs)
    // Each level has HALF the number of nodes of previous level

    wire [WIDTH-1:0] mux_level [0:4][0:FULL_SIZE/2 -1];

    // Level 0: input assignments from padded_inputs
    // Already assigned: padded_inputs

    // Build mux tree levels 1 to 4
    genvar level, pair;
    generate
        for (level=1; level<=4; level=level+1) begin : levels
            localparam int prev_level_size = FULL_SIZE >> (level - 1);
            localparam int curr_level_size = prev_level_size >> 1;
            for (pair=0; pair < curr_level_size; pair=pair+1) begin : pairs
                wire sel_bit = sel[level-1]; // sel[0] for level 1 muxes, etc.

                // Inputs for this mux: from previous level outputs (or inputs for level 1)
                wire [WIDTH-1:0] in0;
                wire [WIDTH-1:0] in1;

                if (level == 1) begin
                    assign in0 = padded_inputs[2*pair];
                    assign in1 = padded_inputs[2*pair+1];
                end else begin
                    assign in0 = mux_level[level-1][2*pair];
                    assign in1 = mux_level[level-1][2*pair+1];
                end

                // Instantiate mux2to1_16 for this pair
                mux2to1_16 mux_inst (
                    .in0(in0),
                    .in1(in1),
                    .sel(sel_bit),
                    .out(mux_level[level][pair])
                );
            end
        end
    endgenerate

    // Final output mux: mux_level[4][0] is the muxed output of 16 inputs (including padded ones)
    // But only inputs 0..8 are valid; padded inputs are set to 16'hFFFF, so output for sel>=9 is automatically 16'hFFFF or a padded input.

    // However, we must handle sel >=9 -> out=16'hFFFF explicitly per spec
    // Since padded inputs have 16'hFFFF at positions >=9, the mux tree will output the correct value if sel is 0..15
    // But per spec, only sel 0..8 map to inputs; sel 9..15 should output 16'hFFFF (all ones)
    // So simply check sel range and override output if needed

    wire [WIDTH-1:0] muxed_out = mux_level[4][0];

    assign out = (sel <= 4'd8) ? muxed_out : 16'hFFFF;

endmodule