module TopModule(
    input [255:0] in,
    output [7:0] out
);

    wire [7:0] count0;
    wire [7:0] count1;
    wire [7:0] count2;
    wire [7:0] count3;
    wire [7:0] count4;
    wire [7:0] count5;
    wire [7:0] count6;
    wire [7:0] count7;
    wire [7:0] count8;
    wire [7:0] count9;
    wire [7:0] count10;
    wire [7:0] count11;
    wire [7:0] count12;
    wire [7:0] count13;
    wire [7:0] count14;
    wire [7:0] count15;
    wire [7:0] count16;
    wire [7:0] count17;
    wire [7:0] count18;
    wire [7:0] count19;
    wire [7:0] count20;
    wire [7:0] count21;
    wire [7:0] count22;
    wire [7:0] count23;
    wire [7:0] count24;
    wire [7:0] count25;
    wire [7:0] count26;
    wire [7:0] count27;
    wire [7:0] count28;
    wire [7:0] count29;
    wire [7:0] count30;
    wire [7:0] count31;

    // 8-bit population count
    eight_bit_counter counter0 (.in(in[7:0]), .out(count0));
    eight_bit_counter counter1 (.in(in[15:8]), .out(count1));
    eight_bit_counter counter2 (.in(in[23:16]), .out(count2));
    eight_bit_counter counter3 (.in(in[31:24]), .out(count3));
    eight_bit_counter counter4 (.in(in[39:32]), .out(count4));
    eight_bit_counter counter5 (.in(in[47:40]), .out(count5));
    eight_bit_counter counter6 (.in(in[55:48]), .out(count6));
    eight_bit_counter counter7 (.in(in[63:56]), .out(count7));
    eight_bit_counter counter8 (.in(in[71:64]), .out(count8));
    eight_bit_counter counter9 (.in(in[79:72]), .out(count9));
    eight_bit_counter counter10 (.in(in[87:80]), .out(count10));
    eight_bit_counter counter11 (.in(in[95:88]), .out(count11));
    eight_bit_counter counter12 (.in(in[103:96]), .out(count12));
    eight_bit_counter counter13 (.in(in[111:104]), .out(count13));
    eight_bit_counter counter14 (.in(in[119:112]), .out(count14));
    eight_bit_counter counter15 (.in(in[127:120]), .out(count15));
    eight_bit_counter counter16 (.in(in[135:128]), .out(count16));
    eight_bit_counter counter17 (.in(in[143:136]), .out(count17));
    eight_bit_counter counter18 (.in(in[151:144]), .out(count18));
    eight_bit_counter counter19 (.in(in[159:152]), .out(count19));
    eight_bit_counter counter20 (.in(in[167:160]), .out(count20));
    eight_bit_counter counter21 (.in(in[175:168]), .out(count21));
    eight_bit_counter counter22 (.in(in[183:176]), .out(count22));
    eight_bit_counter counter23 (.in(in[191:184]), .out(count23));
    eight_bit_counter counter24 (.in(in[199:192]), .out(count24));
    eight_bit_counter counter25 (.in(in[207:200]), .out(count25));
    eight_bit_counter counter26 (.in(in[215:208]), .out(count26));
    eight_bit_counter counter27 (.in(in[223:216]), .out(count27));
    eight_bit_counter counter28 (.in(in[231:224]), .out(count28));
    eight_bit_counter counter29 (.in(in[239:232]), .out(count29));
    eight_bit_counter counter30 (.in(in[247:240]), .out(count30));
    seven_bit_counter counter31 (.in(in[254:248]), .out(count31));

    // Add up all the counts
    wire [8:0] sum0;
    wire [8:0] sum1;
    wire [8:0] sum2;
    wire [8:0] sum3;
    wire [8:0] sum4;
    assign sum0 = count0 + count1;
    assign sum1 = count2 + count3;
    assign sum2 = count4 + count5;
    assign sum3 = count6 + count7;
    assign sum4 = count8 + count9;

    wire [9:0] sum5;
    wire [9:0] sum6;
    wire [9:0] sum7;
    wire [9:0] sum8;
    assign sum5 = sum0 + sum1;
    assign sum6 = sum2 + sum3;
    assign sum7 = sum4 + count10;
    assign sum8 = count11 + count12;

    wire [10:0] sum9;
    wire [10:0] sum10;
    wire [10:0] sum11;
    assign sum9 = sum5 + sum6;
    assign sum10 = sum7 + sum8;
    assign sum11 = count13 + count14;

    wire [11:0] sum12;
    wire [11:0] sum13;
    assign sum12 = sum9 + sum10;
    assign sum13 = sum11 + count15;

    wire [12:0] sum14;
    wire [12:0] sum15;
    assign sum14 = sum12 + sum13;
    assign sum15 = count16 + count17;

    wire [13:0] sum16;
    wire [13:0] sum17;
    assign sum16 = sum14 + sum15;
    assign sum17 = count18 + count19;

    wire [14:0] sum18;
    wire [14:0] sum19;
    assign sum18 = sum16 + sum17;
    assign sum19 = count20 + count21;

    wire [15:0] sum20;
    wire [15:0] sum21;
    assign sum20 = sum18 + sum19;
    assign sum21 = count22 + count23;

    wire [16:0] sum22;
    wire [16:0] sum23;
    assign sum22 = sum20 + sum21;
    assign sum23 = count24 + count25;

    wire [17:0] sum24;
    wire [17:0] sum25;
    assign sum24 = sum22 + sum23;
    assign sum25 = count26 + count27;

    wire [18:0] sum26;
    wire [18:0] sum27;
    assign sum26 = sum24 + sum25;
    assign sum27 = count28 + count29;

    wire [19:0] sum28;
    wire [19:0] sum29;
    assign sum28 = sum26 + sum27;
    assign sum29 = count30 + count31;

    wire [20:0] sum30;
    assign sum30 = sum28 + sum29;

    // Final output
    assign out = sum30[7:0];

endmodule

module eight_bit_counter(
    input [7:0] in,
    output [7:0] out
);
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} +
                 {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]} + {1'b0, in[7]};
endmodule

module seven_bit_counter(
    input [6:0] in,
    output [7:0] out
);
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} +
                 {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]};
endmodule