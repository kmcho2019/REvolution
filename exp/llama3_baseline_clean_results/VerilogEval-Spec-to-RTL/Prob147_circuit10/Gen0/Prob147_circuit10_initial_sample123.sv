module TopModule(clk, a, b, q, state);
  input clk, a, b;
  output q, state;
  reg state;

  always @(posedge clk) begin
    if (a && b) begin
      state <= 0;
    end else if (!a && !b) begin
      state <= 1;
    end else begin
      state <= state;
    end
  end

  assign q = (b && !state) || (a && state);

endmodule