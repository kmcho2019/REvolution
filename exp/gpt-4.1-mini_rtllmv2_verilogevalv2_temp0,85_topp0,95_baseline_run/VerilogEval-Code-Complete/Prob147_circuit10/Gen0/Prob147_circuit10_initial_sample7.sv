module TopModule (
  input clk,
  input a,
  input b,
  output q,
  output state
);
  reg q_reg;

  wire d;
  assign d = (a & b) ^ q_reg; // next state logic

  always @(posedge clk) begin
    q_reg <= d;
  end

  assign q = q_reg;
  assign state = q_reg;

endmodule