module TopModule (
  input clk,
  input d,
  output reg q
);

  reg pos_ff;
  reg neg_ff;

  // Positive edge triggered flip-flop
  always @(posedge clk) begin
    pos_ff <= d;
  end

  // Negative edge triggered flip-flop
  always @(negedge clk) begin
    neg_ff <= d;
  end

  // Combinational logic to select output based on clk level
  always @(*) begin
    q = clk ? pos_ff : neg_ff;
  end

endmodule