module popcount8 (
    input  [7:0] in,
    output [3:0] out  // max 8 ones => 4 bits
);
    // LUT-based simple bit count using adders (adder tree)
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum46 = in[4] + in[5];
    wire [1:0] sum57 = in[6] + in[7];

    wire [2:0] sum0123 = sum02 + sum13; // max 4
    wire [2:0] sum4567 = sum46 + sum57; // max 4

    assign out = sum0123 + sum4567; // max 8
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out  // max 7 ones => 4 bits (uniform width)
);
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum45 = in[4] + in[5];
    wire       bit6 = in[6];

    wire [2:0] sum0123 = sum02 + sum13;  // max 4
    wire [2:0] sum4546 = sum45 + bit6;   // max 3

    assign out = sum0123 + sum4546;      // max 7
endmodule

// Recursive balanced summation tree for vector of counts.
// INPUT_WIDTH = number of counts to sum (power of two).
// COUNT_WIDTH = width of each count element.
// Output width is ceil(log2(INPUT_WIDTH)) + COUNT_WIDTH to hold sum safely.
module popcount_sum #(
    parameter INPUT_WIDTH = 32,    // number of counts
    parameter COUNT_WIDTH = 4      // bitwidth per count
) (
    input  [(INPUT_WIDTH*COUNT_WIDTH)-1:0] in,
    output [ $clog2(INPUT_WIDTH) + COUNT_WIDTH - 1 : 0 ] out
);
    generate
        if (INPUT_WIDTH == 1) begin : base
            assign out = in[COUNT_WIDTH-1:0];
        end else begin : recur
            localparam HALF = INPUT_WIDTH / 2;
            wire [ (HALF*COUNT_WIDTH)-1 : 0 ] in_left;
            wire [ (HALF*COUNT_WIDTH)-1 : 0 ] in_right;

            assign in_left  = in[ (HALF*COUNT_WIDTH)-1 : 0];
            assign in_right = in[ (INPUT_WIDTH*COUNT_WIDTH)-1 : HALF*COUNT_WIDTH];

            wire [ $clog2(HALF) + COUNT_WIDTH -1 : 0 ] sum_left;
            wire [ $clog2(HALF) + COUNT_WIDTH -1 : 0 ] sum_right;

            popcount_sum #(
                .INPUT_WIDTH(HALF),
                .COUNT_WIDTH(COUNT_WIDTH)
            ) left_sum (
                .in(in_left),
                .out(sum_left)
            );

            popcount_sum #(
                .INPUT_WIDTH(HALF),
                .COUNT_WIDTH(COUNT_WIDTH)
            ) right_sum (
                .in(in_right),
                .out(sum_right)
            );

            // Sum of sums
            assign out = sum_left + sum_right;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Parameters for chunking
    localparam NUM_CHUNKS = 32;
    localparam CHUNK_BITS = 8; // except last chunk is 7 bits

    // Partial counts array: 32 chunks, each 4 bits (max 8 for 8-bit chunk, max 7 for last)
    wire [3:0] partial_counts [0:NUM_CHUNKS-1];

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS-1; i = i + 1) begin : gen_pop8_chunks
            popcount8 u_pop8 (
                .in(in[i*CHUNK_BITS +: CHUNK_BITS]),
                .out(partial_counts[i])
            );
        end
        // Last chunk of 7 bits (bits 254 down to 248)
        popcount7 u_pop7 (
            .in(in[254:248]),
            .out(partial_counts[NUM_CHUNKS-1])
        );
    endgenerate

    // Flatten partial_counts array into a wide vector for popcount_sum module input
    wire [(NUM_CHUNKS*4)-1:0] partial_counts_flat;
    generate
        for (i=0; i<NUM_CHUNKS; i=i+1) begin : flatten_partial_counts
            assign partial_counts_flat[(i+1)*4-1 -: 4] = partial_counts[i];
        end
    endgenerate

    // Use recursive summation tree on partial_counts to sum 32 counts (4-bit each)
    // Output width = clog2(32) + 4 = 5 + 4 = 9 bits => max sum = 255 fits in 8 bits, 9 bits safe
    wire [8:0] total_count;

    popcount_sum #(
        .INPUT_WIDTH(NUM_CHUNKS),
        .COUNT_WIDTH(4)
    ) sum_tree (
        .in(partial_counts_flat),
        .out(total_count)
    );

    // Output lower 8 bits (max 255)
    assign out = total_count[7:0];

endmodule