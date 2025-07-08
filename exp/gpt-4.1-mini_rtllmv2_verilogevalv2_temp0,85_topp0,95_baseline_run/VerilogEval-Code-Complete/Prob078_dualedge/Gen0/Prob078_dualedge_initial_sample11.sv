module TopModule (
  input clk,
  input d,
  output reg q
);

  reg pos_edge_ff;
  reg neg_edge_ff;

  // Sample d at positive edge of clk
  always @(posedge clk) begin
    pos_edge_ff <= d;
  end

  // Sample d at negative edge of clk
  always @(negedge clk) begin
    neg_edge_ff <= d;
  end

  // Multiplex output based on clk level
  always @(*) begin
    if (clk)
      q = pos_edge_ff;
    else
      q = neg_edge_ff;
  end

endmodule