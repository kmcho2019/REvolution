module TopModule(in, out);
    input [255:0] in;
    output [7:0] out;

    // Count the number of '1's in each 8-bit chunk
    wire [7:0] count0, count1, count2, count3, count4, count5, count6, count7, 
             count8, count9, count10, count11, count12, count13, count14, 
             count15, count16, count17, count18, count19, count20, count21, 
             count22, count23, count24, count25, count26, count27, count28, 
             count29, count30, count31;
    OneBitCounter bit_counter0  (.in(in[7:0]),  .out(count0));
    OneBitCounter bit_counter1  (.in(in[15:8]), .out(count1));
    OneBitCounter bit_counter2  (.in(in[23:16]), .out(count2));
    OneBitCounter bit_counter3  (.in(in[31:24]), .out(count3));
    OneBitCounter bit_counter4  (.in(in[39:32]), .out(count4));
    OneBitCounter bit_counter5  (.in(in[47:40]), .out(count5));
    OneBitCounter bit_counter6  (.in(in[55:48]), .out(count6));
    OneBitCounter bit_counter7  (.in(in[63:56]), .out(count7));
    OneBitCounter bit_counter8  (.in(in[71:64]), .out(count8));
    OneBitCounter bit_counter9  (.in(in[79:72]), .out(count9));
    OneBitCounter bit_counter10 (.in(in[87:80]), .out(count10));
    OneBitCounter bit_counter11 (.in(in[95:88]), .out(count11));
    OneBitCounter bit_counter12 (.in(in[103:96]), .out(count12));
    OneBitCounter bit_counter13 (.in(in[111:104]), .out(count13));
    OneBitCounter bit_counter14 (.in(in[119:112]), .out(count14));
    OneBitCounter bit_counter15 (.in(in[127:120]), .out(count15));
    OneBitCounter bit_counter16 (.in(in[135:128]), .out(count16));
    OneBitCounter bit_counter17 (.in(in[143:136]), .out(count17));
    OneBitCounter bit_counter18 (.in(in[151:144]), .out(count18));
    OneBitCounter bit_counter19 (.in(in[159:152]), .out(count19));
    OneBitCounter bit_counter20 (.in(in[167:160]), .out(count20));
    OneBitCounter bit_counter21 (.in(in[175:168]), .out(count21));
    OneBitCounter bit_counter22 (.in(in[183:176]), .out(count22));
    OneBitCounter bit_counter23 (.in(in[191:184]), .out(count23));
    OneBitCounter bit_counter24 (.in(in[199:192]), .out(count24));
    OneBitCounter bit_counter25 (.in(in[207:200]), .out(count25));
    OneBitCounter bit_counter26 (.in(in[215:208]), .out(count26));
    OneBitCounter bit_counter27 (.in(in[223:216]), .out(count27));
    OneBitCounter bit_counter28 (.in(in[231:224]), .out(count28));
    OneBitCounter bit_counter29 (.in(in[239:232]), .out(count29));
    OneBitCounter bit_counter30 (.in(in[247:240]), .out(count30));
    OneBitCounter bit_counter31 (.in(in[255:248]), .out(count31));

    // Add the counts of '1's in each 8-bit chunk
    wire [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7, 
             sum8, sum9, sum10, sum11, sum12, sum13, sum14, 
             sum15;
    Adder8bit adder0  (.in0(count0), .in1(count1),  .out(sum0));
    Adder8bit adder1  (.in0(count2), .in1(count3),  .out(sum1));
    Adder8bit adder2  (.in0(count4), .in1(count5),  .out(sum2));
    Adder8bit adder3  (.in0(count6), .in1(count7),  .out(sum3));
    Adder8bit adder4  (.in0(count8), .in1(count9),  .out(sum4));
    Adder8bit adder5  (.in0(count10), .in1(count11), .out(sum5));
    Adder8bit adder6  (.in0(count12), .in1(count13), .out(sum6));
    Adder8bit adder7  (.in0(count14), .in1(count15), .out(sum7));
    Adder8bit adder8  (.in0(count16), .in1(count17), .out(sum8));
    Adder8bit adder9  (.in0(count18), .in1(count19), .out(sum9));
    Adder8bit adder10 (.in0(count20), .in1(count21), .out(sum10));
    Adder8bit adder11 (.in0(count22), .in1(count23), .out(sum11));
    Adder8bit adder12 (.in0(count24), .in1(count25), .out(sum12));
    Adder8bit adder13 (.in0(count26), .in1(count27), .out(sum13));
    Adder8bit adder14 (.in0(count28), .in1(count29), .out(sum14));
    Adder8bit adder15 (.in0(count30), .in1(count31), .out(sum15));

    // Add the results of the previous level
    wire [7:0] sum16, sum17, sum18, sum19, sum20, sum21, sum22, sum23;
    Adder8bit adder16 (.in0(sum0), .in1(sum1),  .out(sum16));
    Adder8bit adder17 (.in0(sum2), .in1(sum3),  .out(sum17));
    Adder8bit adder18 (.in0(sum4), .in1(sum5),  .out(sum18));
    Adder8bit adder19 (.in0(sum6), .in1(sum7),  .out(sum19));
    Adder8bit adder20 (.in0(sum8), .in1(sum9),  .out(sum20));
    Adder8bit adder21 (.in0(sum10), .in1(sum11), .out(sum21));
    Adder8bit adder22 (.in0(sum12), .in1(sum13), .out(sum22));
    Adder8bit adder23 (.in0(sum14), .in1(sum15), .out(sum23));

    // Add the results of the previous level
    wire [7:0] sum24, sum25;
    Adder8bit adder24 (.in0(sum16), .in1(sum17), .out(sum24));
    Adder8bit adder25 (.in0(sum18), .in1(sum19), .out(sum25));

    // Add the results of the previous level
    wire [7:0] sum26, sum27;
    Adder8bit adder26 (.in0(sum20), .in1(sum21), .out(sum26));
    Adder8bit adder27 (.in0(sum22), .in1(sum23), .out(sum27));

    // Add the results of the previous level
    wire [7:0] sum28, sum29;
    Adder8bit adder28 (.in0(sum24), .in1(sum25), .out(sum28));
    Adder8bit adder29 (.in0(sum26), .in1(sum27), .out(sum29));

    // Add the final results
    Adder8bit adder30 (.in0(sum28), .in1(sum29), .out(out));
endmodule

module OneBitCounter(in, out);
    input [7:0] in;
    output [7:0] out;

    assign out = {8{in[0]} + {8{in[1]}} + {8{in[2]}} + {8{in[3]}} + 
                 {8{in[4]}} + {8{in[5]}} + {8{in[6]}} + {8{in[7]}};
endmodule

module Adder8bit(in0, in1, out);
    input [7:0] in0, in1;
    output [7:0] out;

    assign out = in0 + in1;
endmodule