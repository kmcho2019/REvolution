module BitRevN #(parameter N = 10) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
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

    genvar chunk_idx, bit_idx;

    generate
        for (chunk_idx = 0; chunk_idx < NUM_CHUNKS; chunk_idx = chunk_idx + 1) begin : chunk_loop
            for (bit_idx = 0; bit_idx < CHUNK_SIZE; bit_idx = bit_idx + 1) begin : bit_loop
                // Reverse bits inside each chunk and reverse chunk order
                assign out[(NUM_CHUNKS - 1 - chunk_idx)*CHUNK_SIZE + bit_idx] 
                    = in[chunk_idx*CHUNK_SIZE + (CHUNK_SIZE - 1 - bit_idx)];
            end
        end
    endgenerate
endmodule