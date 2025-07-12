module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 17 segments of 15 bits
wire [14:0] segment [16:0];

// Assign the segments
assign segment[0] = in[14:0];
assign segment[1] = in[29:15];
assign segment[2] = in[44:30];
assign segment[3] = in[59:45];
assign segment[4] = in[74:60];
assign segment[5] = in[89:75];
assign segment[6] = in[104:90];
assign segment[7] = in[119:105];
assign segment[8] = in[134:120];
assign segment[9] = in[149:135];
assign segment[10] = in[164:150];
assign segment[11] = in[179:165];
assign segment[12] = in[194:180];
assign segment[13] = in[209:195];
assign segment[14] = in[224:210];
assign segment[15] = in[239:225];
assign segment[16] = {1'b0, in[254:240]};

// Population counts for each segment
wire [7:0] segment_count [16:0];

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

// Final population count
wire [7:0] count;

// Assign the final population count using a tree-like structure of adders
wire [7:0] sum1, sum2, sum3, sum4;
assign sum1 = segment_count[0] + segment_count[1] + segment_count[2] + segment_count[3];
assign sum2 = segment_count[4] + segment_count[5] + segment_count[6] + segment_count[7];
assign sum3 = segment_count[8] + segment_count[9] + segment_count[10] + segment_count[11];
assign sum4 = segment_count[12] + segment_count[13] + segment_count[14] + segment_count[15];
assign count = sum1 + sum2 + sum3 + sum4 + segment_count[16];

// Assign the output
assign out = count;

endmodule