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

  // State encoding
  parameter WALK_LEFT = 2'b00;
  parameter WALK_RIGHT = 2'b01;
  parameter FALLING = 2'b10;

  reg [1:0] state, next_state;

  // Moore state machine logic
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    walk_left = (state == WALK_LEFT);
    walk_right = (state == WALK_RIGHT);
    aaah = (state == FALLING);
  end

  always @* begin
    case(state)
      WALK_LEFT: begin
        if (bump_right) next_state = WALK_RIGHT;
        else if (!ground) next_state = FALLING;
        else next_state = WALK_LEFT;
      end
      WALK_RIGHT: begin
        if (bump_left) next_state = WALK_LEFT;
        else if (!ground) next_state = FALLING;
        else next_state = WALK_RIGHT;
      end
      FALLING: begin
        if (ground) begin
          if (state == WALK_LEFT) next_state = WALK_LEFT;
          else if (state == WALK_RIGHT) next_state = WALK_RIGHT;
          else next_state = FALLING;
        end else begin
          next_state = FALLING;
        end
      end
    endcase
  end

endmodule