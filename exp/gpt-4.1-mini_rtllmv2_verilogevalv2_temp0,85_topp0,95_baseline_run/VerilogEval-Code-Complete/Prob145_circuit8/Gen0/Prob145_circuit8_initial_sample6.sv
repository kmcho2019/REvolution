module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  always @(posedge clock) begin
    if (q)
      p <= a;
    else
      p <= 1'b0;

    if (p == 1'b0)
      q <= 1'b0;
    else
      q <= 1'b1;
  end

  always @(negedge clock) begin
    if (p == 1'b1)
      q <= 1'b1;
    // else q remains unchanged
  end

endmodule