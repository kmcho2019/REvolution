module LemmingStateMachine (
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

  enum logic [3:0] state = {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING};
  reg [4:0] fall_count;

  // State register
  reg [3:0] current_state, next_state;
  
  // Output register
  reg walk_left_reg, walk_right_reg, aaah_reg, digging_reg;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= WALK_LEFT;
      fall_count <= 0;
    end 
    else begin
      current_state <= next_state;
    end
  end

  always @(*) begin
    walk_left_reg = (current_state == WALK_LEFT);
    walk_right_reg = (current_state == WALK_RIGHT);
    aaah_reg = (current_state == FALLING && fall_count > 20);
    digging_reg = (current_state == DIGGING);
  end

  always @(*) begin
    case (current_state)
      WALK_LEFT: begin
        if (bump_left) begin
          next_state = WALK_RIGHT;
        end
        else if (!ground) begin
          next_state = FALLING;
        end
        else if (dig) begin
          next_state = DIGGING;
        end
        else begin
          next_state = WALK_LEFT;
        end
      end
      WALK_RIGHT: begin
        if (bump_right) begin
          next_state = WALK_LEFT;
        end
        else if (!ground) begin
          next_state = FALLING;
        end
        else if (dig) begin
          next_state = DIGGING;
        end
        else begin
          next_state = WALK_RIGHT;
        end
      end
      FALLING: begin
        if (ground) begin
          next_state = walk_left_reg ? WALK_LEFT : WALK_RIGHT;
        end
        else begin
          next_state = FALLING;
        end
      end
      DIGGING: begin
        if (!ground) begin
          next_state = FALLING;
        end
        else if (!dig) begin
          next_state = walk_left_reg ? WALK_LEFT : WALK_RIGHT;
        end
        else begin
          next_state = DIGGING;
        end
      end
      default: begin
        next_state = WALK_LEFT;
      end
    endcase
  end

  always @(posedge clk) begin
    if (current_state == FALLING && fall_count <= 20) begin
      fall_count <= fall_count + 1;
    end
    else begin
      fall_count <= 0;
    end
  end
  
  assign walk_left = walk_left_reg;
  assign walk_right = walk_right_reg;
  assign aaah = aaah_reg;
  assign digging = digging_reg;

endmodule