module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits (except the last which is 7 bits)
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

// Hierarchical population count with reduced levels for optimization
wire [7:0] count_level1 [15:0];
for (genvar i = 0; i < 16; i++) begin
    assign count_level1[i] = segment_count[i*2] + segment_count[i*2+1];
end

wire [7:0] count_level2 [7:0];
for (genvar i = 0; i < 8; i++) begin
    assign count_level2[i] = count_level1[i*2] + count_level1[i*2+1];
end

wire [7:0] count_level3 [3:0];
for (genvar i = 0; i < 4; i++) begin
    assign count_level3[i] = count_level2[i*2] + count_level2[i*2+1];
end

wire [7:0] count_level4 [1:0];
for (genvar i = 0; i < 2; i++) begin
    assign count_level4[i] = count_level3[i*2] + count_level3[i*2+1];
end

wire [7:0] count;
assign count = count_level4[0] + count_level4[1];

// Assign the output
assign out = count;

endmodule