module TopModule(clk, d, q);
  input clk;
  input d;
  output q;
  reg q_reg;
  reg d_edge;

  // Sample the input signal on the rising edge of the clock
  always @(posedge clk) begin
    d_edge <= d;
  end

  // Sample the input signal on the falling edge of the clock
  always @(negedge clk) begin
    q_reg <= d;
  end

  // Update the output on the rising edge of the clock
  always @(posedge clk) begin
    q_reg <= d_edge;
  end

  assign q = q_reg;

endmodule