module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Count the number of '1's in each 8-bit segment of the input
    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7, 
           count8, count9, count10, count11, count12, count13, count14, 
           count15, count16, count17, count18, count19, count20, count21, 
           count22, count23, count24, count25, count26, count27, count28, 
           count29, count30, count31;

    // Use 8-bit population count for each 8-bit segment
    PopulationCount8 in0 (.in(in[7:0]), .out(count0));
    PopulationCount8 in1 (.in(in[15:8]), .out(count1));
    PopulationCount8 in2 (.in(in[23:16]), .out(count2));
    PopulationCount8 in3 (.in(in[31:24]), .out(count3));
    PopulationCount8 in4 (.in(in[39:32]), .out(count4));
    PopulationCount8 in5 (.in(in[47:40]), .out(count5));
    PopulationCount8 in6 (.in(in[55:48]), .out(count6));
    PopulationCount8 in7 (.in(in[63:56]), .out(count7));
    PopulationCount8 in8 (.in(in[71:64]), .out(count8));
    PopulationCount8 in9 (.in(in[79:72]), .out(count9));
    PopulationCount8 in10 (.in(in[87:80]), .out(count10));
    PopulationCount8 in11 (.in(in[95:88]), .out(count11));
    PopulationCount8 in12 (.in(in[103:96]), .out(count12));
    PopulationCount8 in13 (.in(in[111:104]), .out(count13));
    PopulationCount8 in14 (.in(in[119:112]), .out(count14));
    PopulationCount8 in15 (.in(in[127:120]), .out(count15));
    PopulationCount8 in16 (.in(in[135:128]), .out(count16));
    PopulationCount8 in17 (.in(in[143:136]), .out(count17));
    PopulationCount8 in18 (.in(in[151:144]), .out(count18));
    PopulationCount8 in19 (.in(in[159:152]), .out(count19));
    PopulationCount8 in20 (.in(in[167:160]), .out(count20));
    PopulationCount8 in21 (.in(in[175:168]), .out(count21));
    PopulationCount8 in22 (.in(in[183:176]), .out(count22));
    PopulationCount8 in23 (.in(in[191:184]), .out(count23));
    PopulationCount8 in24 (.in(in[199:192]), .out(count24));
    PopulationCount8 in25 (.in(in[207:200]), .out(count25));
    PopulationCount8 in26 (.in(in[215:208]), .out(count26));
    PopulationCount8 in27 (.in(in[223:216]), .out(count27));
    PopulationCount8 in28 (.in(in[231:224]), .out(count28));
    PopulationCount8 in29 (.in(in[239:232]), .out(count29));
    PopulationCount8 in30 (.in(in[247:240]), .out(count30));
    PopulationCount8 in31 (.in(in[254:248]), .out(count31));

    // Sum the counts
    wire [8:0] sum0, sum1, sum2, sum3;
    assign sum0 = count0 + count1 + count2 + count3 + count4 + count5 + count6 + count7;
    assign sum1 = count8 + count9 + count10 + count11 + count12 + count13 + count14 + count15;
    assign sum2 = count16 + count17 + count18 + count19 + count20 + count21 + count22 + count23;
    assign sum3 = count24 + count25 + count26 + count27 + count28 + count29 + count30 + count31;

    // Final sum
    assign out = sum0 + sum1 + sum2 + sum3;

endmodule

module PopulationCount8(
    input  [7:0] in,
    output [7:0] out
);

    assign out = {8{1'b0}} + 
                 (in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7]);

endmodule