module popcount17 (
    input  [16:0] in,
    output [5:0] out // 6 bits for sum up to 17
);
    // Level 1: sum pairs of bits (2-bit results)
    wire [1:0] s0 = in[0] + in[1];
    wire [1:0] s1 = in[2] + in[3];
    wire [1:0] s2 = in[4] + in[5];
    wire [1:0] s3 = in[6] + in[7];
    wire [1:0] s4 = in[8] + in[9];
    wire [1:0] s5 = in[10] + in[11];
    wire [1:0] s6 = in[12] + in[13];
    wire [1:0] s7 = in[14] + in[15];
    wire leftover = in[16];

    // Level 2: sum pairs of 2-bit values (3-bit results)
    wire [2:0] s8  = s0 + s1;
    wire [2:0] s9  = s2 + s3;
    wire [2:0] s10 = s4 + s5;
    wire [2:0] s11 = s6 + s7;

    // Level 3: sum pairs of 3-bit values (4-bit results)
    wire [3:0] s12 = s8 + s9;
    wire [3:0] s13 = s10 + s11;

    // Level 4: sum two 4-bit values (5-bit result)
    wire [4:0] s14 = s12 + s13;

    // Add leftover bit, final 6-bit output
    assign out = s14 + leftover;

endmodule

// Recursive balanced adder tree for summing an array of N inputs each WIDTH bits wide,
// output width must be enough to hold sum of all inputs.
module popcount_sum_tree #(
    parameter WIDTH = 6,
    parameter N = 15
)(
    input  [WIDTH*N-1:0] in_flat, // flattened input array: N elements, WIDTH bits each
    output [$clog2(N*(2**WIDTH))+0:0] out // enough bits for max sum: N * (2^WIDTH-1)
);
    // Local parameters
    localparam OUT_WIDTH = $clog2(N*(2**WIDTH)); // Max possible sum bits

    // Base cases
    generate
        if (N == 1) begin
            // Direct assignment for single input element
            assign out = in_flat[WIDTH-1:0];
        end else if (N == 2) begin
            // Direct sum of two inputs
            wire [WIDTH-1:0] in0 = in_flat[WIDTH-1:0];
            wire [WIDTH-1:0] in1 = in_flat[2*WIDTH-1:WIDTH];
            assign out = in0 + in1;
        end else begin
            // Recursive case: split into two halves and sum recursively
            localparam N_L = N / 2;
            localparam N_R = N - N_L;

            // Extract left and right halves as flat vectors
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
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate 15 popcount17 modules for input partitions
    wire [5:0] partial_counts [0:14];

    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : popcount17_blocks
            popcount17 pc17 (
                .in(in[i*17 +: 17]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Flatten partial_counts array for the recursive sum tree
    wire [6*15-1:0] partial_counts_flat;
    // Concatenate partial counts in order: partial_counts[0] is LSB chunk
    genvar j;
    generate
        for (j = 0; j < 15; j = j + 1) begin : flatten_partial_counts
            assign partial_counts_flat[6*j +: 6] = partial_counts[j];
        end
    endgenerate

    // Use recursive sum tree to sum all 15 partial counts
    // Each partial count is 6 bits wide (max 17)
    // Max sum is 15 * 17 = 255, so 8 bits output
    wire [7:0] total_count;
    popcount_sum_tree #(
        .WIDTH(6),
        .N(15)
    ) sum_tree (
        .in_flat(partial_counts_flat),
        .out(total_count)
    );

    assign out = total_count;

endmodule