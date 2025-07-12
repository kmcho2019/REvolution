`timescale 1ns/1ps

module popcount2 (
    input  wire [1:0] in,
    output wire [2:0] out
);
    // Sum of 2 bits (max 2) fits in 2 bits, output width 3 bits for margin
    assign out = in[0] + in[1];
endmodule

module popcount3 (
    input  wire [2:0] in,
    output wire [2:0] out
);
    // Sum of 3 bits (max 3) fits in 2 bits, output width 3 bits for margin
    assign out = in[0] + in[1] + in[2];
endmodule

module popcount_generic #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] in,
    output wire [clog2(WIDTH+1)-1:0] out
);
    // Recursive popcount by splitting input into halves and summing partial counts

    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value-1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    localparam OUT_WIDTH = clog2(WIDTH+1);

    generate
        if (WIDTH == 1) begin : base1
            assign out = in;
        end else if (WIDTH == 2) begin : base2
            wire [2:0] sum2;
            popcount2 pc2_inst (.in(in), .out(sum2));
            assign out = sum2[OUT_WIDTH-1:0];
        end else if (WIDTH == 3) begin : base3
            wire [2:0] sum3;
            popcount3 pc3_inst (.in(in), .out(sum3));
            assign out = sum3[OUT_WIDTH-1:0];
        end else begin : recursive
            localparam L1 = WIDTH / 2;
            localparam L2 = WIDTH - L1;
            wire [clog2(L1+1)-1:0] left_count;
            wire [clog2(L2+1)-1:0] right_count;

            popcount_generic #(L1) left_popcount (.in(in[L1-1:0]), .out(left_count));
            popcount_generic #(L2) right_popcount (.in(in[WIDTH-1:L1]), .out(right_count));

            // Sum partial counts, extended to OUT_WIDTH bits
            wire [OUT_WIDTH-1:0] left_ext = {{(OUT_WIDTH - $bits(left_count)){1'b0}}, left_count};
            wire [OUT_WIDTH-1:0] right_ext = {{(OUT_WIDTH - $bits(right_count)){1'b0}}, right_count};
            assign out = left_ext + right_ext;
        end
    endgenerate
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0] out
);
    // Partition input into 5 groups of 51 bits (5*51=255)
    // For each 51-bit chunk, use recursive popcount_generic
    // Max count per 51-bit chunk is 51 -> needs 6 bits output

    localparam CHUNK_SIZE = 51;
    localparam NUM_CHUNKS = 5;
    localparam PARTIAL_WIDTH = 6; // ceil(log2(52))=6

    wire [PARTIAL_WIDTH-1:0] partial_counts [NUM_CHUNKS-1:0];

    genvar i;
    generate
        for (i=0; i<NUM_CHUNKS; i=i+1) begin : popcount_chunks
            popcount_generic #(CHUNK_SIZE) pc_inst (
                .in(in[i*CHUNK_SIZE +: CHUNK_SIZE]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Sum partial counts using balanced adder tree
    // Width expansion:
    // partial_counts: 6 bits each max 51
    // sum of two 6-bit numbers max 102, needs 7 bits
    // sum of two 7-bit numbers max 204, needs 8 bits
    // sum of 8-bit + 6-bit max 255, fits in 8 bits output

    wire [6:0] sum01 = partial_counts[0] + partial_counts[1]; // 7 bits max 102
    wire [6:0] sum23 = partial_counts[2] + partial_counts[3]; // 7 bits max 102
    wire [7:0] sum0123 = sum01 + sum23;                      // 8 bits max 204
    wire [7:0] sum_final = sum0123 + {{2{1'b0}}, partial_counts[4]}; // zero-extend 6->8 bits

    assign out = sum_final;

endmodule