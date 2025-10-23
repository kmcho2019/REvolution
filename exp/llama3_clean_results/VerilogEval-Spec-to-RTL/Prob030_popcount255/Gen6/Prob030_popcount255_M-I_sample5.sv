module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the 255-bit input vector into 17 sub-vectors of 15 bits each
wire [15:0] subvec1, subvec2, subvec3, subvec4, subvec5, subvec6, subvec7, subvec8, subvec9, subvec10, subvec11, subvec12, subvec13, subvec14, subvec15, subvec16, subvec17;

assign subvec1 = in[14:0];
assign subvec2 = in[29:15];
assign subvec3 = in[44:30];
assign subvec4 = in[59:45];
assign subvec5 = in[74:60];
assign subvec6 = in[89:75];
assign subvec7 = in[104:90];
assign subvec8 = in[119:105];
assign subvec9 = in[134:120];
assign subvec10 = in[149:135];
assign subvec11 = in[164:150];
assign subvec12 = in[179:165];
assign subvec13 = in[194:180];
assign subvec14 = in[209:195];
assign subvec15 = in[224:210];
assign subvec16 = in[239:225];
assign subvec17 = in[254:240];

// Calculate the population count of each sub-vector
wire [3:0] count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15, count16, count17;

always @(subvec1, subvec2, subvec3, subvec4, subvec5, subvec6, subvec7, subvec8, subvec9, subvec10, subvec11, subvec12, subvec13, subvec14, subvec15, subvec16, subvec17) begin
    count1 = $countones(subvec1);
    count2 = $countones(subvec2);
    count3 = $countones(subvec3);
    count4 = $countones(subvec4);
    count5 = $countones(subvec5);
    count6 = $countones(subvec6);
    count7 = $countones(subvec7);
    count8 = $countones(subvec8);
    count9 = $countones(subvec9);
    count10 = $countones(subvec10);
    count11 = $countones(subvec11);
    count12 = $countones(subvec12);
    count13 = $countones(subvec13);
    count14 = $countones(subvec14);
    count15 = $countones(subvec15);
    count16 = $countones(subvec16);
    count17 = $countones(subvec17);
end

// Calculate the total population count
wire [7:0] total_count;

assign total_count = count1 + count2 + count3 + count4 + count5 + count6 + count7 + count8 + count9 + count10 + count11 + count12 + count13 + count14 + count15 + count16 + count17;

// Assign the total population count to the output
assign out = total_count;

endmodule