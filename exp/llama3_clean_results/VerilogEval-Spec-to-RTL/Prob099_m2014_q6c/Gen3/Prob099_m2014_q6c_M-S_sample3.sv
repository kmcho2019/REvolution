module TopModule(y, w, Y1, Y3);
  input [5:0] y;
  input w;
  output reg Y1;
  output reg Y3;

  always @(*) begin
    Y1 = (y[0] &&!w) || (y[3] && w);
    Y3 = (y[1] &&!w) || (y[4] &&!w) || (y[5] &&!w);
  end
endmodule