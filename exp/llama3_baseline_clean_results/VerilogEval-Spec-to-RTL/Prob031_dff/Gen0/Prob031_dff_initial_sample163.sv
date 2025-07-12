module TopModule(clk, d, q);
  input clk;
  input d;
  output q;
  reg q_reg;

  always @(posedge clk) begin
    q_reg = d;
  end

  assign q = q_reg;

endmodule