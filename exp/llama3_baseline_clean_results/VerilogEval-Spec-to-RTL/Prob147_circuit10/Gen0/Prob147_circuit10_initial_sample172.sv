module TopModule(clk, a, b, q, state);
  input clk, a, b;
  output q, state;
  reg state;

  always @(posedge clk) begin
    if (~a & b) begin
      state <= 1;
    end else if (a & b) begin
      state <= ~state;
    end
  end

  assign q = (state == 0) ? (a == 0 && b == 1) : (a == 0 || b == 0);
endmodule