module TopModule(d, ena, q);
  input d;
  input ena;
  output reg q;

  reg internal_clk;

  always @(posedge ena) begin
    internal_clk <= ~internal_clk;
  end

  always @(posedge internal_clk) begin
    q <= d;
  end
endmodule