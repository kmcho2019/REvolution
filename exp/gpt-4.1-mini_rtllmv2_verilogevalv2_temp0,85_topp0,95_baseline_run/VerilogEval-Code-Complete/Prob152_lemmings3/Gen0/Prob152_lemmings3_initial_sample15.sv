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
    WALK_LEFT   = 3'b000,
    WALK_RIGHT  = 3'b001,
    FALL_LEFT   = 3'b010,
    FALL_RIGHT  = 3'b011,
    DIG_LEFT    = 3'b100,
    DIG_RIGHT   = 3'b101
  } state_t;
  
  state_t state, next_state;
  
  // Synchronous state update with asynchronous positive-edge reset
  always_ff @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else
      state <= next_state;
  end
  
  // Next state logic
  always_comb begin
    // Default next state is current state
    next_state = state;
    
    // Extract current direction from state
    // walking or digging left states: WALK_LEFT or DIG_LEFT
    // walking or digging right states: WALK_RIGHT or DIG_RIGHT
    // falling left or right: FALL_LEFT or FALL_RIGHT
    logic walking_left = (state == WALK_LEFT);
    logic walking_right = (state == WALK_RIGHT);
    logic falling_left = (state == FALL_LEFT);
    logic falling_right = (state == FALL_RIGHT);
    logic digging_left = (state == DIG_LEFT);
    logic digging_right = (state == DIG_RIGHT);
    
    // Priority of conditions:
    // 1. If ground=0 and not already falling => start falling
    // 2. If walking on ground and dig=1 => start digging
    // 3. If bumped (left or right) while walking => switch direction
    // 4. Falling continues until ground=1 => walk again in original direction
    // 5. Digging continues until ground=0 => start falling
    
    if (falling_left || falling_right) begin
      // While falling: bump and dig ignored
      if (ground == 1) begin
        // Ground reappeared: resume walking in previous direction
        if (falling_left)
          next_state = WALK_LEFT;
        else
          next_state = WALK_RIGHT;
      end else begin
        // keep falling
        next_state = state;
      end
    end else if (digging_left || digging_right) begin
      // While digging: bump ignored
      if (ground == 0) begin
        // No ground => start falling with same direction
        if (digging_left)
          next_state = FALL_LEFT;
        else
          next_state = FALL_RIGHT;
      end else begin
        // continue digging
        next_state = state;
      end
    end else if (walking_left || walking_right) begin
      // Walking states
      
      if (ground == 0) begin
        // Start falling, ignoring bump and dig
        if (walking_left)
          next_state = FALL_LEFT;
        else
          next_state = FALL_RIGHT;
      end else if (dig == 1) begin
        // Start digging
        if (walking_left)
          next_state = DIG_LEFT;
        else
          next_state = DIG_RIGHT;
      end else begin
        // Check bump to switch direction
        // bump on left => walk right
        // bump on right => walk left
        // bump on both => switch direction anyway
        
        if (bump_left || bump_right) begin
          // Switch direction
          if (walking_left)
            next_state = WALK_RIGHT;
          else
            next_state = WALK_LEFT;
        end else begin
          // continue walking same direction
          next_state = state;
        end
      end
    end else begin
      // Should not occur, but keep current state
      next_state = state;
    end
  end
  
  // Output logic - Moore machine, outputs depend only on state
  assign walk_left  = (state == WALK_LEFT) || (state == DIG_LEFT);
  assign walk_right = (state == WALK_RIGHT) || (state == DIG_RIGHT);
  assign aaah       = (state == FALL_LEFT) || (state == FALL_RIGHT);
  assign digging    = (state == DIG_LEFT) || (state == DIG_RIGHT);
  
endmodule