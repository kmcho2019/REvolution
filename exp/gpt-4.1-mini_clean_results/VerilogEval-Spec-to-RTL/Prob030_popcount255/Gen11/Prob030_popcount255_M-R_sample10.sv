`timescale 1ns/1ps

// Utility function for log2 ceiling
function integer clog2;
    input integer value;
    integer i;
    begin
        clog2 = 0;
        for (i = value-1; i > 0; i = i >> 1)
            clog2 = clog2 + 1;
    end
endfunction

// Base popcount for 1 to 3 bits using assign statements
module popcount_small #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] in,
    output [clog2(WIDTH+1)-1:0] out
);
    // Unrolled combinational sum
    integer i;
    reg [clog2(WIDTH+1)-1:0] sum;
    always @(*) begin
        sum = 0;
        for (i = 0; i < WIDTH; i = i + 1)
            sum = sum + in[i];
    end
    assign out = sum;
endmodule

// Binary tree popcount for arbitrary WIDTH > 3, using generate and assign only
module popcount_bin_tree #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output [clog2(WIDTH+1)-1:0] out
);
    // If WIDTH <= 3, use popcount_small directly
    // Else, split input into two halves, popcount each half, then add results
    localparam HALF1 = WIDTH / 2;
    localparam HALF2 = WIDTH - HALF1;

    // Output widths for halves
    localparam OUT_WIDTH_HALF1 = clog2(HALF1+1);
    localparam OUT_WIDTH_HALF2 = clog2(HALF2+1);

    wire [OUT_WIDTH_HALF1-1:0] count_left;
    wire [OUT_WIDTH_HALF2-1:0] count_right;

    generate
        if (WIDTH <= 3) begin : base_case
            popcount_small #(.WIDTH(WIDTH)) base_popcount(.in(in), .out(out));
        end else begin : recursive_case
            popcount_bin_tree #(.WIDTH(HALF1)) left_popcount (
                .in(in[HALF1-1:0]),
                .out(count_left)
            );
            popcount_bin_tree #(.WIDTH(HALF2)) right_popcount (
                .in(in[WIDTH-1:HALF1]),
                .out(count_right)
            );
            assign out = count_left + count_right;
        end
    endgenerate
endmodule


// Top-level module with 255-bit input split into five 51-bit groups
// Each 51-bit popcount uses popcount_bin_tree
// Then sum the five partial results in balanced adder tree with assign
module TopModule(
    input  [254:0] in,
    output [7:0]   out
);
    // Number of chunks and chunk size
    localparam CHUNKS = 5;
    localparam CHUNK_SIZE = 51;

    // Partial sums: max 51 ones => 6 bits needed
    wire [5:0] partial_counts [CHUNKS-1:0];

    genvar i;
    generate
        for (i = 0; i < CHUNKS; i = i + 1) begin : popcount_chunks
            popcount_bin_tree #(.WIDTH(CHUNK_SIZE)) pc_chunk (
                .in(in[i*CHUNK_SIZE +: CHUNK_SIZE]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Balanced adder tree to sum the 5 partial 6-bit results into 8-bit output
    // Stage 1: sum pairs
    wire [6:0] sum01 = partial_counts[0] + partial_counts[1]; // max 102 -> 7 bits
    wire [6:0] sum23 = partial_counts[2] + partial_counts[3]; // max 102 -> 7 bits

    // Stage 2: sum stage 1 results
    wire [7:0] sum0123 = sum01 + sum23; // max 204 -> 8 bits

    // Stage 3: add fifth chunk
    wire [7:0] sum_final = sum0123 + partial_counts[4]; // max 204 + 51 = 255 max -> 8 bits

    assign out = sum_final;

endmodule