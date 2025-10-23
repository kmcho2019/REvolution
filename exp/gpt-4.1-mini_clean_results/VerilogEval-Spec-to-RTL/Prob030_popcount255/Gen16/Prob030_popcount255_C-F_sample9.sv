// LUT-style popcount8: efficient 8-bit popcount with balanced add tree
module popcount8 (
    input  [7:0] in,
    output [3:0] out  // max 8 ones => 4 bits
);
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum46 = in[4] + in[5];
    wire [1:0] sum57 = in[6] + in[7];

    wire [2:0] sum0123 = sum02 + sum13; // max 4
    wire [2:0] sum4567 = sum46 + sum57; // max 4

    assign out = sum0123 + sum4567;      // max 8
endmodule

// Recursive, parameterized popcount module:
// For WIDTH <= 8, uses popcount8 with zero-padding;
// else recursively splits input into two halves and sums partial counts.
module popcount #(
    parameter WIDTH = 255
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);
    generate
        if (WIDTH <= 8) begin : base_case
            // Zero-pad input to 8 bits if needed
            wire [7:0] padded_in = { {(8 - WIDTH){1'b0}}, in };
            popcount8 pc8 (
                .in(padded_in),
                .out(out)
            );
        end else begin : recursive_case
            localparam HALF = WIDTH / 2;
            localparam RIGHT_WIDTH = WIDTH - HALF;

            wire [$clog2(HALF+1)-1:0] left_sum;
            wire [$clog2(RIGHT_WIDTH+1)-1:0] right_sum;

            popcount #(.WIDTH(HALF)) left_popcount (
                .in(in[HALF-1:0]),
                .out(left_sum)
            );
            popcount #(.WIDTH(RIGHT_WIDTH)) right_popcount (
                .in(in[WIDTH-1:HALF]),
                .out(right_sum)
            );

            assign out = left_sum + right_sum;
        end
    endgenerate
endmodule

// Recursive summation tree:
// Sums N inputs each INPUT_WIDTH bits wide into a sum of width $clog2(N*(2^INPUT_WIDTH-1)+1).
// Balanced binary tree approach for minimal depth.
module recursive_sum #(
    parameter N = 1,
    parameter INPUT_WIDTH = 4
) (
    input  [N*INPUT_WIDTH-1:0] in_vector,
    output [$clog2(N*(2**INPUT_WIDTH-1)+1)-1:0] out_sum
);
    generate
        if (N == 1) begin
            assign out_sum = in_vector;
        end else begin
            localparam N_LEFT = N / 2;
            localparam N_RIGHT = N - N_LEFT;

            localparam LEFT_WIDTH = N_LEFT * INPUT_WIDTH;
            localparam RIGHT_WIDTH = N_RIGHT * INPUT_WIDTH;

            wire [$clog2(N_LEFT*(2**INPUT_WIDTH-1)+1)-1:0] left_sum;
            wire [$clog2(N_RIGHT*(2**INPUT_WIDTH-1)+1)-1:0] right_sum;

            recursive_sum #(
                .N(N_LEFT),
                .INPUT_WIDTH(INPUT_WIDTH)
            ) left_inst (
                .in_vector(in_vector[LEFT_WIDTH-1:0]),
                .out_sum(left_sum)
            );

            recursive_sum #(
                .N(N_RIGHT),
                .INPUT_WIDTH(INPUT_WIDTH)
            ) right_inst (
                .in_vector(in_vector[N*INPUT_WIDTH-1:LEFT_WIDTH]),
                .out_sum(right_sum)
            );

            localparam SUM_WIDTH = $clog2(N*(2**INPUT_WIDTH-1)+1);

            wire [SUM_WIDTH-1:0] left_sum_zext = {{(SUM_WIDTH - $bits(left_sum)){1'b0}}, left_sum};
            wire [SUM_WIDTH-1:0] right_sum_zext = {{(SUM_WIDTH - $bits(right_sum)){1'b0}}, right_sum};

            assign out_sum = left_sum_zext + right_sum_zext;
        end
    endgenerate
endmodule

// TopModule:
// - Splits 255-bit input into 32 chunks: 31 chunks of 8 bits and 1 chunk of 7 bits,
// - Uses the recursive parameterized popcount module (popcount) for each chunk,
//   so all chunks are counted using popcount with WIDTH=8 or 7.
// - Pads the 7-bit chunk to 8 bits internally within popcount base case (zero padding).
// - Collects 32 partial counts (each 4 or fewer bits wide, but standardized to 4 bits for uniformity).
// - Sums all partial counts with the recursive_sum module to get the final 8-bit count.
// - The fully combinational design is clean, efficient, and scalable.
module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    localparam NUM_FULL_CHUNKS = 31;
    localparam NUM_CHUNKS = 32;  // 31*8 bits + 1*7 bits

    // Partial counts width: max 8 for 8-bit chunks, so 4 bits output from popcount base case
    wire [3:0] partial_counts [0:NUM_CHUNKS-1];

    genvar i;
    generate
        // Instantiate popcount modules for first 31 chunks of 8 bits
        for (i = 0; i < NUM_FULL_CHUNKS; i = i + 1) begin : gen_popcount8_chunks
            popcount #(.WIDTH(8)) pc8 (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
        // Instantiate popcount module for last 7 bits, zero-padded inside popcount
        popcount #(.WIDTH(7)) pc7 (
            .in(in[254:248]),
            .out(partial_counts[NUM_CHUNKS-1])
        );
    endgenerate

    // Flatten partial_counts array into a single vector for recursive_sum input
    wire [NUM_CHUNKS*4-1:0] partial_counts_flat;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : flatten_partial_counts
            assign partial_counts_flat[i*4 +: 4] = partial_counts[i];
        end
    endgenerate

    // Recursive summation tree to sum all 32 partial counts of 4 bits each
    // Max sum = 32 * 8 = 256, so 8 bits output required
    wire [8:0] sum32; // sum width from recursive_sum module

    recursive_sum #(
        .N(NUM_CHUNKS),
        .INPUT_WIDTH(4)
    ) sum_tree (
        .in_vector(partial_counts_flat),
        .out_sum(sum32)
    );

    // Maximum popcount for 255 bits is 255, fits in 8 bits,
    // sum32 is 9 bits wide, so discard MSB safely
    assign out = sum32[7:0];

endmodule