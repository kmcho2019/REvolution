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

// State definition
parameter walking_left = 3'b000, walking_right = 3'b001, falling = 3'b010, digging_left = 3'b011, digging_right = 3'b100, falling_after_digging_left = 3'b101, falling_after_digging_right = 3'b110;
reg [2:0] state, next_state;

// Moore outputs
always @(state) begin
  case(state)
    walking_left: begin
      walk_left = 1;
      walk_right = 0;
      aaah = 0;
      digging = 0;
    end
    walking_right: begin
      walk_left = 0;
      walk_right = 1;
      aaah = 0;
      digging = 0;
    end
    falling, falling_after_digging_left, falling_after_digging_right: begin
      walk_left = 0;
      walk_right = 0;
      aaah = 1;
      digging = 0;
    end
    digging_left, falling_after_digging_left: begin
      walk_left = 1;
      walk_right = 0;
      aaah = 0;
      digging = 1;
    end
    digging_right, falling_after_digging_right: begin
      walk_left = 0;
      walk_right = 1;
      aaah = 0;
      digging = 1;
    end
  endcase
end

// State transitions
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= walking_left;
  end else begin
    state <= next_state;
  end
end

// Next state logic
always @(*) begin
  case(state)
    walking_left: begin
      if (ground) begin
        if (dig) next_state = digging_left;
        else if (bump_left) next_state = walking_right;
        else if (bump_right) next_state = walking_left;
        else next_state = walking_left;
      end else next_state = falling;
    end
    walking_right: begin
      if (ground) begin
        if (dig) next_state = digging_right;
        else if (bump_right) next_state = walking_left;
        else if (bump_left) next_state = walking_right;
        else next_state = walking_right;
      end else next_state = falling;
    end
    falling: begin
      if (ground) begin
        if (bump_left) next_state = walking_right;
        else if (bump_right) next_state = walking_left;
        else if (dig) next_state = digging_left;
        else next_state = walking_left;
      end else next_state = falling;
    end
    digging_left: begin
      if (ground) next_state = walking_left;
      else next_state = falling_after_digging_left;
    end
    digging_right: begin
      if (ground) next_state = walking_right;
      else next_state = falling_after_digging_right;
    end
    falling_after_digging_left: begin
      if (ground) next_state = walking_left;
      else next_state = falling_after_digging_left;
    end
    falling_after_digging_right: begin
      if (ground) next_state = walking_right;
      else next_state = falling_after_digging_right;
    end
  endcase
end

endmodule