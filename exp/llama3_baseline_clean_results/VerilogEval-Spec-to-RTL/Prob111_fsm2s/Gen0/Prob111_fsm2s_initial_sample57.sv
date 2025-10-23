module TopModule (
  input  clk,
  input  reset,
  input  j,
  input  k,
  output reg out
);

reg state;  // 0: OFF, 1: ON

always @(posedge clk) begin
  if (reset) begin
    state <= 0;  // Reset to OFF state
  end else begin
    case (state)
      0: begin  // OFF state
        if (j) begin
          state <= 1;  // Transition to ON state
        end else begin
          state <= 0;  // Stay in OFF state
        end
      end
      1: begin  // ON state
        if (k) begin
          state <= 0;  // Transition to OFF state
        end else begin
          state <= 1;  // Stay in ON state
        end
      end
    endcase
  end
end

always @(state) begin
  case (state)
    0: out <= 0;  // Output 0 in OFF state
    1: out <= 1;  // Output 1 in ON state
  endcase
end

endmodule