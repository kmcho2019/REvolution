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
  reg walk_dir; // 0 = left, 1 = right, remembers direction before falling

  // State register with async posedge reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_dir <= 1'b0; // left
    end else begin
      state <= next_state;
      // walk_dir updated only when walking states
      if (ground) begin
        if (next_state == WALK_LEFT)
          walk_dir <= 1'b0;
        else if (next_state == WALK_RIGHT)
          walk_dir <= 1'b1;
      end
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      WALK_LEFT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // Switch direction if bumped on either side or both
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      FALLING: begin
        if (ground) begin
          // Return to previous walking direction when ground returns
          if (walk_dir == 1'b0)
            next_state = WALK_LEFT;
          else
            next_state = WALK_RIGHT;
        end else begin
          next_state = FALLING;
        end
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore): outputs depend on state
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule