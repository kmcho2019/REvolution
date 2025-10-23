module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 16 chunks of 16 bits
wire [15:0] chunk [15:0];

// Use $countones function for each chunk
wire [4:0] chunk_count [15:0];

genvar i;
generate
    for (i = 0; i < 16; i++) begin
        assign chunk[i] = in[(i*16)+:16];
        assign chunk_count[i] = $countones(chunk[i]);
    end
endgenerate

// Tree-like structure to sum up the counts from each chunk
wire [7:0] count;
assign count = chunk_count[0] + chunk_count[1] + chunk_count[2] + chunk_count[3] +
               chunk_count[4] + chunk_count[5] + chunk_count[6] + chunk_count[7] +
               chunk_count[8] + chunk_count[9] + chunk_count[10] + chunk_count[11] +
               chunk_count[12] + chunk_count[13] + chunk_count[14] + chunk_count[15];

assign out = count;

endmodule