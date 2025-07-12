module popcount8 (
    input  [7:0] in,
    output [3:0] out  // max 8 ones => 4 bits
);
    // Balanced explicit adder tree for 8 bits
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

module popcount_recursive #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] in,
    output reg [$clog2(WIDTH+1)-1:0] out
);
    // Recursive balanced popcount with popcount8 base case
    generate
        if (WIDTH <= 8) begin : base_case
            // Zero-pad input MSBs if WIDTH < 8
            wire [7:0] base_in = { {(8-WIDTH){1'b0}}, in };
            wire [3:0] base_out;
            popcount8 u_popcount8 (
                .in(base_in),
                .out(base_out)
            );
            always @(*) out = base_out[$clog2(WIDTH+1)-1:0];
        end else begin : recursive_case
            localparam half = WIDTH / 2;
            localparam right_width = WIDTH - half;

            wire [$clog2(half+1)-1:0] left_sum;
            wire [$clog2(right_width+1)-1:0] right_sum;

            popcount_recursive #(.WIDTH(half)) left_popcount (
                .in(in[half-1:0]),
                .out(left_sum)
            );

            popcount_recursive #(.WIDTH(right_width)) right_popcount (
                .in(in[WIDTH-1:half]),
                .out(right_sum)
            );

            // Sum left and right sums, sized to output width
            always @(*) out = left_sum + right_sum;
        end
    endgenerate
endmodule

// Recursive summation tree of N inputs, each INPUT_WIDTH bits wide,
// outputs sum_width bits wide where sum_width = ceil(log2(N*(2^INPUT_WIDTH -1)+1))
module recursive_sum #(
    parameter N = 1,
    parameter INPUT_WIDTH = 4
) (
    input  [N*INPUT_WIDTH-1:0] in_vector,
    output reg [$clog2(N*(2**INPUT_WIDTH-1)+1)-1:0] out_sum
);

    generate
        if (N == 1) begin : base_sum
            always @(*) out_sum = in_vector;
        end else begin : recursive_sum_case
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
            localparam SUM_WIDTH = $clog2(N*(2**INPUT_WIDTH-1)+1);

            wire [SUM_WIDTH-1:0] left_sum_zext = {{(SUM_WIDTH - $bits(left_sum)){1'b0}}, left_sum};
            wire [SUM_WIDTH-1:0] right_sum_zext = {{(SUM_WIDTH - $bits(right_sum)){1'b0}}, right_sum};

            always @(*) out_sum = left_sum_zext + right_sum_zext;
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
        // Instantiate popcount_recursive for last 7 bits
        popcount_recursive #(.WIDTH(7)) pc7 (
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
    // Max sum: 32 * 8 = 256 (max 255 actually), so output width = 8 bits (log2(256)=8)
    wire [7:0] popcount_sum;

    recursive_sum #(
        .N(NUM_CHUNKS),
        .INPUT_WIDTH(4)
    ) sum_tree (
        .in_vector(partial_counts_flat),
        .out_sum(popcount_sum)
    );

    assign out = popcount_sum;

endmodule