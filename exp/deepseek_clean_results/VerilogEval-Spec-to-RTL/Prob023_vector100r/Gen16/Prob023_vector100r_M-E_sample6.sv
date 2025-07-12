module TopModule (
    input  [99:0] in,
    output [99:0] out
);

localparam CHUNK_SIZE = 10;
localparam NUM_CHUNKS = 100/CHUNK_SIZE;

// First reverse the order of chunks
wire [99:0] chunk_reversed;
genvar i;
generate
    for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : chunk_reversal
        assign chunk_reversed[(i+1)*CHUNK_SIZE-1:i*CHUNK_SIZE] = 
               in[(NUM_CHUNKS-i)*CHUNK_SIZE-1:(NUM_CHUNKS-i-1)*CHUNK_SIZE];
    end
endgenerate

// Then reverse bits within each chunk
genvar j, k;
generate
    for (j = 0; j < NUM_CHUNKS; j = j + 1) begin : bit_reversal
        for (k = 0; k < CHUNK_SIZE; k = k + 1) begin : reverse_bits
            assign out[j*CHUNK_SIZE + k] = chunk_reversed[j*CHUNK_SIZE + (CHUNK_SIZE-1-k)];
        end
    end
endgenerate

endmodule