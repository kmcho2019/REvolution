module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

reg state; // 1-bit register to store the current state
always @(posedge clk or posedge areset) begin
  if (areset) begin // Asynchronous reset
    state <= 1; // Reset to state B
  end else begin
    case (state)
      1'b1: state <= in ? 1'b1 : 1'b0; // State B
      1'b0: state <= in ? 1'b0 : 1'b1; // State A
    endcase
  end
end

assign out = state; // Output is the same as the current state

endmodule