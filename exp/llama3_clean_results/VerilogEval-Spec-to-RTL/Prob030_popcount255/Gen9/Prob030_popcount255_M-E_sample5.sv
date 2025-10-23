module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input vector into 16 chunks of 16 bits
wire [15:0] chunk0 = in[15:0];
wire [15:0] chunk1 = in[31:16];
wire [15:0] chunk2 = in[47:32];
wire [15:0] chunk3 = in[63:48];
wire [15:0] chunk4 = in[79:64];
wire [15:0] chunk5 = in[95:80];
wire [15:0] chunk6 = in[111:96];
wire [15:0] chunk7 = in[127:112];
wire [15:0] chunk8 = in[143:128];
wire [15:0] chunk9 = in[159:144];
wire [15:0] chunk10 = in[175:160];
wire [15:0] chunk11 = in[191:176];
wire [15:0] chunk12 = in[207:192];
wire [15:0] chunk13 = in[223:208];
wire [15:0] chunk14 = in[239:224];
wire [15:0] chunk15 = {8'b0, in[254:247]};

// Count the number of '1's in each chunk
wire [4:0] count0 = $countones(chunk0);
wire [4:0] count1 = $countones(chunk1);
wire [4:0] count2 = $countones(chunk2);
wire [4:0] count3 = $countones(chunk3);
wire [4:0] count4 = $countones(chunk4);
wire [4:0] count5 = $countones(chunk5);
wire [4:0] count6 = $countones(chunk6);
wire [4:0] count7 = $countones(chunk7);
wire [4:0] count8 = $countones(chunk8);
wire [4:0] count9 = $countones(chunk9);
wire [4:0] count10 = $countones(chunk10);
wire [4:0] count11 = $countones(chunk11);
wire [4:0] count12 = $countones(chunk12);
wire [4:0] count13 = $countones(chunk13);
wire [4:0] count14 = $countones(chunk14);
wire [4:0] count15 = $countones(chunk15);

// Adder tree to sum up the counts
wire [5:0] sum0 = count0 + count1;
wire [5:0] sum1 = count2 + count3;
wire [5:0] sum2 = count4 + count5;
wire [5:0] sum3 = count6 + count7;
wire [5:0] sum4 = count8 + count9;
wire [5:0] sum5 = count10 + count11;
wire [5:0] sum6 = count12 + count13;
wire [5:0] sum7 = count14 + count15;

wire [6:0] sum8 = sum0 + sum1;
wire [6:0] sum9 = sum2 + sum3;
wire [6:0] sum10 = sum4 + sum5;
wire [6:0] sum11 = sum6 + sum7;

wire [7:0] sum12 = sum8 + sum9;
wire [7:0] sum13 = sum10 + sum11;

// Final sum
assign out = sum12 + sum13;

endmodule