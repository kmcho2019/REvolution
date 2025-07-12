module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones -> 4 bits
);
    // Structural balanced adder tree summing 8 bits
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out // max 7 ones -> 4 bits (uniform width)
);
    // Structural balanced adder tree summing 7 bits (pad to 8 bits with 0)
    wire [7:0] padded_in = {1'b0, in}; // prepend zero MSB to make 8 bits

    popcount8 pc8 (
        .in(padded_in),
        .out(out)
    );
endmodule

// Recursive summation tree module:
// Input: N inputs of INPUT_WIDTH bits each (packed into in_vector)
// Output: sum of all inputs, width = ceil(log2(N*(2^INPUT_WIDTH -1)+1))
module recursive_sum #(
    parameter integer N = 1,
    parameter integer INPUT_WIDTH = 4
) (
    input  wire [N*INPUT_WIDTH-1:0] in_vector,
    output wire [$clog2(N*(2**INPUT_WIDTH-1)+1)-1:0] out_sum
);
    // If N=1, output directly (base case)
    generate
        if (N == 1) begin : base
            assign out_sum = in_vector;
        end else begin : recursive_case
            localparam integer N_LEFT = N / 2;
            localparam integer N_RIGHT = N - N_LEFT;
            localparam integer LEFT_WIDTH = N_LEFT * INPUT_WIDTH;
            localparam integer RIGHT_WIDTH = N_RIGHT * INPUT_WIDTH;

            wire [$clog2(N_LEFT*(2**INPUT_WIDTH-1)+1)-1:0] left_sum;
            wire [$clog2(N_RIGHT*(2**INPUT_WIDTH-1)+1)-1:0] right_sum;

            // Left half recursive sum
            recursive_sum #(
                .N(N_LEFT),
                .INPUT_WIDTH(INPUT_WIDTH)
            ) left_inst (
                .in_vector(in_vector[LEFT_WIDTH-1:0]),
                .out_sum(left_sum)
            );

            // Right half recursive sum
            recursive_sum #(
                .N(N_RIGHT),
                .INPUT_WIDTH(INPUT_WIDTH)
            ) right_inst (
                .in_vector(in_vector[N*INPUT_WIDTH-1:LEFT_WIDTH]),
                .out_sum(right_sum)
            );

            // Compute output width = ceil(log2(N*(2^INPUT_WIDTH-1)+1))
            localparam integer SUM_WIDTH = $clog2(N*(2**INPUT_WIDTH-1)+1);

            // Zero extend both sums to SUM_WIDTH before addition
            wire [SUM_WIDTH-1:0] left_sum_zext  = {{(SUM_WIDTH - $bits(left_sum)){1'b0}}, left_sum};
            wire [SUM_WIDTH-1:0] right_sum_zext = {{(SUM_WIDTH - $bits(right_sum)){1'b0}}, right_sum};

            assign out_sum = left_sum_zext + right_sum_zext;
        end
    endgenerate
endmodule

// Parameterized popcount for inputs <= 8 bits using structural balanced popcount8
module popcount_small #(
    parameter integer WIDTH = 8
) (
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);
    generate
        if (WIDTH == 8) begin : exact8
            popcount8 pc8 (
                .in(in),
                .out(out)
            );
        end else begin : less8
            // Pad MSBs with zeros to 8 bits
            wire [7:0] padded_in = { {(8-WIDTH){1'b0}}, in };
            popcount8 pc8 (
                .in(padded_in),
                .out(out)
            );
        end
    endgenerate
endmodule

// Top-level module: 255-bit popcount
module TopModule (
    input  wire [254:0] in,
    output wire [7:0] out
);
    // Parameters
    localparam integer NUM_FULL_CHUNKS = 31; // 31 chunks of 8 bits
    localparam integer NUM_CHUNKS = NUM_FULL_CHUNKS + 1; // 31 + 1 chunk of 7 bits

    // Partial counts: each 4 bits wide (max count 8 or 7)
    wire [3:0] partial_counts [0:NUM_CHUNKS-1];

    genvar i;
    generate
        // 31 chunks of 8 bits
        for (i=0; i<NUM_FULL_CHUNKS; i=i+1) begin : gen_pop8_chunks
            popcount8 pc8_inst (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
        // 1 chunk of 7 bits (bits 254 down to 248)
        popcount7 pc7_inst (
            .in(in[254:248]),
            .out(partial_counts[NUM_CHUNKS-1])
        );
    endgenerate

    // Flatten partial_counts array to a single vector for recursive summation
    wire [(NUM_CHUNKS*4)-1:0] partial_counts_flat;
    generate
        for (i=0; i<NUM_CHUNKS; i=i+1) begin : flatten_partial
            assign partial_counts_flat[i*4 +: 4] = partial_counts[i];
        end
    endgenerate

    // Recursive summation of 32 inputs of 4 bits each
    // Max sum = 31*8 + 7 = 255; here max partial count is 8 (4 bits), 32 inputs => max 256
    // So output width must be at least 9 bits: ceil(log2(32*(2^4-1)+1))=9 bits
    wire [8:0] total_popcount;

    recursive_sum #(
        .N(NUM_CHUNKS),
        .INPUT_WIDTH(4)
    ) sum_tree (
        .in_vector(partial_counts_flat),
        .out_sum(total_popcount)
    );

    // The maximum popcount for 255 bits is 255 (8 bits)
    // total_popcount is 9 bits wide to avoid overflow in intermediate sums, upper bit should be zero.
    assign out = total_popcount[7:0];

endmodule