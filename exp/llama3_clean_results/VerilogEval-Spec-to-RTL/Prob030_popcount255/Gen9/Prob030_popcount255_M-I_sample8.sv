module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 16 segments of 16 bits (except the last segment which is 7 bits)
wire [15:0] segment [15:0];

// Assign the segments
assign segment[0] = in[15:0];
assign segment[1] = in[31:16];
assign segment[2] = in[47:32];
assign segment[3] = in[63:48];
assign segment[4] = in[79:64];
assign segment[5] = in[95:80];
assign segment[6] = in[111:96];
assign segment[7] = in[127:112];
assign segment[8] = in[143:128];
assign segment[9] = in[159:144];
assign segment[10] = in[175:160];
assign segment[11] = in[191:176];
assign segment[12] = in[207:192];
assign segment[13] = in[223:208];
assign segment[14] = in[239:224];
assign segment[15] = {9'b0, in[254:246]};

// Population counts for each segment
wire [4:0] segment_count [15:0];

// Assign the population counts
assign segment_count[0] = $countones(segment[0]);
assign segment_count[1] = $countones(segment[1]);
assign segment_count[2] = $countones(segment[2]);
assign segment_count[3] = $countones(segment[3]);
assign segment_count[4] = $countones(segment[4]);
assign segment_count[5] = $countones(segment[5]);
assign segment_count[6] = $countones(segment[6]);
assign segment_count[7] = $countones(segment[7]);
assign segment_count[8] = $countones(segment[8]);
assign segment_count[9] = $countones(segment[9]);
assign segment_count[10] = $countones(segment[10]);
assign segment_count[11] = $countones(segment[11]);
assign segment_count[12] = $countones(segment[12]);
assign segment_count[13] = $countones(segment[13]);
assign segment_count[14] = $countones(segment[14]);
assign segment_count[15] = $countones(segment[15]);

// First level of Wallace tree adder
wire [5:0] level1_count [7:0];
assign level1_count[0] = segment_count[0] + segment_count[1];
assign level1_count[1] = segment_count[2] + segment_count[3];
assign level1_count[2] = segment_count[4] + segment_count[5];
assign level1_count[3] = segment_count[6] + segment_count[7];
assign level1_count[4] = segment_count[8] + segment_count[9];
assign level1_count[5] = segment_count[10] + segment_count[11];
assign level1_count[6] = segment_count[12] + segment_count[13];
assign level1_count[7] = segment_count[14] + segment_count[15];

// Second level of Wallace tree adder
wire [6:0] level2_count [3:0];
assign level2_count[0] = level1_count[0] + level1_count[1];
assign level2_count[1] = level1_count[2] + level1_count[3];
assign level2_count[2] = level1_count[4] + level1_count[5];
assign level2_count[3] = level1_count[6] + level1_count[7];

// Final level of Wallace tree adder
wire [7:0] final_count;
assign final_count = level2_count[0] + level2_count[1] + level2_count[2] + level2_count[3];

// Assign the output
assign out = final_count;

endmodule