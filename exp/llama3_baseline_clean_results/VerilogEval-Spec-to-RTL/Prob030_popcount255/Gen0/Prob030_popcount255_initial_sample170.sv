module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Since we're dealing with a large input, we can split it into smaller chunks
// and use a hierarchical counting approach.

// Define wires for each 8-bit chunk's count
wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7;
wire [7:0] count8, count9, count10, count11, count12, count13, count14, count15;
wire [7:0] count16, count17, count18, count19, count20, count21, count22, count23;
wire [7:0] count24, count25, count26, count27, count28, count29, count30, count31;

// Instantiate population count modules for each chunk
PopCount8 popcount0 (.in(in[7:0]), .out(count0));
PopCount8 popcount1 (.in(in[15:8]), .out(count1));
PopCount8 popcount2 (.in(in[23:16]), .out(count2));
PopCount8 popcount3 (.in(in[31:24]), .out(count3));
PopCount8 popcount4 (.in(in[39:32]), .out(count4));
PopCount8 popcount5 (.in(in[47:40]), .out(count5));
PopCount8 popcount6 (.in(in[55:48]), .out(count6));
PopCount8 popcount7 (.in(in[63:56]), .out(count7));

PopCount8 popcount8 (.in(in[71:64]), .out(count8));
PopCount8 popcount9 (.in(in[79:72]), .out(count9));
PopCount8 popcount10 (.in(in[87:80]), .out(count10));
PopCount8 popcount11 (.in(in[95:88]), .out(count11));
PopCount8 popcount12 (.in(in[103:96]), .out(count12));
PopCount8 popcount13 (.in(in[111:104]), .out(count13));
PopCount8 popcount14 (.in(in[119:112]), .out(count14));
PopCount8 popcount15 (.in(in[127:120]), .out(count15));

PopCount8 popcount16 (.in(in[135:128]), .out(count16));
PopCount8 popcount17 (.in(in[143:136]), .out(count17));
PopCount8 popcount18 (.in(in[151:144]), .out(count18));
PopCount8 popcount19 (.in(in[159:152]), .out(count19));
PopCount8 popcount20 (.in(in[167:160]), .out(count20));
PopCount8 popcount21 (.in(in[175:168]), .out(count21));
PopCount8 popcount22 (.in(in[183:176]), .out(count22));
PopCount8 popcount23 (.in(in[191:184]), .out(count23));

PopCount8 popcount24 (.in(in[199:192]), .out(count24));
PopCount8 popcount25 (.in(in[207:200]), .out(count25));
PopCount8 popcount26 (.in(in[215:208]), .out(count26));
PopCount8 popcount27 (.in(in[223:216]), .out(count27));
PopCount8 popcount28 (.in(in[231:224]), .out(count28));
PopCount8 popcount29 (.in(in[239:232]), .out(count29));
PopCount8 popcount30 (.in(in[247:240]), .out(count30));
PopCount8 popcount31 (.in({1'b0, in[254:248]}), .out(count31)); // Pad with 0 for last chunk

// Sum the counts using adders
wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14, sum15;

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

wire [7:0] sum16, sum17, sum18, sum19, sum20, sum21, sum22, sum23;

assign sum16 = sum0 + sum1;
assign sum17 = sum2 + sum3;
assign sum18 = sum4 + sum5;
assign sum19 = sum6 + sum7;
assign sum20 = sum8 + sum9;
assign sum21 = sum10 + sum11;
assign sum22 = sum12 + sum13;
assign sum23 = sum14 + sum15;

wire [7:0] sum24, sum25, sum26, sum27;

assign sum24 = sum16 + sum17;
assign sum25 = sum18 + sum19;
assign sum26 = sum20 + sum21;
assign sum27 = sum22 + sum23;

wire [7:0] sum28, sum29;

assign sum28 = sum24 + sum25;
assign sum29 = sum26 + sum27;

wire [15:0] sum30;

assign sum30 = sum28 + {8'b0, sum29};

// Final sum might exceed 8 bits due to carry, so we need to handle that
assign out = sum30[7:0];

endmodule

module PopCount8(
    input [7:0] in,
    output [7:0] out
);

// Simple population count for 8-bit vector
always @(in) begin
    out = 8'b0;
    for (int i = 0; i < 8; i++) begin
        if (in[i])
            out = out + 8'b1;
    end
end

endmodule