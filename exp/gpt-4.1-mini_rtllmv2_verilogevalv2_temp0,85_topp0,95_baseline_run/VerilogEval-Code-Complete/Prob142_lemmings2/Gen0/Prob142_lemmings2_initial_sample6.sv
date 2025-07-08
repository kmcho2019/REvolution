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
  localparam WALK_LEFT  = 2'b00;
  localparam WALK_RIGHT = 2'b01;
  localparam FALLING    = 2'b10;

  reg [1:0] state, next_state;
  reg prev_dir; // 0 = left, 1 = right - remembers direction before falling

  // Asynchronous reset and state register
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      prev_dir <= 1'b0; // direction left
    end else begin
      state <= next_state;
      // Update prev_dir when walking states change
      if (next_state == WALK_LEFT)
        prev_dir <= 1'b0;
      else if (next_state == WALK_RIGHT)
        prev_dir <= 1'b1;
      // Do not update prev_dir in FALLING state
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      WALK_LEFT: begin
        if (ground == 1'b0) begin
          // Start falling, remember direction
          next_state = FALLING;
        end else if ((bump_left | bump_right) == 1'b1) begin
          // Bumped, switch direction
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (ground == 1'b0) begin
          next_state = FALLING;
        end else if ((bump_left | bump_right) == 1'b1) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      FALLING: begin
        if (ground == 1'b1) begin
          // Recover to previous walking direction
          next_state = (prev_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
        end else begin
          next_state = FALLING;
        end
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic - Moore outputs depend only on state
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule