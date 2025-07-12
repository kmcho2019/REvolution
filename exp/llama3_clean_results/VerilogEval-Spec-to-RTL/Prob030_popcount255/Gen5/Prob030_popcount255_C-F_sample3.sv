module TopModule (
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Divide the input into 16 chunks of 16 bits
reg [15:0] chunk [15:0];

// Population count for each chunk using compressor tree
reg [4:0] chunk_count [15:0];

always @(*) begin
    // Initialize counts
    for (int i = 0; i < 16; i++) begin
        chunk_count[i] = 5'd0;
    end
    
    // Divide the input into chunks
    for (int i = 0; i < 16; i++) begin
        chunk[i] = in[(i*16)+:16];
    end
    
    // Population count for each chunk using compressor tree
    for (int i = 0; i < 16; i++) begin
        reg [4:0] temp_count;
        temp_count = 5'd0;
        for (int j = 0; j < 16; j++) begin
            if (chunk[i][j]) begin
                temp_count = temp_count + 1;
            end
        end
        chunk_count[i] = temp_count;
    end
    
    // Tree adder to combine outputs from each chunk
    count = 8'd0;
    for (int i = 0; i < 16; i++) begin
        count = count + chunk_count[i];
    end
end

assign out = count;

endmodule