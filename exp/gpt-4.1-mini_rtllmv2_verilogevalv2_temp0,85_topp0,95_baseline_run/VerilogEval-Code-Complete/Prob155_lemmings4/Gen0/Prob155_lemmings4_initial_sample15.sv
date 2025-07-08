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
  localparam FALL_LEFT  = 3'd2;
  localparam FALL_RIGHT = 3'd3;
  localparam DIG_LEFT   = 3'd4;
  localparam DIG_RIGHT  = 3'd5;
  localparam SPLAT      = 3'd6;

  reg [2:0] state, next_state;
  reg [4:0] fall_count; // counts how long falling, max 31>20 enough

  // State register with asynchronous positive edge reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 5'd0;
    end else begin
      state <= next_state;

      // Manage fall_count only while falling
      if (state == FALL_LEFT || state == FALL_RIGHT) begin
        if (ground) begin
          // ground hit resets fall_count on landing
          fall_count <= 5'd0;
        end else begin
          // increment count while falling in air
          fall_count <= fall_count + 5'd1;
        end
      end else begin
        // not falling, reset fall_count
        fall_count <= 5'd0;
      end
    end
  end

  // Next state logic
  always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
      // Walking states
      WALK_LEFT: begin
        if (!ground) begin
          // start falling, direction left
          next_state = FALL_LEFT;
        end else if (dig) begin
          // start digging if on ground
          next_state = DIG_LEFT;
        end else if (bump_left || bump_right) begin
          // switch direction if bumped
          // bump_left or bump_right => walk right
          next_state = WALK_RIGHT;
        end
        // else remain walking left
      end

      WALK_RIGHT: begin
        if (!ground) begin
          // start falling, direction right
          next_state = FALL_RIGHT;
        end else if (dig) begin
          // start digging if on ground
          next_state = DIG_RIGHT;
        end else if (bump_left || bump_right) begin
          // bump => walk left
          next_state = WALK_LEFT;
        end
        // else remain walking right
      end

      // Falling states
      FALL_LEFT: begin
        if (ground) begin
          // On landing, if fall_count > 20 splatter
          if (fall_count > 5'd20)
            next_state = SPLAT;
          else
            next_state = WALK_LEFT;
        end
        // else remain falling left
      end

      FALL_RIGHT: begin
        if (ground) begin
          if (fall_count > 5'd20)
            next_state = SPLAT;
          else
            next_state = WALK_RIGHT;
        end
        // else remain falling right
      end

      // Digging states
      DIG_LEFT: begin
        if (!ground) begin
          // no ground, start falling left
          next_state = FALL_LEFT;
        end
        // else remain digging left
      end

      DIG_RIGHT: begin
        if (!ground) begin
          // no ground, start falling right
          next_state = FALL_RIGHT;
        end
        // else remain digging right
      end

      SPLAT: begin
        // forever splattered
        next_state = SPLAT;
      end

      default: begin
        next_state = WALK_LEFT;
      end
    endcase
  end

  // Output logic (Moore outputs)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT)  || (state == DIG_RIGHT);

endmodule