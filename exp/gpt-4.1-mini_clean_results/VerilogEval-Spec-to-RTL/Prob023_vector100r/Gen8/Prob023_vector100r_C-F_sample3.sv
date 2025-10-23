module BitRevN #(parameter N = 10) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    localparam CHUNK_SIZE = 10;
    localparam NUM_CHUNKS = 100 / CHUNK_SIZE; // 10

    wire [CHUNK_SIZE-1:0] chunks_in  [0:NUM_CHUNKS-1];
    wire [CHUNK_SIZE-1:0] chunks_out [0:NUM_CHUNKS-1];

    genvar idx;
    generate
        for (idx = 0; idx < NUM_CHUNKS; idx = idx + 1) begin : chunk_proc
            assign chunks_in[idx] = in[idx*CHUNK_SIZE +: CHUNK_SIZE];
            BitRevN #(CHUNK_SIZE) bitrev_inst (
                .in(chunks_in[idx]),
                .out(chunks_out[idx])
            );
        end
    endgenerate

    generate
        for (idx = 0; idx < NUM_CHUNKS; idx = idx + 1) begin : chunk_out_assign
            assign out[idx*CHUNK_SIZE +: CHUNK_SIZE] = chunks_out[NUM_CHUNKS - 1 - idx];
        end
    endgenerate

endmodule