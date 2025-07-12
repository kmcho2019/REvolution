module TopModule(
  input clk,
  input areset,
  input in,
  output reg out
);

reg state; // 1-bit state register

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 1'b1; // Reset to state B
  end else begin
    case(state)
      1'b0: state <= (in) ? 1'b0 : 1'b1; // State A
      1'b1: state <= (in) ? 1'b1 : 1'b0; // State B
    endcase
  end
end

always @(*) begin
  case(state)
    1'b0: out <= 1'b0; // State A output
    1'b1: out <= 1'b1; // State B output
  endcase
end

endmodule