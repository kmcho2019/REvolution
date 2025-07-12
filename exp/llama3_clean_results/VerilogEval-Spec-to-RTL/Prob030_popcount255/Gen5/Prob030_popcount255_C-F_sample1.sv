module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 16 chunks of 16 bits
reg [15:0] chunk [15:0];

// Population count for each chunk
reg [4:0] chunk_count [15:0];

// Use $countones function for each chunk
always @(*) begin
    for (int i = 0; i < 16; i++) begin
        chunk[i] = in[(i*16)+:16];
        chunk_count[i] = $countones(chunk[i]);
    end
end

// Tree-like structure to sum up the counts from each chunk
reg [7:0] count;
always @(*) begin
    count = 8'd0;
    for (int i = 0; i < 16; i++) begin
        count = count + chunk_count[i];
    end
end

assign out = count;

endmodule