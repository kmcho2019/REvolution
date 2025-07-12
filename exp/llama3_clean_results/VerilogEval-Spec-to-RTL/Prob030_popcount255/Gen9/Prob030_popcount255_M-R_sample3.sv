module popcount17(
    input [16:0] in,
    output [4:0] out
);

    assign out = {in[16], in[15], in[14], in[13], in[12]} + 
                 {in[11], in[10], in[9], in[8], in[7]} + 
                 {in[6], in[5], in[4], in[3], in[2]} + 
                 {in[1], in[0], 1'b0, 1'b0, 1'b0};

endmodule

module TopModule(
    input [254:0] in,
    output [7:0] out
);

    wire [4:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14;
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;

    popcount17 u0 (.in(in[16:0]), .out(count0));
    popcount17 u1 (.in(in[33:17]), .out(count1));
    popcount17 u2 (.in(in[50:34]), .out(count2));
    popcount17 u3 (.in(in[67:51]), .out(count3));
    popcount17 u4 (.in(in[84:68]), .out(count4));
    popcount17 u5 (.in(in[101:85]), .out(count5));
    popcount17 u6 (.in(in[118:102]), .out(count6));
    popcount17 u7 (.in(in[135:119]), .out(count7));
    popcount17 u8 (.in(in[152:136]), .out(count8));
    popcount17 u9 (.in(in[169:153]), .out(count9));
    popcount17 u10 (.in(in[186:170]), .out(count10));
    popcount17 u11 (.in(in[203:187]), .out(count11));
    popcount17 u12 (.in(in[220:204]), .out(count12));
    popcount17 u13 (.in(in[237:221]), .out(count13));
    popcount17 u14 (.in(in[254:238]), .out(count14));

    assign sum0 = count0 + count1;
    assign sum1 = count2 + count3;
    assign sum2 = count4 + count5;
    assign sum3 = count6 + count7;
    assign sum4 = count8 + count9;
    assign sum5 = count10 + count11;
    assign sum6 = count12 + count13;
    assign sum7 = count14 + 5'b0;

    assign out = (sum0 + sum1 + sum2 + sum3 + sum4 + sum5 + sum6 + sum7)[7:0];

endmodule