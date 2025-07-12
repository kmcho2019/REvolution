module BitRevN #(parameter N = 10) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse_loop
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    localparam CHUNK_SIZE = 10;
    localparam NUM_CHUNKS = 100 / CHUNK_SIZE;

    // Declare arrays for chunks and reversed chunks
    wire [CHUNK_SIZE-1:0] chunk [0:NUM_CHUNKS-1];
    wire [CHUNK_SIZE-1:0] rev_chunk [0:NUM_CHUNKS-1];

    genvar idx;
    generate
        for (idx = 0; idx < NUM_CHUNKS; idx = idx + 1) begin : chunk_processing
            // Partition input into 10-bit chunks
            assign chunk[idx] = in[ (idx+1)*CHUNK_SIZE -1 : idx*CHUNK_SIZE ];

            // Instantiate reusable parameterized bit reversal for each chunk
            BitRevN #(CHUNK_SIZE) bitrev_inst (
                .in(chunk[idx]),
                .out(rev_chunk[idx])
            );
        end
    endgenerate

    // Concatenate reversed chunks in reverse order to form the fully reversed 100-bit output
    assign out = {
        rev_chunk[NUM_CHUNKS-1], rev_chunk[NUM_CHUNKS-2], rev_chunk[NUM_CHUNKS-3], rev_chunk[NUM_CHUNKS-4],
        rev_chunk[NUM_CHUNKS-5], rev_chunk[NUM_CHUNKS-6], rev_chunk[NUM_CHUNKS-7], rev_chunk[NUM_CHUNKS-8],
        rev_chunk[NUM_CHUNKS-9], rev_chunk[NUM_CHUNKS-10]
    };

endmodule