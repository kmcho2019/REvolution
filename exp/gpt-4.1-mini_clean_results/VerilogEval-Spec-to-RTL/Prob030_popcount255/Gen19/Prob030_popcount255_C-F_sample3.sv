module popcount #(parameter WIDTH = 1) (
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);
    // Base case: WIDTH==1, output is the bit itself
    generate
        if (WIDTH == 1) begin
            assign out = in;
        end else begin
            localparam LEFT_WIDTH  = WIDTH / 2;
            localparam RIGHT_WIDTH = WIDTH - LEFT_WIDTH;

            wire [$clog2(LEFT_WIDTH+1)-1:0] left_count;
            wire [$clog2(RIGHT_WIDTH+1)-1:0] right_count;

            popcount #(LEFT_WIDTH) left_pop (
                .in(in[WIDTH-1:WIDTH-LEFT_WIDTH]),
                .out(left_count)
            );
            popcount #(RIGHT_WIDTH) right_pop (
                .in(in[RIGHT_WIDTH-1:0]),
                .out(right_count)
            );

            assign out = left_count + right_count;
        end
    endgenerate
endmodule

// Recursively sums an array of N inputs each WIDTH bits wide.
// The input array is provided as a flattened vector in_flat.
// Output width is calculated to hold max sum: N*(2^WIDTH - 1)
module popcount_sum_tree #(
    parameter WIDTH = 8,
    parameter N = 17 // default example values
)(
    input  wire [WIDTH*N-1:0] in_flat,
    output wire [$clog2(N*(2**WIDTH))+0-1:0] out
);
    localparam OUT_WIDTH = $clog2(N*(2**WIDTH));

    generate
        if (N == 1) begin
            assign out = in_flat[WIDTH-1:0];
        end else if (N == 2) begin
            wire [WIDTH-1:0] in0 = in_flat[WIDTH-1:0];
            wire [WIDTH-1:0] in1 = in_flat[2*WIDTH-1:WIDTH];
            assign out = in0 + in1;
        end else begin
            localparam N_L = N / 2;
            localparam N_R = N - N_L;

            wire [WIDTH*N_L-1:0] in_left  = in_flat[WIDTH*N_L-1:0];
            wire [WIDTH*N_R-1:0] in_right = in_flat[WIDTH*N-1:WIDTH*N_L];

            wire [OUT_WIDTH-1:0] sum_left;
            wire [OUT_WIDTH-1:0] sum_right;

            popcount_sum_tree #(.WIDTH(WIDTH), .N(N_L)) u_left (
                .in_flat(in_left),
                .out(sum_left)
            );
            popcount_sum_tree #(.WIDTH(WIDTH), .N(N_R)) u_right (
                .in_flat(in_right),
                .out(sum_right)
            );

            assign out = sum_left + sum_right;
        end
    endgenerate
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // Define chunk sizes: fifteen 16-bit chunks + one 15-bit chunk to cover 255 bits
    localparam CHUNK_WIDTH = 16;
    localparam NUM_CHUNKS_16 = 15;
    localparam LAST_CHUNK_WIDTH = 15;

    // Partial counts for the 16-bit chunks (5 bits wide because ceil(log2(16+1))=5)
    wire [4:0] partial_counts_16 [0:NUM_CHUNKS_16-1];

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS_16; i = i + 1) begin : popcounts_16bit
            popcount #(CHUNK_WIDTH) pc16 (
                .in(in[i*CHUNK_WIDTH +: CHUNK_WIDTH]),
                .out(partial_counts_16[i])
            );
        end
    endgenerate

    // Partial count for last 15-bit chunk (5 bits wide because ceil(log2(15+1))=4 but we use 5 bits for uniformity)
    wire [4:0] partial_count_last;
    popcount #(LAST_CHUNK_WIDTH) pc_last (
        .in(in[NUM_CHUNKS_16*CHUNK_WIDTH +: LAST_CHUNK_WIDTH]),
        .out(partial_count_last)
    );

    // Flatten all 16 partial counts (each 5 bits) for summation:
    // total 16 counts * 5 bits = 80 bits
    wire [5*16-1:0] partial_counts_flat;

    generate
        for (i = 0; i < NUM_CHUNKS_16; i = i + 1) begin : flatten_partials_16
            assign partial_counts_flat[5*i +: 5] = partial_counts_16[i];
        end
    endgenerate
    // Append last partial count
    assign partial_counts_flat[5*15 +: 5] = partial_count_last;

    // Use generic popcount_sum_tree module to sum 16 partial counts (WIDTH=5, N=16)
    // Max sum: 16 * max chunk count (16) = 256, which fits in 9 bits, but final output truncated to 8 bits since max is 255
    wire [8:0] total_count_wide;
    popcount_sum_tree #(
        .WIDTH(5),
        .N(16)
    ) sum_tree (
        .in_flat(partial_counts_flat),
        .out(total_count_wide)
    );

    // Final output is lower 8 bits (max population count is 255)
    assign out = total_count_wide[7:0];

endmodule