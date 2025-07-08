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
  localparam FALL_LEFT  = 2'b10; // Falling, previously walking left
  localparam FALL_RIGHT = 2'b11; // Falling, previously walking right

  reg [1:0] state, next_state;

  // State register with asynchronous positive edge reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      WALK_LEFT: begin
        if (!ground) begin
          // Start falling, remember direction left
          next_state = FALL_LEFT;
        end else if (bump_left || bump_right) begin
          // Switch direction to walk right on any bump
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          // Start falling, remember direction right
          next_state = FALL_RIGHT;
        end else if (bump_left || bump_right) begin
          // Switch direction to walk left on any bump
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      FALL_LEFT: begin
        if (ground) begin
          // Ground reappeared, resume walking left
          next_state = WALK_LEFT;
        end else begin
          // Keep falling
          next_state = FALL_LEFT;
        end
      end

      FALL_RIGHT: begin
        if (ground) begin
          // Ground reappeared, resume walking right
          next_state = WALK_RIGHT;
        end else begin
          // Keep falling
          next_state = FALL_RIGHT;
        end
      end

      default: next_state = WALK_LEFT; // Default safe state
    endcase
  end

  // Output logic (Moore outputs depend on state only)
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule