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
    WL = 3'b000, // walking left
    WR = 3'b001, // walking right
    FALL_L = 3'b010, // falling, original direction left
    FALL_R = 3'b011, // falling, original direction right
    DIG_L = 3'b100, // digging left
    DIG_R = 3'b101  // digging right
  } state_t;

  state_t state, next_state;

  // Asynchronous reset + synchronous state update
  always_ff @(posedge clk or posedge areset) begin
    if (areset) 
      state <= WL;  // reset to walking left
    else
      state <= next_state;
  end

  // Next state logic
  always_comb begin
    // defaults
    next_state = state;

    case (state)
      WL: begin
        // priority: fall, dig, bump
        if (ground == 0) begin
          next_state = FALL_L;
        end else if (dig) begin
          next_state = DIG_L;
        end else if (bump_left || bump_right) begin
          // bump_left means bump on left, turn right
          // bump_right means bump on right, turn left
          // if bump both or either, switch direction
          next_state = WR;
        end else begin
          next_state = WL;
        end
      end

      WR: begin
        if (ground == 0) begin
          next_state = FALL_R;
        end else if (dig) begin
          next_state = DIG_R;
        end else if (bump_left || bump_right) begin
          // switch direction to left
          next_state = WL;
        end else begin
          next_state = WR;
        end
      end

      FALL_L: begin
        // while falling, ignore bumps and dig
        // when ground reappears, resume walking left
        if (ground == 1) begin
          next_state = WL;
        end else begin
          next_state = FALL_L;
        end
      end

      FALL_R: begin
        if (ground == 1) begin
          next_state = WR;
        end else begin
          next_state = FALL_R;
        end
      end

      DIG_L: begin
        // while digging, ignore bumps and dig commands
        // if ground == 0, start falling left
        if (ground == 0) begin
          next_state = FALL_L;
        end else begin
          next_state = DIG_L;
        end
      end

      DIG_R: begin
        if (ground == 0) begin
          next_state = FALL_R;
        end else begin
          next_state = DIG_R;
        end
      end

      default: next_state = WL;
    endcase
  end

  // Output logic (Moore)
  assign walk_left  = (state == WL) || (state == DIG_L);
  assign walk_right = (state == WR) || (state == DIG_R);
  assign aaah       = (state == FALL_L) || (state == FALL_R);
  assign digging    = (state == DIG_L) || (state == DIG_R);

endmodule