module TopModule(in, out);
    input [255:0] in;
    output [7:0] out;

    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7, 
             count8, count9, count10, count11, count12, count13, count14, count15,
             count16, count17, count18, count19, count20, count21, count22, count23,
             count24, count25, count26, count27, count28, count29, count30, count31;

    assign count0 = in[7:0];
    assign count1 = in[15:8];
    assign count2 = in[23:16];
    assign count3 = in[31:24];
    assign count4 = in[39:32];
    assign count5 = in[47:40];
    assign count6 = in[55:48];
    assign count7 = in[63:56];
    assign count8 = in[71:64];
    assign count9 = in[79:72];
    assign count10 = in[87:80];
    assign count11 = in[95:88];
    assign count12 = in[103:96];
    assign count13 = in[111:104];
    assign count14 = in[119:112];
    assign count15 = in[127:120];
    assign count16 = in[135:128];
    assign count17 = in[143:136];
    assign count18 = in[151:144];
    assign count19 = in[159:152];
    assign count20 = in[167:160];
    assign count21 = in[175:168];
    assign count22 = in[183:176];
    assign count23 = in[191:184];
    assign count24 = in[199:192];
    assign count25 = in[207:200];
    assign count26 = in[215:208];
    assign count27 = in[223:216];
    assign count28 = in[231:224];
    assign count29 = in[239:232];
    assign count30 = in[247:240];
    assign count31 = in[255:248];

    wire [7:0] popcount0, popcount1, popcount2, popcount3, popcount4, popcount5, 
             popcount6, popcount7, popcount8, popcount9, popcount10, popcount11, 
             popcount12, popcount13, popcount14, popcount15;

    PopCount popcount_inst0(.in(count0), .out(popcount0));
    PopCount popcount_inst1(.in(count1), .out(popcount1));
    PopCount popcount_inst2(.in(count2), .out(popcount2));
    PopCount popcount_inst3(.in(count3), .out(popcount3));
    PopCount popcount_inst4(.in(count4), .out(popcount4));
    PopCount popcount_inst5(.in(count5), .out(popcount5));
    PopCount popcount_inst6(.in(count6), .out(popcount6));
    PopCount popcount_inst7(.in(count7), .out(popcount7));
    PopCount popcount_inst8(.in(count8), .out(popcount8));
    PopCount popcount_inst9(.in(count9), .out(popcount9));
    PopCount popcount_inst10(.in(count10), .out(popcount10));
    PopCount popcount_inst11(.in(count11), .out(popcount11));
    PopCount popcount_inst12(.in(count12), .out(popcount12));
    PopCount popcount_inst13(.in(count13), .out(popcount13));
    PopCount popcount_inst14(.in(count14), .out(popcount14));
    PopCount popcount_inst15(.in(count15), .out(popcount15));

    PopCount popcount_inst16(.in(count16), .out(popcount0));
    PopCount popcount_inst17(.in(count17), .out(popcount1));
    PopCount popcount_inst18(.in(count18), .out(popcount2));
    PopCount popcount_inst19(.in(count19), .out(popcount3));
    PopCount popcount_inst20(.in(count20), .out(popcount4));
    PopCount popcount_inst21(.in(count21), .out(popcount5));
    PopCount popcount_inst22(.in(count22), .out(popcount6));
    PopCount popcount_inst23(.in(count23), .out(popcount7));
    PopCount popcount_inst24(.in(count24), .out(popcount8));
    PopCount popcount_inst25(.in(count25), .out(popcount9));
    PopCount popcount_inst26(.in(count26), .out(popcount10));
    PopCount popcount_inst27(.in(count27), .out(popcount11));
    PopCount popcount_inst28(.in(count28), .out(popcount12));
    PopCount popcount_inst29(.in(count29), .out(popcount13));
    PopCount popcount_inst30(.in(count30), .out(popcount14));
    PopCount popcount_inst31(.in(count31), .out(popcount15));

    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;

    assign sum0 = popcount0 + popcount1;
    assign sum1 = popcount2 + popcount3;
    assign sum2 = popcount4 + popcount5;
    assign sum3 = popcount6 + popcount7;
    assign sum4 = popcount8 + popcount9;
    assign sum5 = popcount10 + popcount11;
    assign sum6 = popcount12 + popcount13;
    assign sum7 = popcount14 + popcount15;

    wire [7:0] sum8, sum9, sum10, sum11;

    assign sum8 = sum0 + sum1;
    assign sum9 = sum2 + sum3;
    assign sum10 = sum4 + sum5;
    assign sum11 = sum6 + sum7;

    wire [7:0] sum12, sum13;

    assign sum12 = sum8 + sum9;
    assign sum13 = sum10 + sum11;

    wire [7:0] sum14;

    assign sum14 = sum12 + sum13;

    assign out = sum14[7:0];

endmodule

module PopCount(in, out);
    input [7:0] in;
    output [7:0] out;

    assign out = {8{1'b0}} + 
                 (in[0] ? 1 : 0) + 
                 (in[1] ? 1 : 0) + 
                 (in[2] ? 1 : 0) + 
                 (in[3] ? 1 : 0) + 
                 (in[4] ? 1 : 0) + 
                 (in[5] ? 1 : 0) + 
                 (in[6] ? 1 : 0) + 
                 (in[7] ? 1 : 0);

endmodule