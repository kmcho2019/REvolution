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

// Final population count
wire [7:0] count;

// Assign the final population count using a tree-like structure of adders
wire [7:0] count_temp [4:0];
assign count_temp[0] = segment_count[0] + segment_count[1] + segment_count[2] + segment_count[3] + segment_count[4] + segment_count[5] + segment_count[6] + segment_count[7];
assign count_temp[1] = segment_count[8] + segment_count[9] + segment_count[10] + segment_count[11] + segment_count[12] + segment_count[13] + segment_count[14] + segment_count[15];
assign count_temp[2] = segment_count[16] + segment_count[17] + segment_count[18] + segment_count[19] + segment_count[20] + segment_count[21] + segment_count[22] + segment_count[23];
assign count_temp[3] = segment_count[24] + segment_count[25] + segment_count[26] + segment_count[27] + segment_count[28] + segment_count[29] + segment_count[30] + segment_count[31];
assign count_temp[4] = count_temp[0] + count_temp[1] + count_temp[2] + count_temp[3];
assign count = count_temp[4];

// Assign the output
assign out = count;

endmodule