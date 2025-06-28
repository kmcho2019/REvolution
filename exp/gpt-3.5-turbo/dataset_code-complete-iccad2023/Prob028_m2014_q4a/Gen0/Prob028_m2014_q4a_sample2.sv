module d_latch (
  input d,
  input ena,
  output reg q
);

  always @(posedge ena)
    if (ena)
      q <= d;

endmodule