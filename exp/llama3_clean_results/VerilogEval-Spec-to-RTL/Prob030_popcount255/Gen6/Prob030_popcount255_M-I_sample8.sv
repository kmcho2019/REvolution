module TopModule(
    input [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Divide the input vector into 16 segments of 16 bits each
reg [3:0] count0, count1, count2, count3, count4, count5, count6, count7;
reg [3:0] count8, count9, count10, count11, count12, count13, count14, count15;

always @(in) begin
    count0 = $countones(in[15:0]);
    count1 = $countones(in[31:16]);
    count2 = $countones(in[47:32]);
    count3 = $countones(in[63:48]);
    count4 = $countones(in[79:64]);
    count5 = $countones(in[95:80]);
    count6 = $countones(in[111:96]);
    count7 = $countones(in[127:112]);
    count8 = $countones(in[143:128]);
    count9 = $countones(in[159:144]);
    count10 = $countones(in[175:160]);
    count11 = $countones(in[191:176]);
    count12 = $countones(in[207:192]);
    count13 = $countones(in[223:208]);
    count14 = $countones(in[239:224]);
    count15 = $countones(in[254:240]);

    // Sum up the counts using a tree-based structure
    count = count0 + count1 + count2 + count3 + count4 + count5 + count6 + count7 +
            count8 + count9 + count10 + count11 + count12 + count13 + count14 + count15;
end

assign out = count;

endmodule