module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

reg state;

// Next state logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= 0; // Initialize state to LEFT (0)
  end else begin
    case ({bump_left, bump_right})
      2'b00: state <= state; // No change
      2'b01: state <= 1; // RIGHT state
      2'b10: state <= 1; // RIGHT state
      2'b11: state <= ~state; // Switch direction
    endcase
  end
end

// Output logic
assign walk_left = ~state; // LEFT state
assign walk_right = state; // RIGHT state

endmodule