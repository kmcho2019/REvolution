module popcount_generic #(parameter WIDTH = 1) (
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);
    // Recursive parameterized popcount using binary splitting.
    // Base case WIDTH=1: out = in
    // Recursive case: split into two parts, count each and add

    generate
        if (WIDTH == 1) begin : base_case
            assign out = in;
        end else begin : recursive_case
            localparam LEFT_WIDTH = WIDTH / 2;
            localparam RIGHT_WIDTH = WIDTH - LEFT_WIDTH;

            wire [$clog2(LEFT_WIDTH+1)-1:0] left_count;
            wire [$clog2(RIGHT_WIDTH+1)-1:0] right_count;

            popcount_generic #(LEFT_WIDTH) left_pop (
                .in(in[WIDTH-1:WIDTH-LEFT_WIDTH]),
                .out(left_count)
            );

            popcount_generic #(RIGHT_WIDTH) right_pop (
                .in(in[RIGHT_WIDTH-1:0]),
                .out(right_count)
            );

            assign out = left_count + right_count;
        end
    endgenerate
endmodule


module TopModule (
    input  wire [254:0] in,
    output wire [7:0]   out
);
    // Partition input into 5 chunks of 51 bits each
    // Each partial popcount outputs 6 bits because max count in 51 bits is 51 (< 64)
    localparam CHUNK_WIDTH = 51;
    localparam NUM_CHUNKS = 5;

    wire [$clog2(CHUNK_WIDTH+1)-1:0] partial_counts [NUM_CHUNKS-1:0];

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : popcount_chunks
            popcount_generic #(CHUNK_WIDTH) pc (
                .in(in[i*CHUNK_WIDTH +: CHUNK_WIDTH]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Sum the 5 partial counts with balanced adders:
    // sum01 = partial_counts[0] + partial_counts[1]
    // sum23 = partial_counts[2] + partial_counts[3]
    // sum0123 = sum01 + sum23
    // sum_final = sum0123 + partial_counts[4]

    // Width sizing:
    // partial_counts[i] : 6 bits
    // sum01, sum23       : 7 bits (max 102)
    // sum0123            : 8 bits (max 204)
    // sum_final          : 8 bits (max 255, fits in 8 bits output)

    wire [6:0] sum01 = partial_counts[0] + partial_counts[1];
    wire [6:0] sum23 = partial_counts[2] + partial_counts[3];
    wire [7:0] sum0123 = sum01 + sum23;
    wire [7:0] sum_final = sum0123 + partial_counts[4];

    assign out = sum_final;

endmodule