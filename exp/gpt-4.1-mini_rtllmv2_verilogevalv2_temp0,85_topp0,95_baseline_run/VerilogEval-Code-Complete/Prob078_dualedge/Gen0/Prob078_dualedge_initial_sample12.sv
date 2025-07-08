module TopModule (
  input clk,
  input d,
  output reg q
);

  wire clk_bar = ~clk;

  reg pos_d;
  reg neg_d;

  // Sample input d on positive edge of clk
  always @(posedge clk) begin
    pos_d <= d;
    q <= pos_d;
  end

  // Sample input d on negative edge of clk (using inverted clock)
  always @(posedge clk_bar) begin
    neg_d <= d;
    q <= neg_d;
  end

endmodule