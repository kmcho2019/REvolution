module LemmingFSM (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

  // Define states
  parameter  STATE_LEFT = 2'b00;
  parameter  STATE_RIGHT = 2'b01;

  // Define registers for state flip-flop
  reg [1:0] state_reg, state_next;

  // Moore state machine logic
  always @ (posedge clk or posedge areset)
  begin
    if (areset) begin
      state_reg <= STATE_LEFT; // Initialize to walking left
    end
    else begin
      state_reg <= state_next; // Update state
    end
  end

  // Next state logic
  always @ (*)
  begin
    case(state_reg)
      STATE_LEFT: begin
        if (bump_left) begin
          state_next = STATE_RIGHT;
        end
        else if (bump_right) begin
          state_next = STATE_LEFT;
        end
        else begin
          state_next = STATE_LEFT;
        end
      end
      STATE_RIGHT: begin
        if (bump_left) begin
          state_next = STATE_RIGHT;
        end
        else if (bump_right) begin
          state_next = STATE_LEFT;
        end
        else begin
          state_next = STATE_RIGHT;
        end
      end
    endcase
  end

  // Output logic
  always @ (*)
  begin
    case(state_reg)
      STATE_LEFT: begin
        walk_left = 1;
        walk_right = 0;
      end
      STATE_RIGHT: begin
        walk_left = 0;
        walk_right = 1;
      end
    endcase
  end

endmodule