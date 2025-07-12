`timescale 1ns/1ps

// Base popcount modules for small widths
module popcount2 (
    input  wire [1:0] in,
    output wire [1:0] out // max sum=2 fits in 2 bits
);
    assign out = in[0] + in[1];
endmodule

module popcount3 (
    input  wire [2:0] in,
    output wire [2:0] out // max sum=3 fits in 2 bits, output 3 bits for margin
);
    assign out = in[0] + in[1] + in[2];
endmodule

// Recursive generic popcount module parameterized by WIDTH
module popcount_generic #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] in,
    output wire [$clog2(WIDTH+1)-1:0] out
);
    // Use Verilog system function $clog2
    localparam OUT_WIDTH = $clog2(WIDTH + 1);

    generate
        if (WIDTH == 1) begin : base1
            assign out = in;
        end else if (WIDTH == 2) begin : base2
            wire [1:0] sum2;
            popcount2 pc2 (.in(in), .out(sum2));
            assign out = sum2;
        end else if (WIDTH == 3) begin : base3
            wire [2:0] sum3;
            popcount3 pc3 (.in(in), .out(sum3));
            assign out = sum3;
        end else begin : recursive
            localparam L1 = WIDTH / 2;
            localparam L2 = WIDTH - L1;

            wire [$clog2(L1+1)-1:0] left_count;
            wire [$clog2(L2+1)-1:0] right_count;

            popcount_generic #(L1) pc_left (.in(in[L1-1:0]), .out(left_count));
            popcount_generic #(L2) pc_right (.in(in[WIDTH-1:L1]), .out(right_count));

            // Zero-extend partial counts to OUT_WIDTH bits and sum
            wire [OUT_WIDTH-1:0] left_ext = {{(OUT_WIDTH - $bits(left_count)){1'b0}}, left_count};
            wire [OUT_WIDTH-1:0] right_ext = {{(OUT_WIDTH - $bits(right_count)){1'b0}}, right_count};
            assign out = left_ext + right_ext;
        end
    endgenerate
endmodule

// Recursive balanced adder tree to sum an array of N elements each WIDTH bits wide
module popcount_sum_tree #(
    parameter WIDTH = 6,
    parameter N = 15
) (
    input  wire [WIDTH*N-1:0] in_flat,
    output wire [$clog2(N*(2**WIDTH-1)+1)-1:0] out
);
    localparam OUT_WIDTH = $clog2(N*(2**WIDTH-1)+1);

    generate
        if (N == 1) begin
            assign out = in_flat[WIDTH-1:0];
        end else if (N == 2) begin
            wire [WIDTH-1:0] in0 = in_flat[WIDTH-1:0];
            wire [WIDTH-1:0] in1 = in_flat[2*WIDTH-1:WIDTH];
            assign out = in0 + in1;
        end else begin
            localparam N_L = N / 2;
            localparam N_R = N - N_L;

            wire [WIDTH*N_L-1:0] in_left = in_flat[WIDTH*N_L-1:0];
            wire [WIDTH*N_R-1:0] in_right = in_flat[WIDTH*N-1:WIDTH*N_L];

            wire [OUT_WIDTH-1:0] sum_left;
            wire [OUT_WIDTH-1:0] sum_right;

            popcount_sum_tree #(.WIDTH(WIDTH), .N(N_L)) sum_left_inst (.in_flat(in_left), .out(sum_left));
            popcount_sum_tree #(.WIDTH(WIDTH), .N(N_R)) sum_right_inst (.in_flat(in_right), .out(sum_right));

            assign out = sum_left + sum_right;
        end
    endgenerate
endmodule

// TopModule: 255-bit input popcount, 8-bit output
module TopModule (
    input  wire [254:0] in,
    output wire [7:0] out
);
    // Constants
    localparam CHUNK_SIZE = 17;
    localparam NUM_CHUNKS = 15; // 15*17 = 255
    localparam PARTIAL_WIDTH = $clog2(CHUNK_SIZE + 1); // 5 bits for max 17, actually 5 bits but safe to use 6 bits

    // Partial counts for each chunk
    wire [PARTIAL_WIDTH-1:0] partial_counts [NUM_CHUNKS-1:0];

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : popcount_chunks
            popcount_generic #(CHUNK_SIZE) pc (
                .in(in[i*CHUNK_SIZE +: CHUNK_SIZE]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Flatten partial counts into one wide vector for the sum tree
    wire [PARTIAL_WIDTH*NUM_CHUNKS-1:0] partial_counts_flat;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : flatten_partial_counts
            assign partial_counts_flat[i*PARTIAL_WIDTH +: PARTIAL_WIDTH] = partial_counts[i];
        end
    endgenerate

    // Sum all partial counts using recursive balanced sum tree
    // Max total count = 255 (8 bits needed)
    wire [7:0] total_count;
    popcount_sum_tree #(
        .WIDTH(PARTIAL_WIDTH),
        .N(NUM_CHUNKS)
    ) sum_tree (
        .in_flat(partial_counts_flat),
        .out(total_count)
    );

    assign out = total_count;

endmodule