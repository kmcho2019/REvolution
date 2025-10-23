module BitRevN #(parameter N = 10) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    genvar i;
    generate
        for(i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);
    localparam CHUNK_SIZE = 10;
    localparam NUM_CHUNKS = 100 / CHUNK_SIZE;

    wire [CHUNK_SIZE-1:0] chunks_in   [0:NUM_CHUNKS-1];
    wire [CHUNK_SIZE-1:0] chunks_rev  [0:NUM_CHUNKS-1];

    genvar i;

    // Split input into 10 chunks of 10 bits
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : input_chunking
            assign chunks_in[i] = in[i*CHUNK_SIZE +: CHUNK_SIZE];
        end
    endgenerate

    // Reverse bits within each 10-bit chunk
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : chunk_bit_reverse
            BitRevN #(CHUNK_SIZE) bitrev_inst (
                .in(chunks_in[i]),
                .out(chunks_rev[i])
            );
        end
    endgenerate

    // Reverse the order of the chunks to form final output
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : output_assemble
            assign out[i*CHUNK_SIZE +: CHUNK_SIZE] = chunks_rev[NUM_CHUNKS - 1 - i];
        end
    endgenerate
endmodule