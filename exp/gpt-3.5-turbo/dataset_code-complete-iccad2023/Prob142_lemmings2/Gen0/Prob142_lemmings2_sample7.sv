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

  typedef enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING,
    AAH
  } state_type;

  reg [1:0] state, next_state;

  always_ff @(posedge clk or posedge areset) begin
    if(areset) begin
      state <= WALK_LEFT;
    end
    else begin
      state <= next_state;
    end
  end

  always_comb begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    case(state)
      WALK_LEFT: begin
        walk_left = 1;
        if(bump_right) next_state = WALK_RIGHT;
        else if(!ground) next_state = FALLING;
      end
      WALK_RIGHT: begin
        walk_right = 1;
        if(bump_left) next_state = WALK_LEFT;
        else if(!ground) next_state = FALLING;
      end
      FALLING: begin
        aaah = 1;
        if(ground) next_state = state {1'b0, 1'b0};
      end
      default: next_state = state;
    endcase
  end

endmodule