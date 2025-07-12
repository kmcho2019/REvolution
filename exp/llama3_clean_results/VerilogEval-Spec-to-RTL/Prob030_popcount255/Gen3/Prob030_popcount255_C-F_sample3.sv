module TopModule (
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Divide the input into 32 chunks of 8 bits
reg [7:0] chunk [31:0];

// Population count for each chunk using LUTs
reg [3:0] chunk_count [31:0];

always @(*) begin
    // Initialize counts
    for (int i = 0; i < 32; i++) begin
        chunk_count[i] = 4'd0;
    end
    
    // Divide the input into chunks
    for (int i = 0; i < 32; i++) begin
        if (i < 31) begin
            chunk[i] = in[(i*8)+:8];
        end else begin
            chunk[i] = {1'b0, in[(i*8)+:7]};
        end
    end
    
    // Population count for each chunk using LUTs
    for (int i = 0; i < 32; i++) begin
        reg [3:0] temp_count;
        temp_count = 4'd0;
        for (int j = 0; j < 8; j++) begin
            if (chunk[i][j]) begin
                temp_count = temp_count + 1;
            end
        end
        chunk_count[i] = temp_count;
    end
    
    // Hybrid approach to combine outputs from each chunk
    count = 8'd0;
    reg [4:0] intermediate_sum [15:0];
    for (int i = 0; i < 16; i++) begin
        intermediate_sum[i] = chunk_count[i*2] + chunk_count[i*2+1];
    end
    for (int i = 0; i < 8; i++) begin
        count = count + intermediate_sum[i*2] + intermediate_sum[i*2+1];
    end
end

assign out = count;

endmodule