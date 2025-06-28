module TopModule (
  input x,
  output reg z
);

  reg d1, d2, d3, z_output;

  // Logic gates
  assign d1 = x ^ d2;
  assign d2 = x & ~d2;
  assign d3 = x | ~d3;

  // D flip-flops
  always @(posedge clk)
  begin
    d1 <= d1;
    d2 <= d2;
    d3 <= d3;
  end

  // Output generation
  always @(*)
  begin
    z_output = ~(d1 | d2 | d3);
    z <= z_output;
  end

endmodule