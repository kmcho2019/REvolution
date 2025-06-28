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
reg [2:0] state, next_state;

// State encoding
parameter walking_left = 3'b000, walking_right = 3'b001, falling = 3'b010, digging_left = 3'b011, digging_right = 3'b100;

// Moore outputs
always @(*) begin
  walk_left = (state == walking_left) ? 1 : 0;
  walk_right = (state == walking_right) ? 1 : 0;
  aaah = (state == falling) ? 1 : 0;
  digging = (state == digging_left || state == digging_right) ? 1 : 0;
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
      if (!ground) begin
        next_state = falling;
      end else if (dig) begin
        next_state = digging_left;
      end else if (bump_right) begin
        next_state = walking_right;
      end else begin
        next_state = walking_left;
      end
    end
    walking_right: begin
      if (!ground) begin
        next_state = falling;
      end else if (dig) begin
        next_state = digging_right;
      end else if (bump_left) begin
        next_state = walking_left;
      end else begin
        next_state = walking_right;
      end
    end
    falling: begin
      if (ground) begin
        if (walk_left) begin
          next_state = walking_left;
        end else begin
          next_state = walking_right;
        end
      end else begin
        next_state = falling;
      end
    end
    digging_left: begin
      if (!ground) begin
        next_state = falling;
      end else if (dig) begin
        next_state = digging_left;
      end else begin
        next_state = walking_left;
      end
    end
    digging_right: begin
      if (!ground) begin
        next_state = falling;
      end else if (dig) begin
        next_state = digging_right;
      end else begin
        next_state = walking_right;
      end
    end
  endcase
end

endmodule