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

  // State definitions
  parameter WALK_LEFT = 2'b00;
  parameter WALK_RIGHT = 2'b01;
  parameter FALLING = 2'b10;
  parameter DIGGING = 2'b11;
  parameter SPLATTER = 2'b11; // Special state for splattered Lemming
  
  // State register
  reg [1:0] state, next_state;

  // Counter to track falling cycles
  reg [4:0] fall_counter;

  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT; // Reset to initial state
      next_state <= WALK_LEFT;
      fall_counter <= 0;
    end
    else begin
      state <= next_state;
    end
  end

  // Outputs based on current state
  always @ (*) begin
    walk_left = (state == WALK_LEFT);
    walk_right = (state == WALK_RIGHT);
    aaah = (state == FALLING);
    digging = (state == DIGGING);
  end

  // Next state logic
  always @ (*) begin
    next_state = state;

    case (state)
      WALK_LEFT: begin
        if (bump_right)
          next_state = WALK_RIGHT;
        else if (ground)
          next_state = WALK_LEFT;
        else if (fall_counter == 20)
          next_state = SPLATTER;
        else if (dig && ground)
          next_state = DIGGING;
        else if (!ground)
          next_state = FALLING;
      end

      WALK_RIGHT: begin
        if (bump_left)
          next_state = WALK_LEFT;
        else if (ground)
          next_state = WALK_RIGHT;
        else if (fall_counter == 20)
          next_state = SPLATTER;
        else if (dig && ground)
          next_state = DIGGING;
        else if (!ground)
          next_state = FALLING;
      end

      FALLING: begin
        if (ground)
          next_state = state; // Resume falling state
        else if (fall_counter == 20)
          next_state = SPLATTER;
        else if (dig && ground)
          next_state = DIGGING;
        fall_counter <= fall_counter + 1;
      end

      DIGGING: begin
        if (!ground)
          next_state = FALLING;
        else if (fall_counter == 20)
          next_state = SPLATTER;
      end

      default: begin
        next_state = SPLATTER; // Handling splattering case
      end
    endcase
  end

endmodule