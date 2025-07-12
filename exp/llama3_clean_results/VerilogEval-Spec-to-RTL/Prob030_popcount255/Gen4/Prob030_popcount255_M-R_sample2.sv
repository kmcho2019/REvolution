module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Divide the input into 15 segments of 17 bits
wire [16:0] segment [14:0];
assign segment[0]  = {1'b0, in[16:0]};
assign segment[1]  = {1'b0, in[33:17]};
assign segment[2]  = {1'b0, in[50:34]};
assign segment[3]  = {1'b0, in[67:51]};
assign segment[4]  = {1'b0, in[84:68]};
assign segment[5]  = {1'b0, in[101:85]};
assign segment[6]  = {1'b0, in[118:102]};
assign segment[7]  = {1'b0, in[135:119]};
assign segment[8]  = {1'b0, in[152:136]};
assign segment[9]  = {1'b0, in[169:153]};
assign segment[10] = {1'b0, in[186:170]};
assign segment[11] = {1'b0, in[203:187]};
assign segment[12] = {1'b0, in[220:204]};
assign segment[13] = {1'b0, in[237:221]};
assign segment[14] = {1'b0, in[254:238]};

// Population count for each segment
wire [5:0] segment_count [14:0];
assign segment_count[0]  = {6{1'b0}} + segment[0];
assign segment_count[1]  = {6{1'b0}} + segment[1];
assign segment_count[2]  = {6{1'b0}} + segment[2];
assign segment_count[3]  = {6{1'b0}} + segment[3];
assign segment_count[4]  = {6{1'b0}} + segment[4];
assign segment_count[5]  = {6{1'b0}} + segment[5];
assign segment_count[6]  = {6{1'b0}} + segment[6];
assign segment_count[7]  = {6{1'b0}} + segment[7];
assign segment_count[8]  = {6{1'b0}} + segment[8];
assign segment_count[9]  = {6{1'b0}} + segment[9];
assign segment_count[10] = {6{1'b0}} + segment[10];
assign segment_count[11] = {6{1'b0}} + segment[11];
assign segment_count[12] = {6{1'b0}} + segment[12];
assign segment_count[13] = {6{1'b0}} + segment[13];
assign segment_count[14] = {6{1'b0}} + segment[14];

// Sum up the counts from each segment using a tree-like adder structure
wire [7:0] count;
assign count = (segment_count[0] + segment_count[1] + segment_count[2] + segment_count[3] + segment_count[4] + 
               segment_count[5] + segment_count[6] + segment_count[7] + segment_count[8] + segment_count[9] + 
               segment_count[10] + segment_count[11] + segment_count[12] + segment_count[13] + segment_count[14]) & 8'hFF;

assign out = count;

endmodule