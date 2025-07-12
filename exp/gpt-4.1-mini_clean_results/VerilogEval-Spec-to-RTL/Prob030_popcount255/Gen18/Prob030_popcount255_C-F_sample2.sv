module popcount17 (
    input  [16:0] in,
    output [4:0] out // 5 bits suffice for max 17 ones
);
    // Level 1: sum pairs -> 8 sums of 2 bits each + 1 leftover bit
    wire [1:0] sum0 [0:7];
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : sum_pairs
            assign sum0[i] = in[2*i] + in[2*i+1];
        end
    endgenerate
    wire leftover_bit = in[16];

    // Level 2: sum sum0 in pairs -> 4 sums of 3 bits each
    wire [2:0] sum1 [0:3];
    generate
        for(i=0; i<4; i=i+1) begin : sum_pairs_level2
            assign sum1[i] = sum0[2*i] + sum0[2*i+1];
        end
    endgenerate

    // Level 3: sum sum1 in pairs -> 2 sums of 4 bits each
    wire [3:0] sum2 [0:1];
    generate
        for(i=0; i<2; i=i+1) begin : sum_pairs_level3
            assign sum2[i] = sum1[2*i] + sum1[2*i+1];
        end
    endgenerate

    // Level 4: sum the two sums + leftover bit -> 5-bit result
    wire [4:0] sum3 = sum2[0] + sum2[1] + leftover_bit;

    assign out = sum3;
endmodule

// Recursive summation tree for summing N inputs, each WIDTH bits wide,
// output width fixed to OUT_WIDTH bits (e.g. 8 bits for total popcount).
// Inputs are flattened into one vector.
module popcount_sum_tree #(
    parameter WIDTH = 5,
    parameter N = 15,
    parameter OUT_WIDTH = 8
) (
    input  [WIDTH*N-1:0] in_flat,
    output [OUT_WIDTH-1:0] out
);
    generate
        if (N == 1) begin
            // Zero-extend input to OUT_WIDTH bits
            assign out = {{(OUT_WIDTH-WIDTH){1'b0}}, in_flat[WIDTH-1:0]};
        end else if (N == 2) begin
            // Sum two inputs, with fixed output width
            wire [WIDTH-1:0] in0 = in_flat[WIDTH-1:0];
            wire [WIDTH-1:0] in1 = in_flat[2*WIDTH-1:WIDTH];
            wire [OUT_WIDTH-1:0] in0_ext = {{(OUT_WIDTH-WIDTH){1'b0}}, in0};
            wire [OUT_WIDTH-1:0] in1_ext = {{(OUT_WIDTH-WIDTH){1'b0}}, in1};
            assign out = in0_ext + in1_ext;
        end else begin
            // Split into two parts: left has half elements (floor), right has rest
            localparam N_L = N / 2;
            localparam N_R = N - N_L;

            wire [WIDTH*N_L-1:0] in_left  = in_flat[WIDTH*N_L-1:0];
            wire [WIDTH*N_R-1:0] in_right = in_flat[WIDTH*N-1:WIDTH*N_L];

            wire [OUT_WIDTH-1:0] sum_left;
            wire [OUT_WIDTH-1:0] sum_right;

            popcount_sum_tree #(
                .WIDTH(WIDTH),
                .N(N_L),
                .OUT_WIDTH(OUT_WIDTH)
            ) u_left (
                .in_flat(in_left),
                .out(sum_left)
            );

            popcount_sum_tree #(
                .WIDTH(WIDTH),
                .N(N_R),
                .OUT_WIDTH(OUT_WIDTH)
            ) u_right (
                .in_flat(in_right),
                .out(sum_right)
            );

            assign out = sum_left + sum_right;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    localparam CHUNKS = 15;
    localparam CHUNK_WIDTH = 17;

    // Partial popcounts per chunk (5 bits each)
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

    // Flatten partial counts into vector
    wire [CHUNKS*5-1:0] partial_flat;
    generate
        for (i = 0; i < CHUNKS; i = i + 1) begin : flatten_partial
            assign partial_flat[i*5 +: 5] = partial_counts[i];
        end
    endgenerate

    // Pad partial counts with one zero count to make 16 elements for power-of-two size
    wire [5*16-1:0] padded_flat;
    generate
        for (i = 0; i < CHUNKS; i = i + 1) begin
            assign padded_flat[i*5 +: 5] = partial_counts[i];
        end
        assign padded_flat[CHUNKS*5 +: 5] = 5'd0; // zero padding
    endgenerate

    // Use sum tree to sum all 16 counts with fixed output width 8 bits
    wire [7:0] total_sum;

    popcount_sum_tree #(
        .WIDTH(5),
        .N(16),
        .OUT_WIDTH(8)
    ) sum_tree (
        .in_flat(padded_flat),
        .out(total_sum)
    );

    assign out = total_sum;
endmodule