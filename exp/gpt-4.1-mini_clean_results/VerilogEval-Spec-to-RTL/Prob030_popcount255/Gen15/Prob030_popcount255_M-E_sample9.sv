module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits (structural)
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out // max count 7 fits in 3 bits but keep 4 bits for uniformity
);
    // Zero-pad to 8 bits to reuse popcount8 logic
    wire [7:0] padded_in = {1'b0, in};
    popcount8 pc8 (
        .in(padded_in),
        .out(out)
    );
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Constants
    localparam NUM_GROUPS = 32; // 31 groups of 8 bits + 1 group of 7 bits

    // Partial counts per group
    wire [3:0] partial_counts [0:NUM_GROUPS-1];

    genvar gi;
    generate
        for (gi = 0; gi < NUM_GROUPS-1; gi = gi + 1) begin : gen_pop8
            popcount8 pc8_inst (
                .in(in[8*gi +: 8]),
                .out(partial_counts[gi])
            );
        end
        // Last group of 7 bits
        popcount7 pc7_inst (
            .in(in[8*(NUM_GROUPS-1) +: 7]),
            .out(partial_counts[NUM_GROUPS-1])
        );
    endgenerate

    // Now sum all 32 partial counts (each 4 bits) using a balanced binary adder tree
    // At each stage, sum pairs of partial sums; if odd number, pass last one through

    // Define parameterized module to sum arbitrary arrays of 4-bit values
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    // Max sum after summing N partial counts of max 8 each is N*8
    // partial_counts are 4 bits, max 8. Summing 32 groups max 32*8=256 fits in 8 bits.

    // Define widths for sums at each level, max width increases as sums grow.
    // At base level sums are 4 bits, next level sums need 5 bits, etc.
    // The max sum = 256, needs 9 bits, but 8 bits suffice as max 255 from input size.
    // To be safe, output is 8 bits.

    // We'll implement the adder tree in a generate loop:
    // Create arrays of wires for sums at each stage.

    // Max levels needed: ceil(log2(32)) = 5

    // Stage 0 input is partial_counts[0..31] (4 bits each)
    // Stage 1 sums pairs -> 16 sums (max width 5 bits)
    // Stage 2 sums pairs -> 8 sums (max width 6 bits)
    // Stage 3 sums pairs -> 4 sums (max width 7 bits)
    // Stage 4 sums pairs -> 2 sums (max width 8 bits)
    // Stage 5 sums pairs -> 1 sum  (max width 8 bits)

    // We'll define wire arrays for each stage, dynamically sized.

    // Declare intermediate wires

    // Base level width is 4
    wire [3:0] level0 [NUM_GROUPS-1:0];
    genvar idx;
    generate
        for (idx = 0; idx < NUM_GROUPS; idx = idx + 1) begin
            assign level0[idx] = partial_counts[idx];
        end
    endgenerate

    // Generate a parameterized module for summing two inputs of parameter WIDTH_A and WIDTH_B producing width=max+1

    function integer max2;
        input integer a,b;
        begin
            max2 = (a > b) ? a : b;
        end
    endfunction

    // Using generate loops and arrays for each stage:
    // We will define a macro to create level wires with calculated width and count

    // For each stage:
    // inputs_count = previous_stage_count
    // outputs_count = (inputs_count +1)/2
    // input_width = previous_width
    // output_width = input_width + 1 (since summing two inputs)

    // We'll unroll manually for 5 stages since fixed size

    // Level 1
    localparam integer L1_COUNT = (NUM_GROUPS + 1) / 2; // 16
    localparam integer L1_WIDTH = 5; // 4+1

    wire [L1_WIDTH-1:0] level1 [L1_COUNT-1:0];
    genvar i1;
    generate
        for (i1 = 0; i1 < L1_COUNT; i1 = i1 + 1) begin : gen_l1
            if ((2*i1+1) < NUM_GROUPS) begin
                assign level1[i1] = level0[2*i1] + level0[2*i1+1];
            end else begin
                // Odd count, pass through last
                assign level1[i1] = {{(L1_WIDTH-4){1'b0}}, level0[2*i1]};
            end
        end
    endgenerate

    // Level 2
    localparam integer L2_COUNT = (L1_COUNT + 1) / 2; // 8
    localparam integer L2_WIDTH = 6; // 5+1

    wire [L2_WIDTH-1:0] level2 [L2_COUNT-1:0];
    genvar i2;
    generate
        for (i2 = 0; i2 < L2_COUNT; i2 = i2 + 1) begin : gen_l2
            if ((2*i2+1) < L1_COUNT) begin
                assign level2[i2] = level1[2*i2] + level1[2*i2+1];
            end else begin
                assign level2[i2] = {{(L2_WIDTH - L1_WIDTH){1'b0}}, level1[2*i2]};
            end
        end
    endgenerate

    // Level 3
    localparam integer L3_COUNT = (L2_COUNT + 1) / 2; // 4
    localparam integer L3_WIDTH = 7; // 6+1

    wire [L3_WIDTH-1:0] level3 [L3_COUNT-1:0];
    genvar i3;
    generate
        for (i3 = 0; i3 < L3_COUNT; i3 = i3 + 1) begin : gen_l3
            if ((2*i3+1) < L2_COUNT) begin
                assign level3[i3] = level2[2*i3] + level2[2*i3+1];
            end else begin
                assign level3[i3] = {{(L3_WIDTH - L2_WIDTH){1'b0}}, level2[2*i3]};
            end
        end
    endgenerate

    // Level 4
    localparam integer L4_COUNT = (L3_COUNT + 1) / 2; // 2
    localparam integer L4_WIDTH = 8; // 7+1

    wire [L4_WIDTH-1:0] level4 [L4_COUNT-1:0];
    genvar i4;
    generate
        for (i4 = 0; i4 < L4_COUNT; i4 = i4 + 1) begin : gen_l4
            if ((2*i4+1) < L3_COUNT) begin
                assign level4[i4] = level3[2*i4] + level3[2*i4+1];
            end else begin
                assign level4[i4] = {{(L4_WIDTH - L3_WIDTH){1'b0}}, level3[2*i4]};
            end
        end
    endgenerate

    // Level 5 (final sum)
    localparam integer L5_COUNT = (L4_COUNT + 1) / 2; // 1
    localparam integer L5_WIDTH = 8; // same as L4_WIDTH

    wire [L5_WIDTH-1:0] level5;
    generate
        if ((2*0+1) < L4_COUNT) begin
            assign level5 = level4[0] + level4[1];
        end else begin
            assign level5 = level4[0];
        end
    endgenerate

    // Output is 8 bits, tie level5 width to output width
    assign out = level5;

endmodule