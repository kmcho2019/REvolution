module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output walk_left,
  output walk_right,
  output aaah,
  output digging
);

  // State encoding
  typedef enum logic [1:0] {
    WALK_LEFT  = 2'b00,
    WALK_RIGHT = 2'b01,
    FALLING    = 2'b10,
    DIGGING    = 2'b11
  } state_t;

  state_t state, next_state;

  // Track walking direction for FALLING and DIGGING (0 = left, 1 = right)
  logic direction; // 0 = left, 1 = right
  logic direction_next;

  // Asynchronous reset and state update
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      direction <= 1'b0; // left
    end else begin
      state <= next_state;
      direction <= direction_next;
    end
  end

  // Next state logic
  always_comb begin
    // Default next state and direction
    next_state = state;
    direction_next = direction;

    case (state)
      WALK_LEFT, WALK_RIGHT: begin
        // walking states, on ground and not falling
        // precedence: fall > dig > bump

        if (!ground) begin
          // ground disappeared, fall
          next_state = FALLING;
          // direction unchanged
          direction_next = direction;
        end else if (dig) begin
          // start digging if dig=1 and on ground
          next_state = DIGGING;
          direction_next = direction;
        end else begin
          // no fall or dig, check bumps
          if (bump_left && bump_right) begin
            // both bumps, switch direction
            next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
            direction_next = ~direction;
          end else if (bump_left) begin
            // bumped left, walk right
            next_state = WALK_RIGHT;
            direction_next = 1'b1;
          end else if (bump_right) begin
            // bumped right, walk left
            next_state = WALK_LEFT;
            direction_next = 1'b0;
          end else begin
            // no bumps, stay same
            next_state = state;
            direction_next = direction;
          end
        end
      end

      FALLING: begin
        // falling state
        // if ground reappears, resume walking in previous direction
        if (ground) begin
          // resume walking in previous direction
          next_state = (direction == 1'b0) ? WALK_LEFT : WALK_RIGHT;
          direction_next = direction;
        end else begin
          // continue falling
          next_state = FALLING;
          direction_next = direction;
        end
      end

      DIGGING: begin
        // digging state
        // if ground disappears, start falling
        if (!ground) begin
          next_state = FALLING;
          direction_next = direction;
        end else begin
          // continue digging, ignore bumps and dig input
          next_state = DIGGING;
          direction_next = direction;
        end
      end

      default: begin
        next_state = WALK_LEFT;
        direction_next = 1'b0;
      end
    endcase
  end

  // Outputs: Moore machine, depend only on state
  assign walk_left  = (state == WALK_LEFT) || (state == DIGGING && direction == 1'b0);
  assign walk_right = (state == WALK_RIGHT) || (state == DIGGING && direction == 1'b1);
  assign aaah       = (state == FALLING);
  assign digging    = (state == DIGGING);

endmodule