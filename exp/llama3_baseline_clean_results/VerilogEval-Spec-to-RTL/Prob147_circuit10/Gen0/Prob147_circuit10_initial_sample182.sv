module TopModule(clk, a, b, q, state);
  input clk, a, b;
  output q, state;
  reg state;
  always @(posedge clk) begin
    state <= q;
  end
  assign q = b && (!a || state);
endmodule