module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output walk_left,
  output walk_right,
  output aaah
);
  // State encoding
  typedef enum logic [1:0] {
    WALK_LEFT  = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING    = 2'b10
  } state_t;

  state_t state, next_state;

  // Remember direction before falling: 0 = left, 1 = right
  logic remembered_dir;

  // Asynchronous reset and state register
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      remembered_dir <= 1'b0; // left
    end else begin
      state <= next_state;
      // Update remembered_dir only when entering FALLING from walking
      if ((state == WALK_LEFT || state == WALK_RIGHT) && ground == 1) begin
        if (ground == 1 && next_state == FALLING) begin
          remembered_dir <= (state == WALK_RIGHT) ? 1'b1 : 1'b0;
        end
      end
    end
  end

  // Next state logic (combinational)
  always_comb begin
    next_state = state;
    case (state)
      WALK_LEFT: begin
        if (ground == 0) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // Bumped on left or right switches direction
          next_state = WALK_RIGHT;
        end
      end
      WALK_RIGHT: begin
        if (ground == 0) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // Bumped on left or right switches direction
          next_state = WALK_LEFT;
        end
      end
      FALLING: begin
        if (ground == 1) begin
          // Return to walking state in remembered direction
          next_state = (remembered_dir) ? WALK_RIGHT : WALK_LEFT;
        end else begin
          next_state = FALLING;
        end
      end
      default: next_state = WALK_LEFT;
    endcase
  end

  // Outputs depend only on state (Moore)
  assign aaah = (state == FALLING);

  assign walk_left = (state == WALK_LEFT) || (state == FALLING && remembered_dir == 1'b0);
  assign walk_right = (state == WALK_RIGHT) || (state == FALLING && remembered_dir == 1'b1);

endmodule