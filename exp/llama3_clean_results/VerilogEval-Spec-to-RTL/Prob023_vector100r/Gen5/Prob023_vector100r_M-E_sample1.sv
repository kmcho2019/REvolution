module TopModule(
    input  [99:0] in,
    output [99:0] out
);

// Divide the input into two 50-bit chunks
wire [49:0] chunk1 = in[99:50]; // MSB 50 bits
wire [49:0] chunk2 = in[49:0];  // LSB 50 bits

// Reverse each chunk
wire [49:0] rev_chunk1;
wire [49:0] rev_chunk2;

genvar i;
generate
    for (i = 0; i < 50; i++) begin
        assign rev_chunk1[i] = chunk1[49 - i]; // Reverse chunk1
        assign rev_chunk2[i] = chunk2[49 - i]; // Reverse chunk2
    end
endgenerate

// Concatenate the reversed chunks to form the output
assign out = {rev_chunk2, rev_chunk1};

endmodule