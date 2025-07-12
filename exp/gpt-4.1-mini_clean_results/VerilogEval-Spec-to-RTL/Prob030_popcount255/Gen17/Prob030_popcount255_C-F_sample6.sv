`timescale 1ns / 1ps

// Parameterized popcount module: counts the number of '1's in input vector of any width
module popcount #(
    parameter WIDTH = 16
)(
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    // Recursive balanced adder tree
    // Use generate-for with balanced split; handle base case for WIDTH=1

    generate
        if (WIDTH == 1) begin : base_case
            assign out = in[0];
        end else begin : recursive_case
            localparam half = WIDTH / 2;
            localparam right_width = WIDTH - half;

            wire [$clog2(half+1)-1:0] sum_left;
            wire [$clog2(right_width+1)-1:0] sum_right;

            popcount #(.WIDTH(half)) left_inst (
                .in(in[half-1:0]),
                .out(sum_left)
            );

            popcount #(.WIDTH(right_width)) right_inst (
                .in(in[WIDTH-1:half]),
                .out(sum_right)
            );

            // Sum of left and right partial counts; output width enough to hold full sum
            // The out width must be >= $clog2(WIDTH+1)
            assign out = sum_left + sum_right;
        end
    endgenerate
endmodule

// Recursive balanced adder tree module for summing array of N inputs each WIDTH bits wide
module sum_tree #(
    parameter WIDTH = 5,  // input element width
    parameter N = 16      // number of inputs
)(
    input  [WIDTH*N-1:0] in_flat,  // concatenated inputs
    output [$clog2(N*(2**WIDTH))+0:0] out // output width to hold max sum
);
    localparam OUT_WIDTH = $clog2(N*(2**WIDTH));

    generate
        if (N == 1) begin : base_1
            assign out = in_flat[WIDTH-1:0];
        end else if (N == 2) begin : base_2
            wire [WIDTH-1:0] in0 = in_flat[WIDTH-1:0];
            wire [WIDTH-1:0] in1 = in_flat[2*WIDTH-1:WIDTH];
            assign out = in0 + in1;
        end else begin : recursive_sum
            localparam N_L = N / 2;
            localparam N_R = N - N_L;

            wire [WIDTH*N_L-1:0] in_left = in_flat[WIDTH*N_L-1:0];
            wire [WIDTH*N_R-1:0] in_right = in_flat[WIDTH*N-1:WIDTH*N_L];

            wire [OUT_WIDTH-1:0] sum_left;
            wire [OUT_WIDTH-1:0] sum_right;

            sum_tree #(.WIDTH(WIDTH), .N(N_L)) left_tree (
                .in_flat(in_left),
                .out(sum_left)
            );
            sum_tree #(.WIDTH(WIDTH), .N(N_R)) right_tree (
                .in_flat(in_right),
                .out(sum_right)
            );

            assign out = sum_left + sum_right;
        end
    endgenerate
endmodule

// TopModule: 255-bit input popcount outputting 8-bit total count
module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Chunk sizes: 15 chunks total
    // 15 chunks of 16 bits = 240 bits
    // plus 1 chunk of 15 bits = 15 bits
    // Total = 255 bits
    localparam CHUNKS = 16;
    localparam CHUNK_WIDTHS [0:CHUNKS-1] = '{16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,15};

    // Partial counts from each chunk
    // Maximum popcount per chunk: 16 bits => 5 bits output; 15 bits => 4 bits output (but use 5 bits uniformly)
    // We'll use 5 bits to cover max count 16 for all chunks to simplify concatenation
    wire [4:0] partial_counts [0:CHUNKS-1];

    genvar i;
    generate
        for (i = 0; i < CHUNKS; i = i + 1) begin : chunk_popcounts
            // Determine chunk width from localparam array
            localparam integer w = CHUNK_WIDTHS[i];
            popcount #(.WIDTH(w)) pc_inst (
                .in(in[(i*16) +: w]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Flatten partial counts into a single bus for sum_tree input
    wire [5*CHUNKS-1:0] partial_counts_flat;
    generate
        for (i = 0; i < CHUNKS; i = i + 1) begin : flatten_partial_counts
            assign partial_counts_flat[5*i +: 5] = partial_counts[i];
        end
    endgenerate

    // Use sum_tree to sum all partial counts
    // Inputs: CHUNKS = 16 inputs each 5 bits
    // Maximum sum = 16 * 16 = 256, requires 9 bits output, but 8 bits is sufficient for 255 max count
    // Use 9 bits output internally for safety, assign lower 8 bits to out
    wire [8:0] total_count_9;
    sum_tree #(
        .WIDTH(5),
        .N(CHUNKS)
    ) sum_tree_inst (
        .in_flat(partial_counts_flat),
        .out(total_count_9)
    );

    // The maximum possible popcount is 255, so upper bit of total_count_9 is always 0 or can be ignored
    assign out = total_count_9[7:0];

endmodule