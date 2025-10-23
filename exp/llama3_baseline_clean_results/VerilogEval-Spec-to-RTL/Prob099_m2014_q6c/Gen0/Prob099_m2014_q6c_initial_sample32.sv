module TopModule(y, w, Y1, Y3);
  input [5:0] y;
  input w;
  output Y1;
  output Y3;

  assign Y1 = (~w) ? 1'b0 : y[3]; // Y1 is set when w is 1 and current state is D
  assign Y3 = (~w) & (y[1] | y[5]); // Y3 is set when w is 0 and current state is either B or F
endmodule