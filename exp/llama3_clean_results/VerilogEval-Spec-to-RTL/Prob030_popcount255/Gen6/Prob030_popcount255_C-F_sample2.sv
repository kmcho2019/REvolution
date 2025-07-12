module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Assign the segments
assign segment[0] = in[7:0];
assign segment[1] = in[15:8];
assign segment[2] = in[23:16];
assign segment[3] = in[31:24];
assign segment[4] = in[39:32];
assign segment[5] = in[47:40];
assign segment[6] = in[55:48];
assign segment[7] = in[63:56];
assign segment[8] = in[71:64];
assign segment[9] = in[79:72];
assign segment[10] = in[87:80];
assign segment[11] = in[95:88];
assign segment[12] = in[103:96];
assign segment[13] = in[111:104];
assign segment[14] = in[119:112];
assign segment[15] = in[127:120];
assign segment[16] = in[135:128];
assign segment[17] = in[143:136];
assign segment[18] = in[151:144];
assign segment[19] = in[159:152];
assign segment[20] = in[167:160];
assign segment[21] = in[175:168];
assign segment[22] = in[183:176];
assign segment[23] = in[191:184];
assign segment[24] = in[199:192];
assign segment[25] = in[207:200];
assign segment[26] = in[215:208];
assign segment[27] = in[223:216];
assign segment[28] = in[231:224];
assign segment[29] = in[239:232];
assign segment[30] = in[247:240];
assign segment[31] = {1'b0, in[254:248]};

// Population counts for each segment
wire [7:0] segment_count [31:0];

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
assign segment_count[16] = $countones(segment[16]);
assign segment_count[17] = $countones(segment[17]);
assign segment_count[18] = $countones(segment[18]);
assign segment_count[19] = $countones(segment[19]);
assign segment_count[20] = $countones(segment[20]);
assign segment_count[21] = $countones(segment[21]);
assign segment_count[22] = $countones(segment[22]);
assign segment_count[23] = $countones(segment[23]);
assign segment_count[24] = $countones(segment[24]);
assign segment_count[25] = $countones(segment[25]);
assign segment_count[26] = $countones(segment[26]);
assign segment_count[27] = $countones(segment[27]);
assign segment_count[28] = $countones(segment[28]);
assign segment_count[29] = $countones(segment[29]);
assign segment_count[30] = $countones(segment[30]);
assign segment_count[31] = $countones(segment[31]);

// Final population count
wire [7:0] count;

// Assign the final population count using a tree-like structure of adders
assign count = segment_count[0] + segment_count[1] + segment_count[2] + segment_count[3] + segment_count[4] + segment_count[5] + segment_count[6] + segment_count[7] + 
               segment_count[8] + segment_count[9] + segment_count[10] + segment_count[11] + segment_count[12] + segment_count[13] + segment_count[14] + segment_count[15] + 
               segment_count[16] + segment_count[17] + segment_count[18] + segment_count[19] + segment_count[20] + segment_count[21] + segment_count[22] + segment_count[23] + 
               segment_count[24] + segment_count[25] + segment_count[26] + segment_count[27] + segment_count[28] + segment_count[29] + segment_count[30] + segment_count[31];

// Assign the output
assign out = count;

endmodule