module LemmingsFSM (
  input clk, areset, bump_left, bump_right, ground, dig,
  output reg walk_left, walk_right, aaah, digging
);
  
  // Define states
  typedef enum logic [3:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    DIGGING,
    SPLATTER
  } state_type;
  
  // State and next state
  reg [3:0] state, next_state;
  
  // Number of clock cycles Lemming has been falling
  reg [4:0] falling_count;
  
  // State transitions and outputs
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      falling_count <= 0;
    end
    else begin
      state <= next_state;
      if (state == FALLING && !ground) begin
        falling_count <= falling_count + 1;
      end
      else begin
        falling_count <= 0;
      end
    end
  end
  
  always @* begin
    // Default assignments
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
  
    // State machine logic
    case (state)
      WALK_LEFT: begin
        if (bump_right) next_state = WALK_RIGHT;
        else if (!ground) next_state = FALLING;
        else if (dig) next_state = DIGGING;
      end
      WALK_RIGHT: begin
        if (bump_left) next_state = WALK_LEFT;
        else if (!ground) next_state = FALLING;
        else if (dig) next_state = DIGGING;
      end
      FALLING: begin
        if (ground) next_state = state;
        else if (falling_count >= 20) next_state = SPLATTER;
      end
      DIGGING: begin
        if (!ground) next_state = FALLING;
        else next_state = state;
      end
      SPLATTER: begin
        next_state = SPLATTER; // Once splattered, stay in splatter state
      end
    endcase
  end
  
  // Assign outputs based on current state
  always @* begin
    case (state)
      WALK_LEFT: walk_left = 1;
      WALK_RIGHT: walk_right = 1;
      FALLING: aaah = 1;
      DIGGING: digging = 1;
    endcase
  end
  
endmodule