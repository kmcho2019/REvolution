module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

  always @(*) begin
    Y2 = (~w & y[1] & ~y[2]) |
         (w & ((~y[3] & ~y[2] & y[1]) | (~y[3] & y[2] & ~y[1]) | (y[3] & ~y[2])));
  end

endmodule