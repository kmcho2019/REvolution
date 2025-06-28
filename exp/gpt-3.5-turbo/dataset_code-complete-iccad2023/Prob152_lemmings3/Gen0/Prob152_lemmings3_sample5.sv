module LemmingFSM (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

// State definition
typedef enum logic [2:0] {
  WALKING_LEFT,
  WALKING_RIGHT,
  FALLING,
  DIGGING
} State;

// State and output registers
reg [2:0] state, next_state;

// Moore state machine
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALKING_LEFT;
  end else begin
    state <= next_state;
  end
end

// State transitions and output logic
always @* begin
  case (state)
    WALKING_LEFT: begin
      walk_left = 1;
      walk_right = 0;
      aaah = 0;
      digging = 0;
      
      if (bump_left) begin
        next_state = WALKING_RIGHT;
      end else if (ground == 0) begin
        next_state = FALLING;
      end else if (dig && ground) begin
        next_state = DIGGING;
      end
    end
    
    WALKING_RIGHT: begin
      walk_left = 0;
      walk_right = 1;
      aaah = 0;
      digging = 0;
      
      if (bump_right) begin
        next_state = WALKING_LEFT;
      end else if (ground == 0) begin
        next_state = FALLING;
      end else if (dig && ground) begin
        next_state = DIGGING;
      end
    end
    
    FALLING: begin
      walk_left = (state == WALKING_LEFT);
      walk_right = (state == WALKING_RIGHT);
      aaah = 1;
      digging = 0;
      
      if (ground) begin
        next_state = walk_left ? WALKING_LEFT : WALKING_RIGHT;
      end
    end
    
    DIGGING: begin
      walk_left = 0;
      walk_right = 0;
      aaah = 0;
      digging = 1;
      
      if (!ground) begin
        next_state = FALLING;
      end else if (!dig || !ground) begin
        next_state = walk_left ? WALKING_LEFT : WALKING_RIGHT;
      end
    end
  endcase
end

endmodule