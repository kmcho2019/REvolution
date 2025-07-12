module TopModule(clk, d, q);
  input       clk;
  input       d;
  output      q;

  reg         pos_q, neg_q;
  assign      q = pos_q | neg_q;

  always @(posedge clk)
    pos_q <= d;

  always @(negedge clk)
    neg_q <= d;

endmodule