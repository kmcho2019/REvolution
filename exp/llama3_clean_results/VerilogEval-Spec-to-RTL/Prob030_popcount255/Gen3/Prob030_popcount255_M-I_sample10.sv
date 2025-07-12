module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 32 chunks of 8 bits
reg [7:0] chunk [31:0];

// Population count for each chunk using a pre-computed table
reg [3:0] chunk_count [31:0];

// Pre-computed table for population count of 8-bit numbers
reg [3:0] pop_count_table [255:0];

always @(*) begin
    // Initialize the pre-computed table
    for (int i = 0; i < 256; i++) begin
        pop_count_table[i] = 4'd0;
        for (int j = 0; j < 8; j++) begin
            if (i[j]) begin
                pop_count_table[i] = pop_count_table[i] + 1;
            end
        end
    end
    
    // Divide the input into chunks
    for (int i = 0; i < 32; i++) begin
        if (i < 31) begin
            chunk[i] = in[(i*8)+:8];
        end else begin
            chunk[i] = {1'b0, in[(i*8)+:7]};
        end
    end
    
    // Population count for each chunk using the pre-computed table
    for (int i = 0; i < 32; i++) begin
        chunk_count[i] = pop_count_table[chunk[i]];
    end
end

// Pipelined architecture for the final summation
reg [7:0] sum [2:0];

always @(*) begin
    sum[0] = 8'd0;
    for (int i = 0; i < 16; i++) begin
        sum[0] = sum[0] + chunk_count[i];
    end
    sum[1] = 8'd0;
    for (int i = 16; i < 32; i++) begin
        sum[1] = sum[1] + chunk_count[i];
    end
    sum[2] = sum[0] + sum[1];
end

assign out = sum[2];

endmodule