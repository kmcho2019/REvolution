module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output reg walk_left,
  output reg walk_right,
  output reg aaah
);

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;

// State register
reg [1:0] state, next_state;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end
  else begin
    state <= next_state;
  end
end

// Next state logic
always @* begin
  case(state)
    WALK_LEFT: begin
      if (bump_right && !bump_left) begin
        next_state = WALK_RIGHT;
      end
      else if (ground == 0) begin
        next_state = WALK_LEFT;
      end
      else begin
        next_state = WALK_LEFT;
      end
    end
    WALK_RIGHT: begin
      if (bump_left && !bump_right) begin
        next_state = WALK_LEFT;
      end
      else if (ground == 0) begin
        next_state = WALK_RIGHT;
      end
      else begin
        next_state = WALK_RIGHT;
      end
    end
    default: next_state = WALK_LEFT;
  endcase
end

// Outputs
always @* begin
  case(state)
    WALK_LEFT: begin
      walk_left = 1;
      walk_right = 0;
      aaah = (ground == 0) ? 1'b1 : 1'b0;
    end
    WALK_RIGHT: begin
      walk_left = 0;
      walk_right = 1;
      aaah = (ground == 0) ? 1'b1 : 1'b0;
    end
    default: begin
      walk_left = 1;
      walk_right = 0;
      aaah = 1'b0;
    end
  endcase
end

endmodule