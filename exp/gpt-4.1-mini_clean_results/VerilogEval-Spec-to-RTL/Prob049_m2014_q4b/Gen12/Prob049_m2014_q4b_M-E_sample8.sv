module TopModule(input clk, input ar, input d, output reg q);
  wire latch_q;

  // Asynchronous reset latch
  reg latch_d;
  always @(*) begin
    if (ar)
      latch_d = 1'b0;
    else
      latch_d = d;
  end

  // Transparent latch with asynchronous reset behavior
  reg latch_q_reg;
  always @(ar or latch_d) begin
    if (ar)
      latch_q_reg <= 1'b0;
    else
      latch_q_reg <= latch_d;
  end
  assign latch_q = latch_q_reg;

  // Positive-edge triggered flip-flop capturing latch output
  always @(posedge clk) begin
    q <= latch_q;
  end
endmodule