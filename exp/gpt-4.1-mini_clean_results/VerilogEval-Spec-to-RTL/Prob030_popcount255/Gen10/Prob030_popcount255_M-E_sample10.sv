module popcount5 (
    input  [4:0] in,
    output [2:0] out  // max 5 ones -> needs 3 bits
);
    // LUT-based popcount5 using adders
    wire [1:0] sum01 = in[0] + in[1];
    wire [1:0] sum23 = in[2] + in[3];
    wire [2:0] sum0123 = sum01 + sum23; // max 4
    assign out = sum0123 + in[4];       // max 5
endmodule

// Adder stage module: sums pairs of elements of input array.
// INPUT_ELEMS: number of elements in input (must be even)
// IN_WIDTH: bit width of each input element
// OUT_WIDTH: bit width of each output element (usually IN_WIDTH+1)
// Produces an output vector with half the number of elements
module popcount_adder_stage #(
    parameter INPUT_ELEMS = 2,
    parameter IN_WIDTH = 3
) (
    input  [INPUT_ELEMS*IN_WIDTH-1:0] in,
    output [(INPUT_ELEMS/2)*(IN_WIDTH+1)-1:0] out
);
    localparam OUT_WIDTH = IN_WIDTH + 1;
    genvar i;
    generate
        for (i=0; i<INPUT_ELEMS/2; i=i+1) begin : gen_adders
            wire [IN_WIDTH-1:0] a = in[(2*i+1)*IN_WIDTH-1 -: IN_WIDTH];
            wire [IN_WIDTH-1:0] b = in[(2*i)*IN_WIDTH-1   -: IN_WIDTH];
            assign out[(i+1)*OUT_WIDTH-1 -: OUT_WIDTH] = a + b;
        end
    endgenerate
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Parameters
    localparam CHUNK_BITS = 5;
    localparam NUM_CHUNKS = 51; // ceil(255/5) = 51
    localparam CHUNK_IN_WIDTH = CHUNK_BITS;
    localparam CHUNK_OUT_WIDTH = 3; // popcount5 outputs 3 bits

    // Split input into 51 chunks of 5 bits; last chunk is padded with zeros if needed
    wire [CHUNK_IN_WIDTH-1:0] chunks [0:NUM_CHUNKS-1];
    genvar i;
    generate
        for (i=0; i<NUM_CHUNKS; i=i+1) begin : gen_chunks
            if (i == NUM_CHUNKS-1) begin
                // Last chunk: bits from i*5 to 254, may be less than 5 bits
                localparam LAST_BITS = 255 - i*5;
                wire [CHUNK_IN_WIDTH-1:0] last_chunk_bits = { { (CHUNK_BITS-LAST_BITS){1'b0} }, in[i*5 +: LAST_BITS] };
                assign chunks[i] = last_chunk_bits;
            end else begin
                assign chunks[i] = in[i*5 +: CHUNK_BITS];
            end
        end
    endgenerate

    // Calculate popcount for each 5-bit chunk
    wire [CHUNK_OUT_WIDTH-1:0] partial_counts [0:NUM_CHUNKS-1];
    generate
        for (i=0; i<NUM_CHUNKS; i=i+1) begin : gen_popcounts
            popcount5 pc5 (
                .in(chunks[i]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Flatten partial_counts for adder tree input
    wire [NUM_CHUNKS*CHUNK_OUT_WIDTH-1:0] stage0_in;
    generate
        for (i=0; i<NUM_CHUNKS; i=i+1) begin : flatten_pc
            assign stage0_in[(i+1)*CHUNK_OUT_WIDTH-1 -: CHUNK_OUT_WIDTH] = partial_counts[i];
        end
    endgenerate

    // We need a balanced tree summing 51 inputs (3-bit each)
    // Since 51 is not power of two, pad with zeros to 64 (next power of two)
    localparam PADDED_CHUNKS = 64;
    localparam PAD_BITS = (PADDED_CHUNKS - NUM_CHUNKS)*CHUNK_OUT_WIDTH;
    wire [PADDED_CHUNKS*CHUNK_OUT_WIDTH-1:0] padded_stage0_in = { {PAD_BITS{1'b0}}, stage0_in };

    // Stage 1: sum pairs of 3-bit counts -> 32 outputs of width 4 bits (3+1)
    wire [32*4-1:0] stage1_out;
    popcount_adder_stage #(
        .INPUT_ELEMS(PADDED_CHUNKS),
        .IN_WIDTH(CHUNK_OUT_WIDTH)
    ) stage1 (
        .in(padded_stage0_in),
        .out(stage1_out)
    );

    // Stage 2: sum pairs of 4-bit counts -> 16 outputs of width 5 bits
    wire [16*5-1:0] stage2_out;
    popcount_adder_stage #(
        .INPUT_ELEMS(32),
        .IN_WIDTH(4)
    ) stage2 (
        .in(stage1_out),
        .out(stage2_out)
    );

    // Stage 3: sum pairs of 5-bit counts -> 8 outputs of width 6 bits
    wire [8*6-1:0] stage3_out;
    popcount_adder_stage #(
        .INPUT_ELEMS(16),
        .IN_WIDTH(5)
    ) stage3 (
        .in(stage2_out),
        .out(stage3_out)
    );

    // Stage 4: sum pairs of 6-bit counts -> 4 outputs of width 7 bits
    wire [4*7-1:0] stage4_out;
    popcount_adder_stage #(
        .INPUT_ELEMS(8),
        .IN_WIDTH(6)
    ) stage4 (
        .in(stage3_out),
        .out(stage4_out)
    );

    // Stage 5: sum pairs of 7-bit counts -> 2 outputs of width 8 bits
    wire [2*8-1:0] stage5_out;
    popcount_adder_stage #(
        .INPUT_ELEMS(4),
        .IN_WIDTH(7)
    ) stage5 (
        .in(stage4_out),
        .out(stage5_out)
    );

    // Stage 6: sum last pair of 8-bit counts -> 1 output of width 9 bits
    wire [8:0] final_sum;
    popcount_adder_stage #(
        .INPUT_ELEMS(2),
        .IN_WIDTH(8)
    ) stage6 (
        .in(stage5_out),
        .out(final_sum)
    );

    // final_sum max is <= 255, which fits in 8 bits, but output is 9 bits to be safe
    // Assign lower 8 bits as output
    assign out = final_sum[7:0];

endmodule