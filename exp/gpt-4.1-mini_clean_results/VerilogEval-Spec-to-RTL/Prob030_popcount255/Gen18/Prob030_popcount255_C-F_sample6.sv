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
    output [3:0] out  // max 7 ones => 4 bits (uniform width)
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

// Parameterized recursive adder tree that sums an array of M elements,
// each ELEMENT_WIDTH bits wide, to produce the total sum with output width SUM_WIDTH
// This is a balanced binary adder tree implemented recursively.

module recursive_adder_tree #(
    parameter M = 1,
    parameter ELEMENT_WIDTH = 1,
    parameter SUM_WIDTH = $clog2(M * (2**ELEMENT_WIDTH - 1) + 1)
) (
    input  wire [M*ELEMENT_WIDTH-1:0] in_array,
    output wire [SUM_WIDTH-1:0]       out_sum
);

    generate
        if (M == 1) begin
            // Base case: output is the single element
            assign out_sum = in_array;
        end else begin
            localparam M_LEFT = M / 2;
            localparam M_RIGHT = M - M_LEFT;

            localparam LEFT_WIDTH = M_LEFT * ELEMENT_WIDTH;
            localparam RIGHT_WIDTH = M_RIGHT * ELEMENT_WIDTH;

            // Widths of partial sums
            localparam LEFT_SUM_WIDTH = $clog2(M_LEFT * (2**ELEMENT_WIDTH - 1) + 1);
            localparam RIGHT_SUM_WIDTH = $clog2(M_RIGHT * (2**ELEMENT_WIDTH - 1) + 1);

            wire [LEFT_SUM_WIDTH-1:0] left_sum;
            wire [RIGHT_SUM_WIDTH-1:0] right_sum;

            recursive_adder_tree #(
                .M(M_LEFT),
                .ELEMENT_WIDTH(ELEMENT_WIDTH),
                .SUM_WIDTH(LEFT_SUM_WIDTH)
            ) left_adder (
                .in_array(in_array[LEFT_WIDTH-1:0]),
                .out_sum(left_sum)
            );

            recursive_adder_tree #(
                .M(M_RIGHT),
                .ELEMENT_WIDTH(ELEMENT_WIDTH),
                .SUM_WIDTH(RIGHT_SUM_WIDTH)
            ) right_adder (
                .in_array(in_array[M*ELEMENT_WIDTH-1:LEFT_WIDTH]),
                .out_sum(right_sum)
            );

            // Sum left and right partial sums with zero extension to SUM_WIDTH bits
            wire [SUM_WIDTH-1:0] left_sum_ext = {{(SUM_WIDTH - LEFT_SUM_WIDTH){1'b0}}, left_sum};
            wire [SUM_WIDTH-1:0] right_sum_ext = {{(SUM_WIDTH - RIGHT_SUM_WIDTH){1'b0}}, right_sum};

            assign out_sum = left_sum_ext + right_sum_ext;
        end
    endgenerate
endmodule


module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);

    // Parameters for chunking input: 31 chunks of 8 bits, 1 chunk of 7 bits
    localparam NUM_FULL_CHUNKS = 31;
    localparam NUM_CHUNKS = 32;

    // Array of 4-bit partial counts (uniform width for all chunks)
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
        // Instantiate popcount7 for the last 7 bits [254:248]
        popcount7 pc7 (
            .in(in[254:248]),
            .out(partial_counts[NUM_CHUNKS-1])
        );
    endgenerate

    // Flatten the partial_counts array to a vector
    wire [NUM_CHUNKS*4-1:0] partial_counts_flat;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : flatten_partial
            assign partial_counts_flat[i*4 +: 4] = partial_counts[i];
        end
    endgenerate

    // Use recursive_adder_tree to sum partial counts
    // Max sum = 31*8 + 7 = 255 fits in 8 bits, but recursive_adder_tree uses wider width to prevent overflow
    localparam SUM_WIDTH = $clog2(NUM_CHUNKS * (2**4 -1) + 1); // $clog2(32*15 + 1) = 9 bits

    wire [SUM_WIDTH-1:0] total_count;

    recursive_adder_tree #(
        .M(NUM_CHUNKS),
        .ELEMENT_WIDTH(4),
        .SUM_WIDTH(SUM_WIDTH)
    ) adder_tree (
        .in_array(partial_counts_flat),
        .out_sum(total_count)
    );

    // Assign the final 8-bit output (population count max 255 fits in 8 bits)
    assign out = total_count[7:0];

endmodule