module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Assign the segments
genvar i;
for (i = 0; i < 32; i++) begin
    if (i == 31) begin
        assign segment[i] = {1'b0, in[254:248]};
    end else begin
        assign segment[i] = in[(i*8)+7:i*8];
    end
end

// Population counts for each segment
wire [7:0] segment_count [31:0];

// Assign the population counts
for (genvar i = 0; i < 32; i++) begin
    assign segment_count[i] = $countones(segment[i]);
end

// Divide the segments into 8 groups of 4 segments each
wire [7:0] group_count [7:0];

// Assign the group counts
for (genvar i = 0; i < 8; i++) begin
    assign group_count[i] = segment_count[i*4] + segment_count[i*4+1] + segment_count[i*4+2] + segment_count[i*4+3];
end

// Final population count
wire [7:0] count;

// Assign the final population count using a tree-like structure of adders
wire [7:0] count_temp [2:0];
assign count_temp[0] = group_count[0] + group_count[1] + group_count[2] + group_count[3];
assign count_temp[1] = group_count[4] + group_count[5] + group_count[6] + group_count[7];
assign count_temp[2] = count_temp[0] + count_temp[1];
assign count = count_temp[2];

// Assign the output
assign out = count;

endmodule