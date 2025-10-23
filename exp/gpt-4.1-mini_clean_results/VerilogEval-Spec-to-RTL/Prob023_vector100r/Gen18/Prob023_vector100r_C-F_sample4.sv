module BitRev #(parameter N = 10) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reversal
            assign out[i] = in[N-1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    localparam CHUNK_SIZE = 10;
    localparam NUM_CHUNKS = 100 / CHUNK_SIZE; // 10

    // Declare wires for the chunks and their reversed outputs
    wire [CHUNK_SIZE-1:0] chunks    [0:NUM_CHUNKS-1];
    wire [CHUNK_SIZE-1:0] rev_chunks[0:NUM_CHUNKS-1];

    genvar idx;
    generate
        for (idx = 0; idx < NUM_CHUNKS; idx = idx + 1) begin : chunk_processing
            // Slice input into 10-bit chunks
            assign chunks[idx] = in[(idx+1)*CHUNK_SIZE -1 : idx*CHUNK_SIZE];

            // Instantiate BitRev for each chunk with pure wiring reversal
            BitRev #(CHUNK_SIZE) bitrev_inst (
                .in(chunks[idx]),
                .out(rev_chunks[idx])
            );
        end
    endgenerate

    // Concatenate reversed chunks in reverse order for full 100-bit reversal
    assign out = { rev_chunks[NUM_CHUNKS-1], rev_chunks[NUM_CHUNKS-2], rev_chunks[NUM_CHUNKS-3], rev_chunks[NUM_CHUNKS-4],
                   rev_chunks[NUM_CHUNKS-5], rev_chunks[NUM_CHUNKS-6], rev_chunks[NUM_CHUNKS-7], rev_chunks[NUM_CHUNKS-8],
                   rev_chunks[NUM_CHUNKS-9], rev_chunks[NUM_CHUNKS-10] };

endmodule