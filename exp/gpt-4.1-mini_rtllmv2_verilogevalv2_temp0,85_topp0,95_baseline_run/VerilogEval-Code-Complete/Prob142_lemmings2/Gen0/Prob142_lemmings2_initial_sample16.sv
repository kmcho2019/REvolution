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
  reg direction; // 0 = left, 1 = right; stores direction while falling

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      direction <= 0;
    end else begin
      state <= next_state;
      // Update direction only in walking states
      if (ground && (state == WALK_LEFT || state == WALK_RIGHT)) begin
        if (bump_left || bump_right) begin
          if (bump_left && bump_right) begin
            direction <= ~direction; // both bumps, flip direction
          end else if (bump_left) begin
            direction <= 1; // walk right
          end else if (bump_right) begin
            direction <= 0; // walk left
          end
        end else begin
          direction <= (state == WALK_RIGHT) ? 1 : 0;
        end
      end
      // Direction doesn't change in falling
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      WALK_LEFT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // switch direction on any bump
          next_state = FALLING ? FALLING : (direction ? WALK_RIGHT : WALK_LEFT);
          next_state = 1 ? WALK_RIGHT : WALK_LEFT; // actually just flip direction
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
          // resume walking in stored direction
          next_state = direction ? WALK_RIGHT : WALK_LEFT;
        end else begin
          next_state = FALLING;
        end
      end

      default: next_state = WALK_LEFT;
    endcase
  end

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule