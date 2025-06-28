module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  // Internal signals
  logic [1:0] next_state;

  // Saturating counter logic
  always_comb begin
    if (areset) begin
      next_state <= 2'b01; // Reset to weakly not-taken
    end else begin
      case ({train_valid, train_taken})
        2'b11: next_state = (state == 2'b11) ? 2'b11 : state + 2'b01;  // Increment
        2'b10: next_state = state; // No change
        2'b01: next_state = (state == 2'b00) ? 2'b00 : state - 2'b01; // Decrement
        default: next_state = state; // No change
      endcase
    end
  end

  // Sequential logic to update state on clock edge
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b01; // Reset to weakly not-taken
    end else begin
      state <= next_state;
    end
  end

endmodule