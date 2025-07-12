module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 16 chunks of 16 bits
wire [15:0] chunk [15:0];

// Population count for each chunk
wire [4:0] chunk_count [15:0];

// Use $countones function for each chunk
assign chunk[0]  = in[15:0];
assign chunk[1]  = in[31:16];
assign chunk[2]  = in[47:32];
assign chunk[3]  = in[63:48];
assign chunk[4]  = in[79:64];
assign chunk[5]  = in[95:80];
assign chunk[6]  = in[111:96];
assign chunk[7]  = in[127:112];
assign chunk[8]  = in[143:128];
assign chunk[9]  = in[159:144];
assign chunk[10] = in[175:160];
assign chunk[11] = in[191:176];
assign chunk[12] = in[207:192];
assign chunk[13] = in[223:208];
assign chunk[14] = in[239:224];
assign chunk[15] = in[254:240];

assign chunk_count[0]  = $countones(chunk[0]);
assign chunk_count[1]  = $countones(chunk[1]);
assign chunk_count[2]  = $countones(chunk[2]);
assign chunk_count[3]  = $countones(chunk[3]);
assign chunk_count[4]  = $countones(chunk[4]);
assign chunk_count[5]  = $countones(chunk[5]);
assign chunk_count[6]  = $countones(chunk[6]);
assign chunk_count[7]  = $countones(chunk[7]);
assign chunk_count[8]  = $countones(chunk[8]);
assign chunk_count[9]  = $countones(chunk[9]);
assign chunk_count[10] = $countones(chunk[10]);
assign chunk_count[11] = $countones(chunk[11]);
assign chunk_count[12] = $countones(chunk[12]);
assign chunk_count[13] = $countones(chunk[13]);
assign chunk_count[14] = $countones(chunk[14]);
assign chunk_count[15] = $countones(chunk[15]);

// Tree-like structure to sum up the counts from each chunk
wire [4:0] sum0  = chunk_count[0] + chunk_count[1];
wire [4:0] sum1  = chunk_count[2] + chunk_count[3];
wire [4:0] sum2  = chunk_count[4] + chunk_count[5];
wire [4:0] sum3  = chunk_count[6] + chunk_count[7];
wire [4:0] sum4  = chunk_count[8] + chunk_count[9];
wire [4:0] sum5  = chunk_count[10] + chunk_count[11];
wire [4:0] sum6  = chunk_count[12] + chunk_count[13];
wire [4:0] sum7  = chunk_count[14] + chunk_count[15];

wire [5:0] sum8  = sum0 + sum1;
wire [5:0] sum9  = sum2 + sum3;
wire [5:0] sum10 = sum4 + sum5;
wire [5:0] sum11 = sum6 + sum7;

wire [6:0] sum12 = sum8 + sum9;
wire [6:0] sum13 = sum10 + sum11;

wire [7:0] count = sum12 + sum13;

assign out = count;

endmodule