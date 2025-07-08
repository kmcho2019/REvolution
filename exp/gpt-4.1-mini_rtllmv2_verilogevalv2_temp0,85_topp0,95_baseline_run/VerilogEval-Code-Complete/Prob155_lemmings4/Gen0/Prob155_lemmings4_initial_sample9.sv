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
  typedef enum logic [2:0] {
    WLK_L = 3'b000, // Walking left
    WLK_R = 3'b001, // Walking right
    FALL_L = 3'b010, // Falling (direction left)
    FALL_R = 3'b011, // Falling (direction right)
    DIG_L = 3'b100, // Digging left
    DIG_R = 3'b101, // Digging right
    SPLAT = 3'b110  // Splattered
  } state_t;

  state_t state, next_state;

  // Fall duration counter
  logic [4:0] fall_count; // 5 bits to count to at least 21

  // Output signals derived from state
  assign walk_left  = (state == WLK_L) || (state == DIG_L);
  assign walk_right = (state == WLK_R) || (state == DIG_R);
  assign aaah       = (state == FALL_L) || (state == FALL_R);
  assign digging    = (state == DIG_L) || (state == DIG_R);

  // Direction helper: from state, get direction 0=left,1=right
  function logic direction(state_t st);
    case(st)
      WLK_L, FALL_L, DIG_L: direction = 1'b0;
      WLK_R, FALL_R, DIG_R: direction = 1'b1;
      default: direction = 1'b0; // splat no direction really
    endcase
  endfunction

  // Detect bump - if bumped either side, direction flips if walking
  logic bumped;
  assign bumped = bump_left | bump_right;

  // Sequential logic: state and counter update
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WLK_L;
      fall_count <= 0;
    end else begin
      state <= next_state;
      // Update fall_count only in falling states
      if ((state == FALL_L) || (state == FALL_R)) begin
        // increment count saturating at max 31 (just big enough)
        if (fall_count != 5'd31)
          fall_count <= fall_count + 1;
      end else begin
        fall_count <= 0;
      end
    end
  end

  // Next state combinational logic
  always_comb begin
    next_state = state; // default hold

    // If splattered, no transitions
    if (state == SPLAT) begin
      next_state = SPLAT;
    end else begin
      // Extract current direction as bit
      logic dir = direction(state);

      // Priority: fall > dig > bump direction change (walking only)
      // Detect fall conditions:
      // If currently walking or digging and ground=0, start falling preserving direction
      // If currently falling and ground=0, continue falling
      // If currently falling and ground=1, check fall_count for splatter or resume walk

      case (state)
        WLK_L, WLK_R: begin
          if (ground == 0) begin
            // fall start, direction preserved
            next_state = dir ? FALL_R : FALL_L;
          end else if (dig) begin
            // start digging only if ground=1 and not falling
            next_state = dir ? DIG_R : DIG_L;
          end else if (bumped) begin
            // bump causes direction flip
            if (bump_left && bump_right) begin
              // both sides bump => flip direction
              next_state = dir ? WLK_L : WLK_R;
            end else if (bump_left) begin
              // bump left => walk right
              next_state = WLK_R;
            end else if (bump_right) begin
              // bump right => walk left
              next_state = WLK_L;
            end
          end else begin
            // remain walking same direction
            next_state = state;
          end
        end

        DIG_L, DIG_R: begin
          // While digging
          if (ground == 0) begin
            // fall start, keep direction
            next_state = dir ? FALL_R : FALL_L;
          end else begin
            // keep digging (dig input ignored once digging started)
            next_state = state;
          end
          // bumps ignored while digging
        end

        FALL_L, FALL_R: begin
          if (ground == 0) begin
            // still falling
            next_state = state;
          end else begin
            // ground reappeared: check if splat or resume walking
            if (fall_count > 5'd20) begin
              // splat
              next_state = SPLAT;
            end else begin
              // resume walking same direction
              next_state = dir ? WLK_R : WLK_L;
            end
          end
          // bumps ignored while falling
          // dig ignored while falling
        end

        default: begin
          // covers SPLAT (handled above) or unknown states: hold
          next_state = state;
        end
      endcase
    end
  end

endmodule