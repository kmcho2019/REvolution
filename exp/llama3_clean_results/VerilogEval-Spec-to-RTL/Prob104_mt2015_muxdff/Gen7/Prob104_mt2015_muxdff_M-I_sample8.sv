module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg Q_prev; // To hold the previous state of Q
  always @(posedge clk) begin
    Q_prev = Q; // Update Q_prev with the current state of Q before it changes
    if (L) begin
      Q <= r_in;
    end else begin
      Q <= q_in ^ Q_prev; // Use Q_prev to avoid using Q in the same clock cycle
    end
  end

endmodule