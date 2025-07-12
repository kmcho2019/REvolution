module TopModule (
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Divide the input into 32 chunks of 8 bits (one chunk has 7 bits)
reg [7:0] chunk [31:0];

// Population count for each chunk using $countones
reg [7:0] chunk_count [31:0];

// Stage 1: Divide the input into chunks and count '1's in each chunk
always @(*) begin
    // Initialize counts
    for (int i = 0; i < 32; i++) begin
        chunk_count[i] = 8'd0;
    end
    
    // Divide the input into chunks
    for (int i = 0; i < 32; i++) begin
        if (i < 31) begin
            chunk[i] = in[(i*8)+:8];
        end else begin
            chunk[i] = {1'b0, in[(i*8)+:7]};
        end
    end
    
    // Population count for each chunk using $countones
    for (int i = 0; i < 32; i++) begin
        chunk_count[i] = $countones(chunk[i]);
    end
end

// Stage 2: Compressor tree to combine outputs from each chunk
always @(posedge clk) begin
    reg [7:0] temp_count;
    temp_count = 8'd0;
    for (int i = 0; i < 32; i++) begin
        temp_count = temp_count + chunk_count[i];
    end
    count = temp_count;
end

assign out = count;

endmodule