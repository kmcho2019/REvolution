module counter_8bit(
  input [7:0] in,
  output [3:0] out
);
  assign out = {in[7] + in[6], in[5] + in[4], in[3] + in[2], in[1] + in[0]};
  assign out = {out[3] + out[2], out[1], out[0]};
  assign out = {out[3] + out[2], out[1] + out[0]};
  assign out = {1'b0, out[3:1] + out[0]};
endmodule

module TopModule(
  input [254:0] in,
  output [7:0] out
);
  wire [3:0] count0, count1, count2, count3, count4, count5, count6, count7, count8, count9, count10, count11, count12, count13, count14, count15, count16, count17, count18, count19, count20, count21, count22, count23, count24, count25, count26, count27, count28, count29, count30, count31;
  wire [7:0] sum0, sum1, sum2, sum3, sum4;
  
  counter_8bit u0 (.in(in[7:0]), .out(count0));
  counter_8bit u1 (.in(in[15:8]), .out(count1));
  counter_8bit u2 (.in(in[23:16]), .out(count2));
  counter_8bit u3 (.in(in[31:24]), .out(count3));
  counter_8bit u4 (.in(in[39:32]), .out(count4));
  counter_8bit u5 (.in(in[47:40]), .out(count5));
  counter_8bit u6 (.in(in[55:48]), .out(count6));
  counter_8bit u7 (.in(in[63:56]), .out(count7));
  counter_8bit u8 (.in(in[71:64]), .out(count8));
  counter_8bit u9 (.in(in[79:72]), .out(count9));
  counter_8bit u10 (.in(in[87:80]), .out(count10));
  counter_8bit u11 (.in(in[95:88]), .out(count11));
  counter_8bit u12 (.in(in[103:96]), .out(count12));
  counter_8bit u13 (.in(in[111:104]), .out(count13));
  counter_8bit u14 (.in(in[119:112]), .out(count14));
  counter_8bit u15 (.in(in[127:120]), .out(count15));
  counter_8bit u16 (.in(in[135:128]), .out(count16));
  counter_8bit u17 (.in(in[143:136]), .out(count17));
  counter_8bit u18 (.in(in[151:144]), .out(count18));
  counter_8bit u19 (.in(in[159:152]), .out(count19));
  counter_8bit u20 (.in(in[167:160]), .out(count20));
  counter_8bit u21 (.in(in[175:168]), .out(count21));
  counter_8bit u22 (.in(in[183:176]), .out(count22));
  counter_8bit u23 (.in(in[191:184]), .out(count23));
  counter_8bit u24 (.in(in[199:192]), .out(count24));
  counter_8bit u25 (.in(in[207:200]), .out(count25));
  counter_8bit u26 (.in(in[215:208]), .out(count26));
  counter_8bit u27 (.in(in[223:216]), .out(count27));
  counter_8bit u28 (.in(in[231:224]), .out(count28));
  counter_8bit u29 (.in(in[239:232]), .out(count29));
  counter_8bit u30 (.in(in[247:240]), .out(count30));
  counter_8bit u31 (.in(in[254:247]), .out(count31));

  assign sum0 = count0 + count1 + count2 + count3;
  assign sum1 = count4 + count5 + count6 + count7;
  assign sum2 = count8 + count9 + count10 + count11;
  assign sum3 = count12 + count13 + count14 + count15;
  assign sum4 = count16 + count17 + count18 + count19 + count20 + count21 + count22 + count23 + count24 + count25 + count26 + count27 + count28 + count29 + count30 + count31;

  assign out = sum0 + sum1 + sum2 + sum3 + sum4;
endmodule