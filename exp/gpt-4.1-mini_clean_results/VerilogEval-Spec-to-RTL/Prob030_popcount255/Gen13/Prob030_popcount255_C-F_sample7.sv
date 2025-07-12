module popcount8 (
    input  [7:0] in,
    output [3:0] out  // max 8 ones => 4 bits
);
    // LUT-style add tree for 8 bits
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum46 = in[4] + in[5];
    wire [1:0] sum57 = in[6] + in[7];

    wire [2:0] sum0123 = sum02 + sum13; // max 4
    wire [2:0] sum4567 = sum46 + sum57; // max 4

    assign out = sum0123 + sum4567;      // max 8
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out  // max 7 ones => 4 bits for uniform width
);
    // LUT-style add tree for 7 bits
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum45 = in[4] + in[5];
    wire       bit6 = in[6];

    wire [2:0] sum0123 = sum02 + sum13;   // max 4
    wire [2:0] sum4546 = sum45 + bit6;    // max 3

    assign out = sum0123 + sum4546;       // max 7
endmodule

// Recursive summation tree of N inputs, each INPUT_WIDTH bits wide,
// outputs sum_width bits wide where sum_width = ceil(log2(N*(2^INPUT_WIDTH -1)+1))
module recursive_sum #(
    parameter N = 1,
    parameter INPUT_WIDTH = 4
) (
    input  [N*INPUT_WIDTH-1:0] in_vector,
    output [$clog2(N*(2**INPUT_WIDTH-1)+1)-1:0] out_sum
);

    generate
        if (N == 1) begin
            // Base case: single input, assign directly
            assign out_sum = in_vector;
        end else begin
            // Recursive case: split input vector into two halves (left and right)
            localparam N_LEFT = N/2;
            localparam N_RIGHT = N - N_LEFT;

            localparam LEFT_WIDTH = N_LEFT*INPUT_WIDTH;
            localparam RIGHT_WIDTH = N_RIGHT*INPUT_WIDTH;

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

            // Sum left and right partial sums
            // output width must cover max sum = max left_sum + max right_sum
            localparam SUM_WIDTH = $clog2(N*(2**INPUT_WIDTH-1)+1);

            wire [SUM_WIDTH-1:0] left_sum_zext = {{(SUM_WIDTH - $bits(left_sum)){1'b0}}, left_sum};
            wire [SUM_WIDTH-1:0] right_sum_zext = {{(SUM_WIDTH - $bits(right_sum)){1'b0}}, right_sum};

            assign out_sum = left_sum_zext + right_sum_zext;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    localparam NUM_FULL_CHUNKS = 31;
    localparam NUM_CHUNKS = 32; // 31x8 bits + 1x7 bits

    // Partial counts: each 4 bits wide for uniformity
    wire [3:0] partial_counts [0:NUM_CHUNKS-1];

    genvar i;
    generate
        // Instantiate popcount8 for first 31 chunks of 8 bits
        for (i = 0; i < NUM_FULL_CHUNKS; i = i + 1) begin : gen_pop8_chunks
            popcount8 pc8 (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
        // Instantiate popcount7 for last 7 bits [254:248]
        popcount7 pc7 (
            .in(in[254:248]),
            .out(partial_counts[NUM_CHUNKS-1])
        );
    endgenerate

    // Flatten partial_counts array to a wide vector for recursive_sum input
    wire [NUM_CHUNKS*4-1:0] partial_counts_flat;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : flatten_partial
            assign partial_counts_flat[i*4 +: 4] = partial_counts[i];
        end
    endgenerate

    // Instantiate recursive summation tree for 32 inputs each 4 bits wide
    // Max sum: 32 * 15 = 480, so output width >= 9 bits (log2(481)=9)
    wire [8:0] popcount_sum;

    recursive_sum #(
        .N(NUM_CHUNKS),
        .INPUT_WIDTH(4)
    ) sum_tree (
        .in_vector(partial_counts_flat),
        .out_sum(popcount_sum)
    );

    // The maximum population count for 255 bits is 255 (8 bits),
    // popcount_sum is 9 bits wide to safely cover worst case sum from 32 partial counts
    // The upper bit can be safely discarded since max 255 < 256
    assign out = popcount_sum[7:0];

endmodule