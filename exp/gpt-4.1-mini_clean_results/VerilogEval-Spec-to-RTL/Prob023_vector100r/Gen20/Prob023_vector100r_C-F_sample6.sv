module BitRevChunk #(parameter WIDTH = 10) (
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bitrev_chunk
            assign out[i] = in[WIDTH - 1 - i];
        end
    endgenerate
endmodule

module BitRevN #(parameter N = 100, parameter CHUNK = 10) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    localparam NUM_CHUNKS = (N + CHUNK - 1) / CHUNK; // ceiling division

    // Split input into chunks (pad last chunk if needed)
    wire [CHUNK-1:0] chunks_in  [NUM_CHUNKS-1:0];
    wire [CHUNK-1:0] chunks_out [NUM_CHUNKS-1:0];

    genvar j;
    generate
        for (j = 0; j < NUM_CHUNKS; j = j + 1) begin : chunk_process
            // Calculate chunk boundaries
            localparam int UPPER = (j+1)*CHUNK-1 < N ? (j+1)*CHUNK-1 : N-1;
            localparam int LOWER = j*CHUNK;

            // Extract chunk input, padding with zeros if last chunk smaller than CHUNK
            wire [CHUNK-1:0] chunk_in_wide;
            if (UPPER - LOWER + 1 < CHUNK) begin : last_chunk_pad
                assign chunk_in_wide = { {(CHUNK - (UPPER - LOWER +1)){1'b0}}, in[UPPER:LOWER] };
            end else begin : normal_chunk
                assign chunk_in_wide = in[UPPER:LOWER];
            end
            assign chunks_in[j] = chunk_in_wide;

            // Reverse bits within the chunk
            BitRevChunk #(CHUNK) rev_inst (
                .in(chunks_in[j]),
                .out(chunks_out[j])
            );
        end
    endgenerate

    // Concatenate reversed chunks in reverse order, trimming padded zeros for last chunk if needed
    generate
        for (j = 0; j < NUM_CHUNKS; j = j + 1) begin : concat_rev
            localparam int OUT_UPPER = (j+1)*CHUNK-1 < N ? (j+1)*CHUNK-1 : N-1;
            localparam int OUT_LOWER = j*CHUNK;
            localparam int CHUNK_WIDTH = OUT_UPPER - OUT_LOWER +1;
            // Assign only valid bits for possibly partial chunk
            assign out[OUT_UPPER:OUT_LOWER] = chunks_out[NUM_CHUNKS - 1 - j][CHUNK-1 -: CHUNK_WIDTH];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Instantiate BitRevN for 100-bit reversal with 10-bit chunks
    BitRevN #(100, 10) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule