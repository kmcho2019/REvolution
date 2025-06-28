module LemmingStateMachine (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left, // Output representing Lemming walking left
  output reg walk_right // Output representing Lemming walking right
);

  // Define states
  parameter walk_left_state = 2'b00;
  parameter walk_right_state = 2'b01;
  reg [1:0] state, next_state;

  // Moore state machine logic
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= walk_left_state; // Reset to walk_left_state on asynchronous reset
    end
    else begin
      state <= next_state; // Update state based on next_state
    end
  end

  // State transition and output logic
  always @* begin
    case (state)
      walk_left_state: begin
        walk_left = 1;
        walk_right = 0;
        if (bump_left) begin
          next_state = walk_right_state;
        end
        else if (bump_right) begin
          next_state = walk_left_state;
        end
        else begin
          next_state = walk_left_state;
        end
      end
      walk_right_state: begin
        walk_left = 0;
        walk_right = 1;
        if (bump_right) begin
          next_state = walk_left_state;
        end
        else if (bump_left) begin
          next_state = walk_right_state;
        end
        else begin
          next_state = walk_right_state;
        end
      end
    endcase
  end

endmodule