module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Count the number of '1's in each 8-bit chunk
    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7, 
             count8, count9, count10, count11, count12, count13, count14, 
             count15;
    assign count0 = in[7:0] + 8'd0;
    assign count1 = in[15:8] + 8'd0;
    assign count2 = in[23:16] + 8'd0;
    assign count3 = in[31:24] + 8'd0;
    assign count4 = in[39:32] + 8'd0;
    assign count5 = in[47:40] + 8'd0;
    assign count6 = in[55:48] + 8'd0;
    assign count7 = in[63:56] + 8'd0;
    assign count8 = in[71:64] + 8'd0;
    assign count9 = in[79:72] + 8'd0;
    assign count10 = in[87:80] + 8'd0;
    assign count11 = in[95:88] + 8'd0;
    assign count12 = in[103:96] + 8'd0;
    assign count13 = in[111:104] + 8'd0;
    assign count14 = in[119:112] + 8'd0;
    assign count15 = in[127:120] + 8'd0;
    assign count16 = in[135:128] + 8'd0;
    assign count17 = in[143:136] + 8'd0;
    assign count18 = in[151:144] + 8'd0;
    assign count19 = in[159:152] + 8'd0;
    assign count20 = in[167:160] + 8'd0;
    assign count21 = in[175:168] + 8'd0;
    assign count22 = in[183:176] + 8'd0;
    assign count23 = in[191:184] + 8'd0;
    assign count24 = in[199:192] + 8'd0;
    assign count25 = in[207:200] + 8'd0;
    assign count26 = in[215:208] + 8'd0;
    assign count27 = in[223:216] + 8'd0;
    assign count28 = in[231:224] + 8'd0;
    assign count29 = in[239:232] + 8'd0;
    assign count30 = in[247:240] + 8'd0;
    assign count31 = in[254:248] + 8'd0;

    // Add up the counts using a tree-like structure
    wire [8:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14;
    assign sum0 = {1'b0, count0} + {1'b0, count1};
    assign sum1 = {1'b0, count2} + {1'b0, count3};
    assign sum2 = {1'b0, count4} + {1'b0, count5};
    assign sum3 = {1'b0, count6} + {1'b0, count7};
    assign sum4 = {1'b0, count8} + {1'b0, count9};
    assign sum5 = {1'b0, count10} + {1'b0, count11};
    assign sum6 = {1'b0, count12} + {1'b0, count13};
    assign sum7 = {1'b0, count14} + {1'b0, count15};
    assign sum8 = {1'b0, count16} + {1'b0, count17};
    assign sum9 = {1'b0, count18} + {1'b0, count19};
    assign sum10 = {1'b0, count20} + {1'b0, count21};
    assign sum11 = {1'b0, count22} + {1'b0, count23};
    assign sum12 = {1'b0, count24} + {1'b0, count25};
    assign sum13 = {1'b0, count26} + {1'b0, count27};
    assign sum14 = {1'b0, count28} + {1'b0, count29};
    assign sum15 = {1'b0, count30} + {1'b0, count31};
    wire [8:0] sum16 = sum0 + sum1;
    wire [8:0] sum17 = sum2 + sum3;
    wire [8:0] sum18 = sum4 + sum5;
    wire [8:0] sum19 = sum6 + sum7;
    wire [8:0] sum20 = sum8 + sum9;
    wire [8:0] sum21 = sum10 + sum11;
    wire [8:0] sum22 = sum12 + sum13;
    wire [8:0] sum23 = sum14 + sum15;
    wire [8:0] sum24 = sum16 + sum17;
    wire [8:0] sum25 = sum18 + sum19;
    wire [8:0] sum26 = sum20 + sum21;
    wire [8:0] sum27 = sum22 + sum23;
    wire [9:0] sum28 = {1'b0, sum24} + {1'b0, sum25};
    wire [9:0] sum29 = {1'b0, sum26} + {1'b0, sum27};
    wire [10:0] sum30 = {1'b0, sum28} + {1'b0, sum29};
    assign out = sum30[8:1];

endmodule