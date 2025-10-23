module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 16 chunks of 16 bits
wire [15:0] chunk [15:0];

// Population count for each chunk
wire [4:0] chunk_count [15:0];

// Generate the chunks
genvar i;
generate
    for (i = 0; i < 16; i++) begin
        assign chunk[i] = in[(i*16)+:16];
    end
endgenerate

// Population count for each chunk
reg [4:0] count_temp [15:0];

always @(*) begin
    for (int i = 0; i < 16; i++) begin
        count_temp[i] = 5'd0;
        for (int j = 0; j < 16; j++) begin
            if (chunk[i][j]) begin
                count_temp[i] = count_temp[i] + 1;
            end
        end
    end
end

assign chunk_count = count_temp;

// Hierarchical adder to sum up the counts from each chunk
reg [7:0] count;

always @(*) begin
    count = 8'd0;
    for (int i = 0; i < 16; i++) begin
        count = count + chunk_count[i];
    end
end

assign out = count;

endmodule