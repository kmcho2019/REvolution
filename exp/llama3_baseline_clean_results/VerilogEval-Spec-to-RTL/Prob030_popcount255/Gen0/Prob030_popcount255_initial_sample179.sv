module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Count '1's in each byte (8 bits)
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

// Count '1's in each byte
ones_counter ones_counter0(.in(in[7:0]), .out(count0));
ones_counter ones_counter1(.in(in[15:8]), .out(count1));
ones_counter ones_counter2(.in(in[23:16]), .out(count2));
ones_counter ones_counter3(.in(in[31:24]), .out(count3));
ones_counter ones_counter4(.in(in[39:32]), .out(count4));
ones_counter ones_counter5(.in(in[47:40]), .out(count5));
ones_counter ones_counter6(.in(in[55:48]), .out(count6));
ones_counter ones_counter7(.in(in[63:56]), .out(count7));
ones_counter ones_counter8(.in(in[71:64]), .out(count8));
ones_counter ones_counter9(.in(in[79:72]), .out(count9));
ones_counter ones_counter10(.in(in[87:80]), .out(count10));
ones_counter ones_counter11(.in(in[95:88]), .out(count11));
ones_counter ones_counter12(.in(in[103:96]), .out(count12));
ones_counter ones_counter13(.in(in[111:104]), .out(count13));
ones_counter ones_counter14(.in(in[119:112]), .out(count14));
ones_counter ones_counter15(.in(in[127:120]), .out(count15));
ones_counter ones_counter16(.in(in[135:128]), .out(count16));
ones_counter ones_counter17(.in(in[143:136]), .out(count17));
ones_counter ones_counter18(.in(in[151:144]), .out(count18));
ones_counter ones_counter19(.in(in[159:152]), .out(count19));
ones_counter ones_counter20(.in(in[167:160]), .out(count20));
ones_counter ones_counter21(.in(in[175:168]), .out(count21));
ones_counter ones_counter22(.in(in[183:176]), .out(count22));
ones_counter ones_counter23(.in(in[191:184]), .out(count23));
ones_counter ones_counter24(.in(in[199:192]), .out(count24));
ones_counter ones_counter25(.in(in[207:200]), .out(count25));
ones_counter ones_counter26(.in(in[215:208]), .out(count26));
ones_counter ones_counter27(.in(in[223:216]), .out(count27));
ones_counter ones_counter28(.in(in[231:224]), .out(count28));
ones_counter ones_counter29(.in(in[239:232]), .out(count29));
ones_counter ones_counter30(.in(in[247:240]), .out(count30));
ones_counter ones_counter31(.in(in[254:247]), .out(count31));

// Sum up all counts
wire [8:0] sum;
assign sum = {1'b0, count0} + {1'b0, count1} + {1'b0, count2} + {1'b0, count3} + {1'b0, count4} + {1'b0, count5} + {1'b0, count6} + {1'b0, count7} + {1'b0, count8} + {1'b0, count9} + {1'b0, count10} + {1'b0, count11} + {1'b0, count12} + {1'b0, count13} + {1'b0, count14} + {1'b0, count15} + {1'b0, count16} + {1'b0, count17} + {1'b0, count18} + {1'b0, count19} + {1'b0, count20} + {1'b0, count21} + {1'b0, count22} + {1'b0, count23} + {1'b0, count24} + {1'b0, count25} + {1'b0, count26} + {1'b0, count27} + {1'b0, count28} + {1'b0, count29} + {1'b0, count30} + {1'b0, count31};

// Output sum (ignoring carry)
assign out = sum[7:0];

endmodule

module ones_counter(
    input [7:0] in,
    output [7:0] out
);
    assign out = {8{1'b0}} + in;
endmodule