module TopModule (
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;
reg [4:0] chunk_count [15:0];

// Divide the input into 16 chunks of 16 bits
reg [15:0] chunk [15:0];

// Population count for each chunk
always @(*) begin
    for (int i = 0; i < 16; i++) begin
        chunk[i] = in[(i*16)+:16];
    end
end

// Use a more efficient population count logic within each chunk
always @(*) begin
    for (int i = 0; i < 16; i++) begin
        chunk_count[i] = 5'd0;
        for (int j = 0; j < 16; j++) begin
            if (chunk[i][j]) begin
                chunk_count[i] = chunk_count[i] + 1;
            end
        end
    end
end

// Use a tree adder to sum up the counts from each chunk
reg [7:0] adder_tree [3:0];
always @(*) begin
    adder_tree[0] = chunk_count[0] + chunk_count[1];
    adder_tree[1] = chunk_count[2] + chunk_count[3];
    adder_tree[2] = chunk_count[4] + chunk_count[5];
    adder_tree[3] = chunk_count[6] + chunk_count[7];
end

reg [7:0] adder_tree2 [1:0];
always @(*) begin
    adder_tree2[0] = adder_tree[0] + adder_tree[1];
    adder_tree2[1] = adder_tree[2] + adder_tree[3];
end

reg [7:0] adder_tree3;
always @(*) begin
    adder_tree3 = adder_tree2[0] + adder_tree2[1];
end

// Continue the tree adder for the remaining chunks
reg [7:0] adder_tree4 [3:0];
always @(*) begin
    adder_tree4[0] = chunk_count[8] + chunk_count[9];
    adder_tree4[1] = chunk_count[10] + chunk_count[11];
    adder_tree4[2] = chunk_count[12] + chunk_count[13];
    adder_tree4[3] = chunk_count[14] + 5'd0; // Pad with zeros for the last chunk
end

reg [7:0] adder_tree5 [1:0];
always @(*) begin
    adder_tree5[0] = adder_tree4[0] + adder_tree4[1];
    adder_tree5[1] = adder_tree4[2] + adder_tree4[3];
end

reg [7:0] adder_tree6;
always @(*) begin
    adder_tree6 = adder_tree5[0] + adder_tree5[1];
end

// Final adder stage
always @(*) begin
    count = adder_tree3 + adder_tree6;
end

assign out = count;

endmodule