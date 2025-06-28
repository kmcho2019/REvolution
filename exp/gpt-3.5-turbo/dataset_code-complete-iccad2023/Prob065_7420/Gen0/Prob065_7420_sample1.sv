module TopModule (
  input p1a,
  input p1b,
  input p1c,
  input p1d,
  output p1y,
  input p2a,
  input p2b,
  input p2c,
  input p2d,
  output p2y
);

  reg p1_out, p2_out;

  always @* begin
    p1_out = ~(p1a & p1b & p1c & p1d);
    p2_out = ~(p2a & p2b & p2c & p2d);
  end

  assign p1y = p1_out;
  assign p2y = p2_out;

endmodule