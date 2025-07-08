module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

  // State encoding
  localparam WALK_LEFT    = 3'd0;
  localparam WALK_RIGHT   = 3'd1;
  localparam FALLING_LEFT = 3'd2;
  localparam FALLING_RIGHT= 3'd3;
  localparam DIGGING_LEFT = 3'd4;
  localparam DIGGING_RIGHT= 3'd5;
  localparam SPLATTERED   = 3'd6;

  reg [2:0] state, next_state;

  // Fall counter: counts how many clocks fallen
  // max needed: >20, so at least 5 bits
  reg [5:0] fall_counter, next_fall_counter;

  wire bumped = bump_left | bump_right;
  wire bumped_both = bump_left & bump_right;

  // State register with async posedge reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_counter <= 0;
    end else begin
      state <= next_state;
      fall_counter <= next_fall_counter;
    end
  end

  // Next state logic and fall counter update
  always @(*) begin
    // Default next state and fall counter to current
    next_state = state;
    next_fall_counter = fall_counter;

    case(state)
      WALK_LEFT: begin
        // Priority: fall > dig > bump
        if (ground == 0) begin
          next_state = FALLING_LEFT;
          next_fall_counter = 1; // start counting fall
        end else if (dig == 1) begin
          next_state = DIGGING_LEFT;
          next_fall_counter = 0;
        end else if (bumped) begin
          // bump on either side switches direction
          next_state = WALK_RIGHT;
          next_fall_counter = 0;
        end else begin
          next_state = WALK_LEFT;
          next_fall_counter = 0;
        end
      end

      WALK_RIGHT: begin
        if (ground == 0) begin
          next_state = FALLING_RIGHT;
          next_fall_counter = 1;
        end else if (dig == 1) begin
          next_state = DIGGING_RIGHT;
          next_fall_counter = 0;
        end else if (bumped) begin
          next_state = WALK_LEFT;
          next_fall_counter = 0;
        end else begin
          next_state = WALK_RIGHT;
          next_fall_counter = 0;
        end
      end

      DIGGING_LEFT: begin
        if (ground == 0) begin
          // start falling, keep direction left
          next_state = FALLING_LEFT;
          next_fall_counter = 1;
        end else begin
          // remain digging left
          next_state = DIGGING_LEFT;
          next_fall_counter = 0;
          // bumps ignored while digging
        end
      end

      DIGGING_RIGHT: begin
        if (ground == 0) begin
          next_state = FALLING_RIGHT;
          next_fall_counter = 1;
        end else begin
          next_state = DIGGING_RIGHT;
          next_fall_counter = 0;
        end
      end

      FALLING_LEFT: begin
        if (ground == 0) begin
          // continue falling, increment counter
          next_state = FALLING_LEFT;
          // avoid overflow by saturating at max 63
          if (fall_counter < 6'd63)
            next_fall_counter = fall_counter + 1;
          else
            next_fall_counter = fall_counter;
        end else begin
          // ground appeared, check splatter
          if (fall_counter > 20) begin
            next_state = SPLATTERED;
            next_fall_counter = 0;
          end else begin
            next_state = WALK_LEFT;
            next_fall_counter = 0;
          end
        end
      end

      FALLING_RIGHT: begin
        if (ground == 0) begin
          next_state = FALLING_RIGHT;
          if (fall_counter < 6'd63)
            next_fall_counter = fall_counter + 1;
          else
            next_fall_counter = fall_counter;
        end else begin
          if (fall_counter > 20) begin
            next_state = SPLATTERED;
            next_fall_counter = 0;
          end else begin
            next_state = WALK_RIGHT;
            next_fall_counter = 0;
          end
        end
      end

      SPLATTERED: begin
        // no recovery, stay splattered, outputs zero
        next_state = SPLATTERED;
        next_fall_counter = 0;
      end

      default: begin
        // should never happen, but safe reset
        next_state = WALK_LEFT;
        next_fall_counter = 0;
      end
    endcase
  end

  // Moore outputs based on state only
  always @(*) begin
    // defaults
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case(state)
      WALK_LEFT: begin
        walk_left = 1;
      end
      WALK_RIGHT: begin
        walk_right = 1;
      end
      DIGGING_LEFT: begin
        walk_left = 1;
        digging = 1;
      end
      DIGGING_RIGHT: begin
        walk_right = 1;
        digging = 1;
      end
      FALLING_LEFT: begin
        aaah = 1;
      end
      FALLING_RIGHT: begin
        aaah = 1;
      end
      SPLATTERED: begin
        // all zero
      end
      default: begin
        // all zero
      end
    endcase
  end

endmodule