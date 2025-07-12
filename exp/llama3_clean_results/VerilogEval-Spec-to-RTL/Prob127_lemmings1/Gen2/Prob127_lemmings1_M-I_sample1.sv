module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

// Define the states of the finite state machine
parameter WALK_LEFT = 1'b0, WALK_RIGHT = 1'b1;
reg state; // Current state of the FSM

// Sequential logic block
always @(posedge clk or posedge areset) begin
  if (areset) begin // Asynchronous reset
    state <= WALK_LEFT; // Reset the state to WALK_LEFT
  end else if (bump_left || bump_right) begin // Check for bump conditions
    state <= ~state; // Switch the state (toggle)
  end
end

// Combinational logic block
always @(*) begin
  case (state) // Use the current state to determine the output
    WALK_LEFT: begin
      walk_left = 1'b1; // Set walk_left to 1
      walk_right = 1'b0; // Set walk_right to 0
    end
    WALK_RIGHT: begin
      walk_left = 1'b0; // Set walk_left to 0
      walk_right = 1'b1; // Set walk_right to 1
    end
  endcase
end

endmodule