module LemmingFSM (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

// State definition
parameter WALK_LEFT = 1'b0;
parameter WALK_RIGHT = 1'b1;
reg state;

// Sequential logic
always@(posedge clk or posedge areset) begin
  if(areset) begin
    state <= WALK_LEFT; // Reset to WALK_LEFT state
  end
  else begin
    case(state)
      WALK_LEFT: begin
        if(bump_right && !bump_left)
          state <= WALK_RIGHT;
      end
      WALK_RIGHT: begin
        if(bump_left && !bump_right)
          state <= WALK_LEFT;
      end
    endcase
  end
end

// Output logic
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);

endmodule

// TopModule instantiating the LemmingFSM module
module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output walk_left,
  output walk_right
);
LemmingFSM myLemmingFSM (
  .clk(clk),
  .areset(areset),
  .bump_left(bump_left),
  .bump_right(bump_right),
  .walk_left(walk_left),
  .walk_right(walk_right)
);
endmodule