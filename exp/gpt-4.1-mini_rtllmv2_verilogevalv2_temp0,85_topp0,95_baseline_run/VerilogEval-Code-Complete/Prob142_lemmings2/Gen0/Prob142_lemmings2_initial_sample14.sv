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
  reg last_walk_dir; // 0 = left, 1 = right; to remember before falling

  // State register with asynchronous positive-edge reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      last_walk_dir <= 1'b0; // left
    end else begin
      state <= next_state;
      // Update last_walk_dir only when walking (not falling)
      if (next_state == WALK_LEFT)
        last_walk_dir <= 1'b0;
      else if (next_state == WALK_RIGHT)
        last_walk_dir <= 1'b1;
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      WALK_LEFT: begin
        if (!ground) begin
          // Ground gone, start falling
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          // switch direction if bumped
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
          // return to last walking direction
          next_state = last_walk_dir ? WALK_RIGHT : WALK_LEFT;
        end else begin
          next_state = FALLING;
        end
      end

      default: next_state = WALK_LEFT; // safe default
    endcase
  end

  // Output logic (Moore)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);

endmodule