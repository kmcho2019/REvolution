module TopModule(
    input [254:0] in,
    output [7:0] out
);

wire [15:0] chunk0, chunk1, chunk2, chunk3, chunk4, chunk5, chunk6, chunk7, 
           chunk8, chunk9, chunk10, chunk11, chunk12, chunk13, chunk14, chunk15;

assign chunk0  = in[15:0];
assign chunk1  = in[31:16];
assign chunk2  = in[47:32];
assign chunk3  = in[63:48];
assign chunk4  = in[79:64];
assign chunk5  = in[95:80];
assign chunk6  = in[111:96];
assign chunk7  = in[127:112];
assign chunk8  = in[143:128];
assign chunk9  = in[159:144];
assign chunk10 = in[175:160];
assign chunk11 = in[191:176];
assign chunk12 = in[207:192];
assign chunk13 = in[223:208];
assign chunk14 = in[239:224];
assign chunk15 = in[254:240];

wire [4:0] count0, count1, count2, count3, count4, count5, count6, count7, 
           count8, count9, count10, count11, count12, count13, count14, count15;

// Count the number of '1's in each chunk
ones_counter_16bit counter0(chunk0, count0);
ones_counter_16bit counter1(chunk1, count1);
ones_counter_16bit counter2(chunk2, count2);
ones_counter_16bit counter3(chunk3, count3);
ones_counter_16bit counter4(chunk4, count4);
ones_counter_16bit counter5(chunk5, count5);
ones_counter_16bit counter6(chunk6, count6);
ones_counter_16bit counter7(chunk7, count7);
ones_counter_16bit counter8(chunk8, count8);
ones_counter_16bit counter9(chunk9, count9);
ones_counter_16bit counter10(chunk10, count10);
ones_counter_16bit counter11(chunk11, count11);
ones_counter_16bit counter12(chunk12, count12);
ones_counter_16bit counter13(chunk13, count13);
ones_counter_16bit counter14(chunk14, count14);
ones_counter_7bit  counter15(chunk15, count15);

// Combine the results from each chunk
wire [8:0] sum;
assign sum = count0 + count1 + count2 + count3 + count4 + count5 + count6 + 
             count7 + count8 + count9 + count10 + count11 + count12 + count13 + 
             count14 + count15;

assign out = sum[7:0];

endmodule

module ones_counter_16bit(
    input [15:0] in,
    output [4:0] out
);

wire [3:0] count0, count1, count2, count3;

// Count the number of '1's in each 4-bit chunk
ones_counter_4bit counter0(in[3:0], count0);
ones_counter_4bit counter1(in[7:4], count1);
ones_counter_4bit counter2(in[11:8], count2);
ones_counter_4bit counter3(in[15:12], count3);

// Combine the results from each 4-bit chunk
assign out = count0 + count1 + count2 + count3;

endmodule

module ones_counter_7bit(
    input [6:0] in,
    output [4:0] out
);

wire [2:0] count0, count1, count2;

// Count the number of '1's in each 2-bit chunk (with the last chunk having 3 bits)
ones_counter_2bit counter0(in[1:0], count0[1:0]);
assign count0[2] = 1'b0; // dummy bit
ones_counter_2bit counter1(in[3:2], count1[1:0]);
assign count1[2] = 1'b0; // dummy bit
ones_counter_3bit counter2(in[6:4], count2);

// Combine the results from each chunk
assign out = {1'b0, count0[1:0]} + {1'b0, count1[1:0]} + count2;

endmodule

module ones_counter_4bit(
    input [3:0] in,
    output [1:0] out
);

wire [0:0] count0, count1;

// Count the number of '1's in each 2-bit chunk
ones_counter_2bit counter0(in[1:0], count0);
ones_counter_2bit counter1(in[3:2], count1);

// Combine the results from each 2-bit chunk
assign out = count0 + count1;

endmodule

module ones_counter_3bit(
    input [2:0] in,
    output [1:0] out
);

wire [0:0] count0, count1;

// Count the number of '1's in each bit
assign count0 = in[0];
assign count1 = in[1] + in[2];

// Combine the results from each bit
assign out = count0 + count1;

endmodule

module ones_counter_2bit(
    input [1:0] in,
    output [0:0] out
);

// Count the number of '1's in each bit
assign out = in[0] + in[1];

endmodule