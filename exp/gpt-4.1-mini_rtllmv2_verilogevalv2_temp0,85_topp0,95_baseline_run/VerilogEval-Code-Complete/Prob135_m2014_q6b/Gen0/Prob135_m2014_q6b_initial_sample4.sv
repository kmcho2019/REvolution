module TopModule (
  input [3:1] y,
  input w,
  output reg Y2
);

  always @(*) begin
    Y2 = (~y[3] & ~y[2] & y[1])       // B
        | (~y[3] & y[2] & ~y[1] & w) // C & w=1
        | (y[3] & ~y[2] & ~y[1] & w) // E & w=1
        | (y[3] & ~y[2] & y[1]);     // F
  end

endmodule