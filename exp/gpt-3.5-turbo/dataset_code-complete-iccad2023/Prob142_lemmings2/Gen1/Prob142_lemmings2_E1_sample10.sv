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

  // State definition
  parameter WALK_LEFT = 2'd0;
  parameter WALK_RIGHT = 2'd1;
  reg [1:0] state;

  // Mealy state machine
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
    end
    else begin
      if (state == WALK_LEFT && bump_right) begin
        state <= WALK_RIGHT;
      end
      else if (state == WALK_RIGHT && bump_left) begin
        state <= WALK_LEFT;
      end
      else if (!ground) begin
        state <= state;
      end
    end
  end

  // Output assignments based on state
  always @* begin
    walk_left = (state == WALK_LEFT) ? 1'b1 : 1'b0;
    walk_right = (state == WALK_RIGHT) ? 1'b1 : 1'b0;
    aaah = (state == WALK_LEFT || state == WALK_RIGHT) && !ground;
  end

endmodule