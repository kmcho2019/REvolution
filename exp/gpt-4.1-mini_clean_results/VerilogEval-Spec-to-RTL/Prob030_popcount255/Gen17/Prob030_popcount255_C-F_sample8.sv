module popcount16 (
    input  wire [15:0] in,
    output wire [4:0]  out
);
    // Parallel popcount for 16 bits using balanced adder tree
    // Level 1: sum adjacent pairs (8 sums of 2 bits)
    wire [1:0] sum2 [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : sum_pairs
            assign sum2[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    // Level 2: sum adjacent pairs (4 sums of 3 bits)
    wire [2:0] sum4 [3:0];
    generate
        for (i=0; i<4; i=i+1) begin : sum4s
            assign sum4[i] = sum2[2*i] + sum2[2*i+1];
        end
    endgenerate

    // Level 3: sum adjacent pairs (2 sums of 4 bits)
    wire [3:0] sum8 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : sum8s
            assign sum8[i] = sum4[2*i] + sum4[2*i+1];
        end
    endgenerate

    // Level 4: final sum (5 bits)
    assign out = sum8[0] + sum8[1];
endmodule

module popcount #(
    parameter WIDTH = 255,
    parameter LEAF_WIDTH = 16
) (
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);

    // Compute output width for sub-counts (leaf or recursive)
    localparam OUT_WIDTH = $clog2(WIDTH+1);

    generate
        if (WIDTH <= LEAF_WIDTH) begin : leaf_popcount
            // If input smaller or equal than LEAF_WIDTH, use flat popcount
            // For WIDTH < 16, zero-extend input to 16 bits and truncate output
            wire [15:0] in_16;
            wire [4:0]  out_16;

            assign in_16 = { {(16-WIDTH){1'b0}}, in };

            popcount16 u_pop16 (
                .in(in_16),
                .out(out_16)
            );

            assign out = out_16[OUT_WIDTH-1:0]; // truncate to needed bits
        end else begin : recursive_popcount
            // Recursive case: partition input into N chunks of chunk_width bits
            // chunk_width = min(LEAF_WIDTH, WIDTH/N)
            // Choose number of chunks = ceil(WIDTH / LEAF_WIDTH)
            localparam integer N_CHUNKS = (WIDTH + LEAF_WIDTH - 1) / LEAF_WIDTH;
            localparam integer LAST_CHUNK_WIDTH = WIDTH - (N_CHUNKS - 1)*LEAF_WIDTH;

            // Declare array for partial sums from each chunk
            wire [$clog2(LEAF_WIDTH+1)-1:0] partial_counts [0:N_CHUNKS-1];

            genvar idx;
            for (idx=0; idx<N_CHUNKS; idx=idx+1) begin : chunk_popcount
                // Calculate bit range for this chunk
                localparam integer chunk_start = idx*LEAF_WIDTH;
                localparam integer chunk_width = (idx == N_CHUNKS-1) ? LAST_CHUNK_WIDTH : LEAF_WIDTH;

                // Slice input bits for this chunk
                wire [chunk_width-1:0] chunk_bits = in[chunk_start +: chunk_width];

                // Instantiate popcount for chunk (recursively if needed)
                popcount #(
                    .WIDTH(chunk_width),
                    .LEAF_WIDTH(LEAF_WIDTH)
                ) u_chunk_popcount (
                    .in(chunk_bits),
                    .out(partial_counts[idx])
                );
            end

            // Sum partial counts from all chunks using balanced adder tree

            // total output width of partial counts: pc_width = $clog2(LEAF_WIDTH+1)
            localparam integer PC_WIDTH = $clog2(LEAF_WIDTH+1);

            // Because partial_counts[] are PC_WIDTH bits wide, sum of N_CHUNKS partial_counts
            // fits into OUT_WIDTH bits.

            // Balanced adder tree summation function
            function [OUT_WIDTH-1:0] balanced_sum;
                input integer num_vals;
                input wire [PC_WIDTH-1:0] vals [];
                integer half;
                reg [OUT_WIDTH-1:0] sum_left;
                reg [OUT_WIDTH-1:0] sum_right;
                integer i;
                begin
                    if (num_vals == 1) begin
                        balanced_sum = vals[0];
                    end else begin
                        half = num_vals/2;
                        // sum left half
                        sum_left = balanced_sum(half, vals);
                        // sum right half (or zero if odd number and no right half)
                        if (num_vals - half > 0) begin
                            sum_right = balanced_sum(num_vals - half, vals[half +: (num_vals - half)]);
                        end else begin
                            sum_right = 0;
                        end
                        balanced_sum = sum_left + sum_right;
                    end
                end
            endfunction

            // But Verilog functions cannot accept packed arrays and recursion easily
            // So implement balanced adder tree with generate loops instead.

            // Implement a balanced adder tree summation of partial_counts with generate
            // Use a hierarchical summation: at each level halve number of sums by adding pairs.

            // First, declare regs/wires for intermediate sums at each level.
            // Max levels = ceil(log2(N_CHUNKS))

            localparam integer MAX_LEVELS = $clog2(N_CHUNKS);

            // Arrays to hold sums at each level:
            // Level 0 inputs are partial_counts with PC_WIDTH bits,
            // next levels have wider sums accordingly (max OUT_WIDTH bits).

            // To simplify, define array for each level:
            // Each element is OUT_WIDTH bits wide to hold max sum.

            // Declare reg arrays for each level
            // Because Verilog does not support 2D arrays of wires easily with variable size,
            // Use generate blocks and arrays of wires.

            // We create wires for level 0 (inputs), and levels 1..MAX_LEVELS
            wire [OUT_WIDTH-1:0] level_sums [0:MAX_LEVELS][0:(N_CHUNKS+1)/2 -1]; // upper bound size

            // Assign level 0 sums = zero-extended partial_counts
            genvar level_idx, elem_idx;
            generate
                for (elem_idx = 0; elem_idx < N_CHUNKS; elem_idx = elem_idx + 1) begin : level0_assign
                    assign level_sums[0][elem_idx] = {{(OUT_WIDTH-PC_WIDTH){1'b0}}, partial_counts[elem_idx]};
                end

                // For unused elements in level 0 (if N_CHUNKS not power of two), tie to zero
                for (elem_idx = N_CHUNKS; elem_idx < (1 << MAX_LEVELS); elem_idx = elem_idx + 1) begin : level0_unused
                    assign level_sums[0][elem_idx] = {OUT_WIDTH{1'b0}};
                end
            endgenerate

            // For each level > 0, sum pairs from previous level
            generate
                for (level_idx = 1; level_idx <= MAX_LEVELS; level_idx = level_idx + 1) begin : sum_levels
                    localparam integer prev_level_size = ( (N_CHUNKS + (1 << (level_idx - 1)) - 1) >> (level_idx - 1));
                    localparam integer curr_level_size = (prev_level_size + 1) >> 1;

                    for (elem_idx = 0; elem_idx < curr_level_size; elem_idx = elem_idx + 1) begin : elems
                        // sum pair of two elements from prev_level
                        wire [OUT_WIDTH-1:0] left = level_sums[level_idx-1][2*elem_idx];
                        wire [OUT_WIDTH-1:0] right = (2*elem_idx+1 < prev_level_size) ? level_sums[level_idx-1][2*elem_idx+1] : {OUT_WIDTH{1'b0}};
                        assign level_sums[level_idx][elem_idx] = left + right;
                    end
                end
            endgenerate

            // The final output is the only element at MAX_LEVELS
            assign out = level_sums[MAX_LEVELS][0];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // Instantiate fused popcount with leaf width 16
    popcount #(
        .WIDTH(255),
        .LEAF_WIDTH(16)
    ) u_popcount (
        .in(in),
        .out(out)
    );
endmodule