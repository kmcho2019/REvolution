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
  localparam WALK_LEFT  = 2'b00;
  localparam WALK_RIGHT = 2'b01;
  localparam FALLING    = 2'b10;
  localparam DIGGING    = 2'b11;

  reg [1:0] state, next_state;
  reg walk_dir; // 0: left, 1: right (used to remember direction before fall or dig)

  // State register with asynchronous positive-edge reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_dir <= 1'b0; // left
    end else begin
      state <= next_state;

      // Update walk_dir only when in walking states or dig
      if ((next_state == WALK_LEFT) || (next_state == WALK_RIGHT) || (next_state == DIGGING)) begin
        if (next_state == WALK_LEFT || (state == WALK_LEFT && next_state == DIGGING))
          walk_dir <= 1'b0;
        else if (next_state == WALK_RIGHT || (state == WALK_RIGHT && next_state == DIGGING))
          walk_dir <= 1'b1;
        // For DIGGING, keep walk_dir unchanged (already set)
      end
    end
  end

  // Next state logic
  always @(*) begin
    // Default to current state
    next_state = state;

    case (state)
      WALK_LEFT: begin
        // Check fall first
        if (ground == 1'b0) begin
          next_state = FALLING;
        end else if (dig == 1'b1) begin
          // Only start digging if on ground and not falling (true here)
          next_state = DIGGING;
        end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
          // Switch direction if bumped
          // Since current walking left, bump_left or bump_right causes switch to walk right
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end

      WALK_RIGHT: begin
        if (ground == 1'b0) begin
          next_state = FALLING;
        end else if (dig == 1'b1) begin
          next_state = DIGGING;
        end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
          // Switch direction if bumped
          // Since current walking right, bump causes switch to walk left
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end

      DIGGING: begin
        // Being bumped or dig command ignored while digging
        if (ground == 1'b0) begin
          next_state = FALLING;
        end else begin
          next_state = DIGGING;
        end
      end

      FALLING: begin
        // When ground reappears, resume walking in stored walk_dir
        if (ground == 1'b1) begin
          if (walk_dir == 1'b0)
            next_state = WALK_LEFT;
          else
            next_state = WALK_RIGHT;
        end else begin
          next_state = FALLING;
        end
      end

      default: next_state = WALK_LEFT; // default safety
    endcase
  end

  // Outputs: Moore outputs depend only on state
  assign walk_left  = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah       = (state == FALLING);
  assign digging   = (state == DIGGING);

endmodule