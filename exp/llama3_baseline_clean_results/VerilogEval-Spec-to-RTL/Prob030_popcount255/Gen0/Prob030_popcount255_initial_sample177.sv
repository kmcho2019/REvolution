module TopModule(
    input [254:0] in,
    output [7:0] out
);

    wire [4:0] count0;
    wire [4:0] count1;
    wire [4:0] count2;
    wire [4:0] count3;
    wire [4:0] count4;
    wire [4:0] count5;
    wire [4:0] count6;
    wire [4:0] count7;
    wire [4:0] count8;
    wire [4:0] count9;
    wire [4:0] count10;
    wire [4:0] count11;
    wire [4:0] count12;
    wire [4:0] count13;
    wire [4:0] count14;
    wire [4:0] count15;
    wire [4:0] count16;
    wire [4:0] count17;
    wire [4:0] count18;
    wire [4:0] count19;
    wire [4:0] count20;
    wire [4:0] count21;
    wire [4:0] count22;
    wire [4:0] count23;
    wire [4:0] count24;
    wire [4:0] count25;
    wire [4:0] count26;
    wire [4:0] count27;
    wire [4:0] count28;
    wire [4:0] count29;
    wire [4:0] count30;
    wire [3:0] count31;

    assign count0 = {1'b0, in[7:0]};
    assign count1 = {1'b0, in[15:8]};
    assign count2 = {1'b0, in[23:16]};
    assign count3 = {1'b0, in[31:24]};
    assign count4 = {1'b0, in[39:32]};
    assign count5 = {1'b0, in[47:40]};
    assign count6 = {1'b0, in[55:48]};
    assign count7 = {1'b0, in[63:56]};
    assign count8 = {1'b0, in[71:64]};
    assign count9 = {1'b0, in[79:72]};
    assign count10 = {1'b0, in[87:80]};
    assign count11 = {1'b0, in[95:88]};
    assign count12 = {1'b0, in[103:96]};
    assign count13 = {1'b0, in[111:104]};
    assign count14 = {1'b0, in[119:112]};
    assign count15 = {1'b0, in[127:120]};
    assign count16 = {1'b0, in[135:128]};
    assign count17 = {1'b0, in[143:136]};
    assign count18 = {1'b0, in[151:144]};
    assign count19 = {1'b0, in[159:152]};
    assign count20 = {1'b0, in[167:160]};
    assign count21 = {1'b0, in[175:168]};
    assign count22 = {1'b0, in[183:176]};
    assign count23 = {1'b0, in[191:184]};
    assign count24 = {1'b0, in[199:192]};
    assign count25 = {1'b0, in[207:200]};
    assign count26 = {1'b0, in[215:208]};
    assign count27 = {1'b0, in[223:216]};
    assign count28 = {1'b0, in[231:224]};
    assign count29 = {1'b0, in[239:232]};
    assign count30 = {1'b0, in[247:240]};
    assign count31 = {1'b0, in[254:248]};

    assign out = count0 + count1 + count2 + count3 + count4 + count5 + count6 + count7 + count8 + count9 + count10 + count11 + count12 + count13 + count14 + count15 + count16 + count17 + count18 + count19 + count20 + count21 + count22 + count23 + count24 + count25 + count26 + count27 + count28 + count29 + count30 + count31;

endmodule