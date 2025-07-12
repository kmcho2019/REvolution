module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input vector into segments for hierarchical counting
    // Using 16 segments of 16 bits (except the last one which is 7 bits) for better balance
    reg [4:0] count1, count2, count3, count4, count5, count6, count7, count8, 
              count9, count10, count11, count12, count13, count14, count15, count16;
    assign count1 = $countones(in[ 15:  0]);
    assign count2 = $countones(in[ 31: 16]);
    assign count3 = $countones(in[ 47: 32]);
    assign count4 = $countones(in[ 63: 48]);
    assign count5 = $countones(in[ 79: 64]);
    assign count6 = $countones(in[ 95: 80]);
    assign count7 = $countones(in[111: 96]);
    assign count8 = $countones(in[127:112]);
    assign count9 = $countones(in[143:128]);
    assign count10 = $countones(in[159:144]);
    assign count11 = $countones(in[175:160]);
    assign count12 = $countones(in[191:176]);
    assign count13 = $countones(in[207:192]);
    assign count14 = $countones(in[223:208]);
    assign count15 = $countones(in[239:224]);
    assign count16 = $countones(in[254:240]);

    // Sum the counts from each segment using a tree-like structure for efficiency
    reg [5:0] sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8;
    assign sum1 = count1 + count2;
    assign sum2 = count3 + count4;
    assign sum3 = count5 + count6;
    assign sum4 = count7 + count8;
    assign sum5 = count9 + count10;
    assign sum6 = count11 + count12;
    assign sum7 = count13 + count14;
    assign sum8 = count15 + count16;

    reg [6:0] sum9, sum10, sum11, sum12;
    assign sum9 = sum1 + sum2;
    assign sum10 = sum3 + sum4;
    assign sum11 = sum5 + sum6;
    assign sum12 = sum7 + sum8;

    reg [7:0] sum13, sum14;
    assign sum13 = sum9 + sum10;
    assign sum14 = sum11 + sum12;

    // Final sum
    assign out = sum13 + sum14;

endmodule