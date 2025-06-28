module TopModule (
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

// Define states for the finite state machine
typedef enum logic [2:0] {
  WALK_LEFT,
  WALK_RIGHT,
  FALL,
  DIG
} state_t;

// Internal states and signals
reg [2:0] state;
reg [4:0] fall_counter;

always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
    fall_counter <= 0;
  end else begin
    case(state)
      WALK_LEFT:
        if (bump_right)
          state <= WALK_RIGHT;
        else if (!ground && fall_counter < 20)
          state <= FALL;
        else if (dig && ground)
          state <= DIG;
      WALK_RIGHT:
        if (bump_left)
          state <= WALK_LEFT;
        else if (!ground && fall_counter < 20)
          state <= FALL;
        else if (dig && ground)
          state <= DIG;
      FALL:
        if (ground)
          state <= (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
        else if (fall_counter >= 20)
          state <= WALK_LEFT; // Splatter
      DIG:
        if (ground)
          state <= (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
    endcase
    fall_counter <= (state == FALL && !ground) ? fall_counter + 1 : 0;
  end
end

// Output logic based on current state
always @* begin
  case(state)
    WALK_LEFT:
      begin
        walk_left = 1;
        walk_right = 0;
        aaah = 0;
        digging = 0;
      end
    WALK_RIGHT:
      begin
        walk_left = 0;
        walk_right = 1;
        aaah = 0;
        digging = 0;
      end
    FALL:
      begin
        walk_left = 0;
        walk_right = 0;
        aaah = 1;
        digging = 0;
      end
    DIG:
      begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 1;
      end
  endcase
end
    
endmodule