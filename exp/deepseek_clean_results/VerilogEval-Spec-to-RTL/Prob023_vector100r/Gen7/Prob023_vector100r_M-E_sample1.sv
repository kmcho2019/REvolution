module TopModule #(
    parameter WIDTH = 100,
    parameter CHUNK_SIZE = 10
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Calculate number of chunks (round up)
    localparam NUM_CHUNKS = (WIDTH + CHUNK_SIZE - 1) / CHUNK_SIZE;
    
    // Pad input to multiple of CHUNK_SIZE
    wire [NUM_CHUNKS*CHUNK_SIZE-1:0] padded_in = {{(NUM_CHUNKS*CHUNK_SIZE-WIDTH){1'b0}}, in};
    
    // Macro reversal: Reverse order of chunks
    wire [NUM_CHUNKS*CHUNK_SIZE-1:0] chunk_reversed;
    generate
        genvar i;
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : macro_rev
            assign chunk_reversed[i*CHUNK_SIZE +: CHUNK_SIZE] = 
                   padded_in[(NUM_CHUNKS-1-i)*CHUNK_SIZE +: CHUNK_SIZE];
        end
    endgenerate
    
    // Micro reversal: Reverse bits within each chunk
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : micro_rev
            genvar j;
            for (j = 0; j < CHUNK_SIZE; j = j + 1) begin : bit_rev
                assign out[i*CHUNK_SIZE + j] = chunk_reversed[i*CHUNK_SIZE + (CHUNK_SIZE-1-j)];
            end
        end
    endgenerate
    
    // Trim any extra bits from padding
    assign out = out[WIDTH-1:0];

endmodule