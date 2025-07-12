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

    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : chunk_rev
            // Each BitRevN instance reverses a 10-bit chunk from input
            // The output chunks are assigned in reverse order to form full reversed 100-bit output
            BitRevN #(CHUNK_SIZE) bitrev_inst (
                .in(in[i*CHUNK_SIZE +: CHUNK_SIZE]),
                .out(out[(NUM_CHUNKS - 1 - i)*CHUNK_SIZE +: CHUNK_SIZE])
            );
        end
    endgenerate
endmodule