module TopModule(clk, d, q);
  input clk;
  input d;
  output q;

  reg q_reg;
  assign q = q_reg;

  reg last_clk;
  always @(posedge clk) begin
    last_clk <= ~clk;
  end

  always @(posedge clk or negedge clk) begin
    if (~last_clk & ~clk) begin // detect negative edge
      q_reg <= d;
    end else if (last_clk & clk) begin // detect positive edge
      q_reg <= d;
    end
  end
endmodule