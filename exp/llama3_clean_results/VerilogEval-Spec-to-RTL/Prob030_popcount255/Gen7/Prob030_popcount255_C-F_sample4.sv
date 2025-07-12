module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input vector into segments for hierarchical counting
    reg [7:0] count1, count2, count3, count4, count5, count6, count7, count8;
    assign count1 = $countones(in[ 31:  0]);
    assign count2 = $countones(in[ 63: 32]);
    assign count3 = $countones(in[ 95: 64]);
    assign count4 = $countones(in[127: 96]);
    assign count5 = $countones(in[159:128]);
    assign count6 = $countones(in[191:160]);
    assign count7 = $countones(in[223:192]);
    assign count8 = $countones(in[254:224]);

    // Sum the counts from each segment
    assign out = count1 + count2 + count3 + count4 + count5 + count6 + count7 + count8;

endmodule