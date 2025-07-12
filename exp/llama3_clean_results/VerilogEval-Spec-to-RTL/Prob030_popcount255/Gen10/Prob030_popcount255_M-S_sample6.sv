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

// Hierarchical population count
wire [7:0] count_level1 [15:0];
assign count_level1[0]  = segment_count[0]  + segment_count[1];
assign count_level1[1]  = segment_count[2]  + segment_count[3];
assign count_level1[2]  = segment_count[4]  + segment_count[5];
assign count_level1[3]  = segment_count[6]  + segment_count[7];
assign count_level1[4]  = segment_count[8]  + segment_count[9];
assign count_level1[5]  = segment_count[10] + segment_count[11];
assign count_level1[6]  = segment_count[12] + segment_count[13];
assign count_level1[7]  = segment_count[14] + segment_count[15];
assign count_level1[8]  = segment_count[16] + segment_count[17];
assign count_level1[9]  = segment_count[18] + segment_count[19];
assign count_level1[10] = segment_count[20] + segment_count[21];
assign count_level1[11] = segment_count[22] + segment_count[23];
assign count_level1[12] = segment_count[24] + segment_count[25];
assign count_level1[13] = segment_count[26] + segment_count[27];
assign count_level1[14] = segment_count[28] + segment_count[29];
assign count_level1[15] = segment_count[30] + segment_count[31];

wire [7:0] count_level2 [7:0];
assign count_level2[0] = count_level1[0] + count_level1[1];
assign count_level2[1] = count_level1[2] + count_level1[3];
assign count_level2[2] = count_level1[4] + count_level1[5];
assign count_level2[3] = count_level1[6] + count_level1[7];
assign count_level2[4] = count_level1[8] + count_level1[9];
assign count_level2[5] = count_level1[10] + count_level1[11];
assign count_level2[6] = count_level1[12] + count_level1[13];
assign count_level2[7] = count_level1[14] + count_level1[15];

wire [7:0] count_level3 [3:0];
assign count_level3[0] = count_level2[0] + count_level2[1];
assign count_level3[1] = count_level2[2] + count_level2[3];
assign count_level3[2] = count_level2[4] + count_level2[5];
assign count_level3[3] = count_level2[6] + count_level2[7];

wire [7:0] count_level4 [1:0];
assign count_level4[0] = count_level3[0] + count_level3[1];
assign count_level4[1] = count_level3[2] + count_level3[3];

wire [7:0] count;
assign count = count_level4[0] + count_level4[1];

// Assign the output
assign out = count;

endmodule