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
  localparam WALK_LEFT  = 3'd0;
  localparam WALK_RIGHT = 3'd1;
  localparam DIG_LEFT   = 3'd2;
  localparam DIG_RIGHT  = 3'd3;
  localparam FALL_LEFT  = 3'd4;
  localparam FALL_RIGHT = 3'd5;
  localparam SPLAT      = 3'd6;

  reg [2:0] state, next_state;
  reg [5:0] fall_count; // to count fall cycles (need at least 6 bits for >20)

  // State register with asynchronous positive edge reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 0;
    end else begin
      state <= next_state;
      if (state == FALL_LEFT || state == FALL_RIGHT) begin
        fall_count <= fall_count + 1;
      end else begin
        fall_count <= 0;
      end
    end
  end

  // Next state logic (Moore FSM)
  always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
      SPLAT: begin
        // Once splattered, stay splattered forever until reset
        next_state = SPLAT;
      end

      WALK_LEFT: begin
        if (!ground) begin
          // ground gone: fall left, reset fall count handled in sequential logic
          next_state = FALL_LEFT;
        end else if (dig) begin
          // start digging if dig=1 and ground=1
          next_state = DIG_LEFT;
        end else if (bump_left || bump_right) begin
          // switch direction if bumped (either side)
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end else if (dig) begin
          next_state = DIG_RIGHT;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      DIG_LEFT: begin
        // While digging
        if (!ground) begin
          // no ground: start falling left
          next_state = FALL_LEFT;
        end else begin
          // ignore bumps and dig during digging, keep digging
          next_state = DIG_LEFT;
        end
      end

      DIG_RIGHT: begin
        if (!ground) begin
          next_state = FALL_RIGHT;
        end else begin
          next_state = DIG_RIGHT;
        end
      end

      FALL_LEFT: begin
        if (ground) begin
          // Ground hit, check fall_count: splat if >20 else walk left
          if (fall_count > 6'd20) begin
            next_state = SPLAT;
          end else begin
            next_state = WALK_LEFT;
          end
        end else begin
          // keep falling
          next_state = FALL_LEFT;
        end
      end

      FALL_RIGHT: begin
        if (ground) begin
          if (fall_count > 6'd20) begin
            next_state = SPLAT;
          end else begin
            next_state = WALK_RIGHT;
          end
        end else begin
          next_state = FALL_RIGHT;
        end
      end

      default: begin
        // Should never happen, default to walk left
        next_state = WALK_LEFT;
      end
    endcase
  end

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);

endmodule