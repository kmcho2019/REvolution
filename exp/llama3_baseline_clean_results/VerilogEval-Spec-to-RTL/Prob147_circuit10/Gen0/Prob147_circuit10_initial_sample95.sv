module TopModule(clk, a, b, q, state);
  input clk;
  input a;
  input b;
  output q;
  output state;

  reg state;

  always @(posedge clk) begin
    if (a && b) begin
      state <= ~state;
    end else begin
      state <= state;
    end
  end

  assign q = (a && b) ? ~state : state;
endmodule