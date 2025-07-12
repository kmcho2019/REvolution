module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

reg state;
reg next_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 1; // Reset to state B
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  case (state)
    1'b1: begin // State B
      if (in == 1'b0) begin
        next_state = 1'b0; // Transition to state A
      end else begin
        next_state = 1'b1; // Stay in state B
      end
    end
    1'b0: begin // State A
      if (in == 1'b0) begin
        next_state = 1'b1; // Transition to state B
      end else begin
        next_state = 1'b0; // Stay in state A
      end
    end
    default: begin
      next_state = 1'b1; // Default to state B
    end
  endcase
end

assign out = state;

endmodule