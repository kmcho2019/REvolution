module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

// Define an enumeration for the states using one-hot encoding
typedef enum {LEFT = 1'b0, RIGHT = 1'b1} state_t;

reg state;

// Use a single always block for sequential logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= LEFT;
  end else begin
    case (state)
      LEFT: state <= (bump_left) ? RIGHT : (bump_right) ? LEFT : LEFT;
      RIGHT: state <= (bump_right) ? LEFT : (bump_left) ? RIGHT : RIGHT;
    endcase
  end
end

// Use assign statements for combinational logic
assign walk_left = (state == LEFT);
assign walk_right = (state == RIGHT);

endmodule