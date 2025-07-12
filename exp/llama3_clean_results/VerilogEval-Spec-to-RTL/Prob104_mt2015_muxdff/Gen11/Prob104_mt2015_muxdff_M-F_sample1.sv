module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  always @(posedge clk) begin
    if (L) begin
      Q <= r_in; // Load r_in into Q when L is high
    end else begin
      Q <= q_in; // Update Q with q_in when L is low, reflecting the dependency between flip-flops
    end
  end

endmodule