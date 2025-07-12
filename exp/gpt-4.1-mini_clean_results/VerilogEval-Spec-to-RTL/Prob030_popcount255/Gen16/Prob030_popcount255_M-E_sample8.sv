module popcount17 (
    input  [16:0] in,
    output [4:0] out // max 17 ones => 5 bits
);
    // Sum all bits in in[16:0] using a tree of adders
    // Level 1: sum pairs -> 8 sums of 2 bits + 1 leftover bit
    wire [1:0] sum0 [0:7];
    genvar i;
    generate
        for(i=0; i<8; i=i+1) begin : sum_pairs
            assign sum0[i] = in[2*i] + in[2*i+1];
        end
    endgenerate
    // sum the leftover bit in in[16]
    wire leftover_bit = in[16];

    // Level 2: sum sum0 in pairs (4 sums)
    wire [2:0] sum1 [0:3];
    generate
        for(i=0; i<4; i=i+1) begin : sum_pairs_level2
            assign sum1[i] = sum0[2*i] + sum0[2*i+1];
        end
    endgenerate

    // Level 3: sum sum1 in pairs (2 sums)
    wire [3:0] sum2 [0:1];
    generate
        for(i=0; i<2; i=i+1) begin : sum_pairs_level3
            assign sum2[i] = sum1[2*i] + sum1[2*i+1];
        end
    endgenerate

    // Level 4: sum the two sums + leftover bit
    wire [4:0] sum3 = sum2[0] + sum2[1] + leftover_bit;

    assign out = sum3;
endmodule

// Parameterized adder of width W bits
module adder #(parameter W=5) (
    input  [W-1:0] a,
    input  [W-1:0] b,
    output [W-1:0] sum
);
    assign sum = a + b;
endmodule

// Summation tree module for summing N inputs of W bits, N is power of two.
// Output width is W + log2(N)
module sum_tree #(parameter N=16, parameter W=5) (
    input  [N*W-1:0] in_vector,
    output [W + $clog2(N)-1:0] out_sum
);
    // Generate tree of adders
    // At each level halve the number of adders and increase bitwidth by 1 due to worst-case carry
    // Use an array of vectors representing sums at each level

    localparam LEVELS = $clog2(N);
    // We'll create a reg array for each level to hold sums
    // Level 0 inputs are in_vector chunks of W bits

    // Using generate blocks and wires for each level
    // Define arrays of wires for sums at each level

    // First, extract inputs as array for level 0
    wire [W-1:0] level_sums [0:N-1];
    genvar i;
    generate
        for(i=0; i<N; i=i+1) begin : extract_inputs
            assign level_sums[i] = in_vector[i*W +: W];
        end
    endgenerate

    // Create arrays of wires for each level
    // Use packed arrays indexed by level and element
    // Since parameters are constants, unroll generate loops accordingly

    // We will create intermediate wires in nested generate loops

    // To hold sums per level:
    // Level 0: N sums, width = W
    // Level 1: N/2 sums, width = W+1
    // Level 2: N/4 sums, width = W+2
    // ...
    // Level k: N/(2^k) sums, width = W + k

    // We'll create a recursive generate block structure using a helper module.

endmodule

// Helper module to implement sum tree recursively
module sum_tree_recursive #(
    parameter N = 1,
    parameter W = 5
) (
    input  [N*W-1:0] in_vector,
    output [W + $clog2(N)-1:0] out_sum
);
    generate
        if (N == 1) begin
            // Base case: just assign input to output with zero extension
            assign out_sum = {{($clog2(N)){1'b0}}, in_vector};
        end else begin
            localparam N2 = N / 2;
            localparam WIDTH_LOWER = W + $clog2(N2);
            wire [WIDTH_LOWER-1:0] left_sum;
            wire [WIDTH_LOWER-1:0] right_sum;

            sum_tree_recursive #(
                .N(N2),
                .W(W)
            ) left_inst (
                .in_vector(in_vector[(N2*W)-1:0]),
                .out_sum(left_sum)
            );

            sum_tree_recursive #(
                .N(N2),
                .W(W)
            ) right_inst (
                .in_vector(in_vector[N*W-1:N2*W]),
                .out_sum(right_sum)
            );

            // Add left_sum and right_sum, output width = WIDTH_LOWER + 1
            assign out_sum = left_sum + right_sum;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Partition input into 15 chunks of 17 bits each: total 255 bits
    localparam CHUNKS = 15;
    localparam CHUNK_WIDTH = 17;

    // Partial popcounts: 5 bits each
    wire [4:0] partial_counts [0:CHUNKS-1];

    genvar i;
    generate
        for (i=0; i<CHUNKS; i=i+1) begin : gen_pop17_chunks
            popcount17 pc17(
                .in(in[i*CHUNK_WIDTH +: CHUNK_WIDTH]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Flatten partial_counts array into a vector
    wire [CHUNKS*5-1:0] partial_flat;
    generate
        for(i=0; i<CHUNKS; i=i+1) begin : flatten_partial
            assign partial_flat[i*5 +: 5] = partial_counts[i];
        end
    endgenerate

    // The sum_tree_recursive requires N to be a power of two,
    // We have N=15, so pad with one zero partial count to make 16
    wire [4:0] partial_counts_padded [0:CHUNKS]; // one extra element
    generate
        for(i=0; i<CHUNKS; i=i+1) begin
            assign partial_counts_padded[i] = partial_counts[i];
        end
        assign partial_counts_padded[CHUNKS] = 5'd0; // zero padding
    endgenerate

    wire [16*5-1:0] padded_flat;
    generate
        for(i=0; i<16; i=i+1) begin
            assign padded_flat[i*5 +: 5] = partial_counts_padded[i];
        end
    endgenerate

    // Instantiate sum_tree_recursive with N=16, W=5
    wire [5 + $clog2(16)-1:0] sum_out; // Width=5+4=9 bits

    sum_tree_recursive #(
        .N(16),
        .W(5)
    ) sum_tree_inst (
        .in_vector(padded_flat),
        .out_sum(sum_out)
    );

    // The maximum popcount is 255 (8 bits)
    // sum_out is 9 bits due to padding and summation bits, upper bit can be ignored
    assign out = sum_out[7:0];
endmodule