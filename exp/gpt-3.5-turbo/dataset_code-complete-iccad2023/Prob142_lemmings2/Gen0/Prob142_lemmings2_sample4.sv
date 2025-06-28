module LemmingStateMachine (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  output reg walk_left,
  output reg walk_right,
  output reg aaah
);

// State definitions
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;

reg [1:0] state, next_state;

always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end else begin
    state <= next_state;
  end
end

always @ (*) begin
  aaah = 1'b0;
  walk_left = (state == WALK_LEFT);
  walk_right = (state == WALK_RIGHT);

  case(state)
    WALK_LEFT: begin
      if (bump_right) begin
        next_state = WALK_RIGHT;
      end else if (!ground) begin
        next_state = FALLING;
        aaah = 1'b1;
      end else begin
        next_state = WALK_LEFT;
      end
    end

    WALK_RIGHT: begin
      if (bump_left) begin
        next_state = WALK_LEFT;
      end else if (!ground) begin
        next_state = FALLING;
        aaah = 1'b1;
      end else begin
        next_state = WALK_RIGHT;
      end
    end

    FALLING: begin
      if (ground) begin
        if (state == WALK_LEFT) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end else begin
        next_state = FALLING;
      end
    end
  endcase
end

endmodule