module LemmingsStateMachine (
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

  // Define states
  typedef enum logic [3:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTER
  } state_t;

  // Define outputs
  reg walk_left, walk_right, aaah, digging;
  reg [4:0] counter; // Counter to track falling duration
  state_t state, next_state;

  // State transition and output logic
  always@(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      walk_left <= 1;
      walk_right <= 0;
      aaah <= 0;
      digging <= 0;
      counter <= 0;
    end else begin
      state <= next_state;
      case(state)
        WALK_LEFT:
          if (!ground) begin
            next_state = FALLING;
            aaah <= 1;
            walk_left <= 0;
            walk_right <= 0;
            digging <= 0;
          end else if (bump_right) begin
            next_state = WALK_RIGHT;
            walk_left <= 0;
            walk_right <= 1;
          end else if (dig) begin
            next_state = DIGGING;
            walk_left <= 0;
            walk_right <= 0;
            digging <= 1;
          end
        WALK_RIGHT:
          if (!ground) begin
            next_state = FALLING;
            aaah <= 1;
            walk_left <= 0;
            walk_right <= 0;
            digging <= 0;
          end else if (bump_left) begin
            next_state = WALK_LEFT;
            walk_left <= 1;
            walk_right <= 0;
          end else if (dig) begin
            next_state = DIGGING;
            walk_left <= 0;
            walk_right <= 0;
            digging <= 1;
          end
        FALLING:
          next_state = ground ? state_t'(walk_left) : FALLING;
          aaah <= 0;
          if (counter == 20) begin
            next_state = SPLATTER;
            walk_left <= 0;
            walk_right <= 0;
            digging <= 0;
          end
        DIGGING:
          next_state = ground ? FALLING : DIGGING;
          aaah <= 0;
      endcase
    end
  end

  always@(posedge clk) begin
    if (!areset && state != SPLATTER)
      counter <= (state == FALLING) ? counter + 1 : 0;
  end

endmodule