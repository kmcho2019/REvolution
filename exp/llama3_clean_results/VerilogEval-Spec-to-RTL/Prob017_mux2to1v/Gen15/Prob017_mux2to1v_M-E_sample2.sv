// Novel Module TopModule implements a hierarchical 2-1 multiplexer.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Define parameters for the chunk size and the number of chunks.
parameter CHUNK_SIZE = 10;
parameter NUM_CHUNKS = 100 / CHUNK_SIZE;

// Declare wires for the intermediate outputs of each chunk.
wire [CHUNK_SIZE-1:0] chunk_out [NUM_CHUNKS-1:0];

// Instantiate a smaller multiplexer module for each chunk.
genvar i;
for (i = 0; i < NUM_CHUNKS; i++) begin
    // Calculate the start and end indices for the current chunk.
    wire [CHUNK_SIZE-1:0] chunk_a = a[(i+1)*CHUNK_SIZE-1 : i*CHUNK_SIZE];
    wire [CHUNK_SIZE-1:0] chunk_b = b[(i+1)*CHUNK_SIZE-1 : i*CHUNK_SIZE];
    
    // Instantiate the smaller multiplexer module.
    SmallMux small_mux(
        .a(chunk_a),  // Chunk of input 'a'
        .b(chunk_b),  // Chunk of input 'b'
        .sel(sel),    // Select line
        .out(chunk_out[i]) // Output of the chunk
    );
end

// Assign the outputs of the chunks to the final output.
genvar j;
for (j = 0; j < NUM_CHUNKS; j++) begin
    assign out[(j+1)*CHUNK_SIZE-1 : j*CHUNK_SIZE] = chunk_out[j];
end

endmodule

// Define the smaller multiplexer module.
module SmallMux(
    input [9:0] a,  // 10-bit input 'a'
    input [9:0] b,  // 10-bit input 'b'
    input sel,     // select line
    output [9:0] out // 10-bit output
);

// Use a for loop to assign each bit of the output based on the select line.
genvar k;
for (k = 0; k < 10; k++) begin
    assign out[k] = sel ? b[k] : a[k];
end

endmodule