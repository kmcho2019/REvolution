module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

  wire y3 = y[3];
  wire y2 = y[2];
  wire y1 = y[1];

  wire B = (~y3) & (~y2) & y1;
  wire C = (~y3) & y2 & (~y1);
  wire E = y3 & (~y2) & (~y1);
  wire F = y3 & (~y2) & y1;

  always @(*) begin
    Y2 = B | ((C | E) & w) | F;
  end

endmodule