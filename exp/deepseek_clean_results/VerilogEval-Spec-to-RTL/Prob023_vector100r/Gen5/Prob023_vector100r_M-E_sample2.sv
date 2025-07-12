module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Parameters for hierarchical reversal
parameter CHUNK_SIZE = 10;
parameter NUM_CHUNKS = 100/CHUNK_SIZE;

// Reverse chunks first
wire [99:0] chunk_reversed;
genvar i;
generate
    for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : reverse_chunks
        // Reverse bits within each chunk
        localparam START = i * CHUNK_SIZE;
        localparam END = START + CHUNK_SIZE - 1;
        integer j;
        for (j = 0; j < CHUNK_SIZE; j = j + 1) begin : reverse_bits
            assign chunk_reversed[START + j] = in[END - j];
        end
    end
endgenerate

// Then reverse the order of chunks
genvar k;
generate
    for (k = 0; k < NUM_CHUNKS; k = k + 1) begin : reverse_chunk_order
        localparam CHUNK_START = k * CHUNK_SIZE;
        localparam CHUNK_END = CHUNK_START + CHUNK_SIZE - 1;
        assign out[CHUNK_START +: CHUNK_SIZE] = 
            chunk_reversed[(99 - CHUNK_END) +: CHUNK_SIZE];
    end
endgenerate

endmodule