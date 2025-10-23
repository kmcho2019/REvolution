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

module popcount #(
    parameter WIDTH = 255
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    generate
        if (WIDTH <= 8) begin : base_case
            // Zero-pad input to 8 bits MSB to LSB if WIDTH < 8
            wire [7:0] padded_in = { {(8-WIDTH){1'b0}}, in };
            popcount8 u_popcount8 (
                .in(padded_in),
                .out(out)
            );
        end else begin : recursive_case
            // Split input approximately in half
            localparam integer half = WIDTH / 2;
            localparam integer right_width = WIDTH - half;

            wire [$clog2(half+1)-1:0] left_sum;
            wire [$clog2(right_width+1)-1:0] right_sum;

            popcount #(.WIDTH(half)) left_popcount (
                .in(in[half-1:0]),
                .out(left_sum)
            );

            popcount #(.WIDTH(right_width)) right_popcount (
                .in(in[WIDTH-1:half]),
                .out(right_sum)
            );

            // Sum partial counts, output width = $clog2(WIDTH+1)
            assign out = left_sum + right_sum;
        end
    endgenerate
endmodule

// Specialized popcount17 uses recursive popcount internally
module popcount17 (
    input  [16:0] in,
    output [4:0] out // max 17 ones => 5 bits
);
    // Use recursive popcount(17)
    popcount #(.WIDTH(17)) u_popcount17 (
        .in(in),
        .out(out)
    );
endmodule

// Simple parameterized adder module
module adder #(parameter W=5) (
    input  [W-1:0] a,
    input  [W-1:0] b,
    output [W-1:0] sum
);
    assign sum = a + b;
endmodule

// Summation tree for N inputs, each W bits; N is power of two
// Output width = W + log2(N)
module sum_tree #(parameter N=16, parameter W=5) (
    input  [N*W-1:0] in_vector,
    output [W + $clog2(N)-1:0] out_sum
);
    localparam LEVELS = $clog2(N);
    // Wires for each level
    // At level 0: N sums of W bits
    // Each next level halves count, increments width by 1 due to possible carry
    
    genvar level, i;

    // Declare arrays for sums at each level
    // level_sums[level][index]
    // Use generate blocks to implement the tree

    // Use packed arrays of wires via generate

    // For RTL simplicity, declare intermediate wires as regs/wires at each level using generate
    // We will implement the tree in one generate block with nested loops

    // Since Verilog does not support arrays of arrays of wires easily, we flatten indexes per level

    // At level 0 input:
    wire [W-1:0] sums_level_0 [0:N-1];
    generate
        for (i=0; i<N; i=i+1) begin : level0_extract
            assign sums_level_0[i] = in_vector[i*W +: W];
        end
    endgenerate

    // Create intermediate wires for all levels
    // Max LEVELS: log2(N)
    // Use a generate block with variables for sums at each level

    // We build all levels as arrays of sums, where level k has N/(2^k) sums of width W+k

    // To hold sums wires per level, use 'genvar' and indexed naming
    // We use nested generate and wire arrays for this

    // Declare wires for each level
    // Because Verilog-2001 cannot declare arrays in generate easily,
    // we flatten all levels and build combinational assignments in nested generate loops.

    // We'll store wires in a packed vector and access slices

    // Calculate total width at each level: W + level

    // Level 0 vector: sums_level_0 flattened in in_vector (already given)
    // Levels 1 to LEVELS wires declared here

    // Declare wires per level
    wire [ ((N>>1)*(W+1)) -1 : 0 ] sums_level_1;
    wire [ ((N>>2)*(W+2)) -1 : 0 ] sums_level_2;
    wire [ ((N>>3)*(W+3)) -1 : 0 ] sums_level_3;
    wire [ ((N>>4)*(W+4)) -1 : 0 ] sums_level_4;

    // Assign sums_level_1 by adding pairs from sums_level_0
    generate
        for (i=0; i<(N>>1); i=i+1) begin : level1_sum
            wire [W-1:0] a = sums_level_0[2*i];
            wire [W-1:0] b = sums_level_0[2*i+1];
            assign sums_level_1[(i*(W+1)) +: (W+1)] = a + b;
        end
    endgenerate

    generate
        if (LEVELS > 2) begin
            for (i=0; i<(N>>2); i=i+1) begin : level2_sum
                wire [W:0] a = sums_level_1[(2*i*(W+1)) +: (W+1)];
                wire [W:0] b = sums_level_1[((2*i+1)*(W+1)) +: (W+1)];
                assign sums_level_2[(i*(W+2)) +: (W+2)] = a + b;
            end
        end
    endgenerate

    generate
        if (LEVELS > 3) begin
            for (i=0; i<(N>>3); i=i+1) begin : level3_sum
                wire [W+1:0] a = sums_level_2[(2*i*(W+2)) +: (W+2)];
                wire [W+1:0] b = sums_level_2[((2*i+1)*(W+2)) +: (W+2)];
                assign sums_level_3[(i*(W+3)) +: (W+3)] = a + b;
            end
        end
    endgenerate

    generate
        if (LEVELS > 4) begin
            for (i=0; i<(N>>4); i=i+1) begin : level4_sum
                wire [W+2:0] a = sums_level_3[(2*i*(W+3)) +: (W+3)];
                wire [W+2:0] b = sums_level_3[((2*i+1)*(W+3)) +: (W+3)];
                assign sums_level_4[(i*(W+4)) +: (W+4)] = a + b;
            end
        end
    endgenerate

    // Final output width = W + LEVELS
    // Connect final output from last level

    generate
        if (LEVELS == 1) begin
            assign out_sum = sums_level_1[0 +: (W+1)];
        end else if (LEVELS == 2) begin
            assign out_sum = sums_level_2[0 +: (W+2)];
        end else if (LEVELS == 3) begin
            assign out_sum = sums_level_3[0 +: (W+3)];
        end else if (LEVELS == 4) begin
            assign out_sum = sums_level_4[0 +: (W+4)];
        end else begin
            // For larger N, fallback to recursive (should not happen for N=16)
            // Assign zero to avoid synthesis warnings
            assign out_sum = {(W+LEVELS){1'b0}};
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    localparam CHUNKS = 15;
    localparam CHUNK_WIDTH = 17;

    // Partial counts: 5 bits each since max 17 ones
    wire [4:0] partial_counts [0:CHUNKS-1];

    genvar i;
    generate
        for (i = 0; i < CHUNKS; i = i + 1) begin : popcount_chunks
            popcount17 pc17 (
                .in(in[i*CHUNK_WIDTH +: CHUNK_WIDTH]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Pad partial counts with one zero count to get 16 partial sums
    wire [4:0] partial_counts_padded [0:CHUNKS];
    generate
        for (i = 0; i < CHUNKS; i = i + 1) begin
            assign partial_counts_padded[i] = partial_counts[i];
        end
        assign partial_counts_padded[CHUNKS] = 5'd0;
    endgenerate

    // Flatten partial_counts_padded to vector
    wire [5*16-1:0] flat_partial_counts;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign flat_partial_counts[i*5 +: 5] = partial_counts_padded[i];
        end
    endgenerate

    // Sum all 16 partial counts using sum_tree (N=16, W=5)
    wire [8:0] sum_total; // Output width: 5 + 4 = 9 bits

    sum_tree #(
        .N(16),
        .W(5)
    ) sum_tree_inst (
        .in_vector(flat_partial_counts),
        .out_sum(sum_total)
    );

    // Output only 8 bits needed (max 255)
    assign out = sum_total[7:0];
endmodule