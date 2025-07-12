module TopModule (
    input  [254:0] in,
    output [7:0] out
);

// Calculate population count for each 8-bit chunk
wire [7:0] count0;
wire [7:0] count1;
wire [7:0] count2;
wire [7:0] count3;
wire [7:0] count4;
wire [7:0] count5;
wire [7:0] count6;
wire [7:0] count7;
wire [7:0] count8;
wire [7:0] count9;
wire [7:0] count10;
wire [7:0] count11;
wire [7:0] count12;
wire [7:0] count13;
wire [7:0] count14;
wire [7:0] count15;
wire [7:0] count16;
wire [7:0] count17;
wire [7:0] count18;
wire [7:0] count19;
wire [7:0] count20;
wire [7:0] count21;
wire [7:0] count22;
wire [7:0] count23;
wire [7:0] count24;
wire [7:0] count25;
wire [7:0] count26;
wire [7:0] count27;
wire [7:0] count28;
wire [7:0] count29;
wire [7:0] count30;
wire [7:0] count31;

// Population count for each 8-bit chunk
PopCount8 pop_count0 (.in(in[7:0]), .out(count0));
PopCount8 pop_count1 (.in(in[15:8]), .out(count1));
PopCount8 pop_count2 (.in(in[23:16]), .out(count2));
PopCount8 pop_count3 (.in(in[31:24]), .out(count3));
PopCount8 pop_count4 (.in(in[39:32]), .out(count4));
PopCount8 pop_count5 (.in(in[47:40]), .out(count5));
PopCount8 pop_count6 (.in(in[55:48]), .out(count6));
PopCount8 pop_count7 (.in(in[63:56]), .out(count7));
PopCount8 pop_count8 (.in(in[71:64]), .out(count8));
PopCount8 pop_count9 (.in(in[79:72]), .out(count9));
PopCount8 pop_count10 (.in(in[87:80]), .out(count10));
PopCount8 pop_count11 (.in(in[95:88]), .out(count11));
PopCount8 pop_count12 (.in(in[103:96]), .out(count12));
PopCount8 pop_count13 (.in(in[111:104]), .out(count13));
PopCount8 pop_count14 (.in(in[119:112]), .out(count14));
PopCount8 pop_count15 (.in(in[127:120]), .out(count15));
PopCount8 pop_count16 (.in(in[135:128]), .out(count16));
PopCount8 pop_count17 (.in(in[143:136]), .out(count17));
PopCount8 pop_count18 (.in(in[151:144]), .out(count18));
PopCount8 pop_count19 (.in(in[159:152]), .out(count19));
PopCount8 pop_count20 (.in(in[167:160]), .out(count20));
PopCount8 pop_count21 (.in(in[175:168]), .out(count21));
PopCount8 pop_count22 (.in(in[183:176]), .out(count22));
PopCount8 pop_count23 (.in(in[191:184]), .out(count23));
PopCount8 pop_count24 (.in(in[199:192]), .out(count24));
PopCount8 pop_count25 (.in(in[207:200]), .out(count25));
PopCount8 pop_count26 (.in(in[215:208]), .out(count26));
PopCount8 pop_count27 (.in(in[223:216]), .out(count27));
PopCount8 pop_count28 (.in(in[231:224]), .out(count28));
PopCount8 pop_count29 (.in(in[239:232]), .out(count29));
PopCount8 pop_count30 (.in(in[247:240]), .out(count30));
PopCount8 pop_count31 (.in(in[254:248]), .out(count31));

// Sum up the population counts of the 8-bit chunks
wire [7:0] sum0;
wire [7:0] sum1;
wire [7:0] sum2;
wire [7:0] sum3;
wire [7:0] sum4;
wire [7:0] sum5;
wire [7:0] sum6;
wire [7:0] sum7;
wire [7:0] sum8;
wire [7:0] sum9;
wire [7:0] sum10;
wire [7:0] sum11;
wire [7:0] sum12;
wire [7:0] sum13;
wire [7:0] sum14;
wire [7:0] sum15;

assign sum0 = count0 + count1;
assign sum1 = count2 + count3;
assign sum2 = count4 + count5;
assign sum3 = count6 + count7;
assign sum4 = count8 + count9;
assign sum5 = count10 + count11;
assign sum6 = count12 + count13;
assign sum7 = count14 + count15;
assign sum8 = count16 + count17;
assign sum9 = count18 + count19;
assign sum10 = count20 + count21;
assign sum11 = count22 + count23;
assign sum12 = count24 + count25;
assign sum13 = count26 + count27;
assign sum14 = count28 + count29;
assign sum15 = count30 + count31;

wire [7:0] sum16;
wire [7:0] sum17;
wire [7:0] sum18;
wire [7:0] sum19;
wire [7:0] sum20;
wire [7:0] sum21;
wire [7:0] sum22;
wire [7:0] sum23;
wire [7:0] sum24;
wire [7:0] sum25;
wire [7:0] sum26;
wire [7:0] sum27;
wire [7:0] sum28;
wire [7:0] sum29;
wire [7:0] sum30;

assign sum16 = sum0 + sum1;
assign sum17 = sum2 + sum3;
assign sum18 = sum4 + sum5;
assign sum19 = sum6 + sum7;
assign sum20 = sum8 + sum9;
assign sum21 = sum10 + sum11;
assign sum22 = sum12 + sum13;
assign sum23 = sum14 + sum15;

assign sum24 = sum16 + sum17;
assign sum25 = sum18 + sum19;
assign sum26 = sum20 + sum21;
assign sum27 = sum22 + sum23;

assign sum28 = sum24 + sum25;
assign sum29 = sum26 + sum27;

assign sum30 = sum28 + sum29;

assign out = sum30;

endmodule

module PopCount8 (
    input  [7:0] in,
    output [7:0] out
);

    assign out = ({1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} +
                 {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]} + {1'b0, in[7]});

endmodule