module StateTransitions (
  input bump_left,
  input bump_right,
  input ground,
  input current_state,
  output next_state,
  output walk_left,
  output walk_right,
  output aaah
);
  // Define states
  parameter WALK_LEFT = 2'b00;
  parameter WALK_RIGHT = 2'b01;
  
  assign aaah = (~ground & (current_state == WALK_LEFT || current_state == WALK_RIGHT)) ? 1'b1 : 1'b0;
  
  always @* begin
    case(current_state)
      WALK_LEFT: begin
        if (bump_right)
          next_state = WALK_RIGHT;
        else if (!ground)
          next_state = WALK_LEFT;
        else
          next_state = WALK_LEFT;
      end
      WALK_RIGHT: begin
        if (bump_left)
          next_state = WALK_LEFT;
        else if (!ground)
          next_state = WALK_RIGHT;
        else
          next_state = WALK_RIGHT;
      end
      default: next_state = WALK_LEFT;
    endcase

    walk_left = (next_state == WALK_LEFT) ? 1 : 0;
    walk_right = (next_state == WALK_RIGHT) ? 1 : 0;
  end
endmodule

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
  // State register
  reg [1:0] state;

  // Mealy state machine
  always @(posedge clk or posedge areset) begin
    if (areset)
      state <= WALK_LEFT;
    else begin
      StateTransitions st(state[0], state[1], ground, state, next_state, walk_left, walk_right, aaah);
      state <= next_state;
    end
  end
endmodule