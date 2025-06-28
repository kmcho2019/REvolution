module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
reg [1:0] state, next_state;

// State register
always @ (posedge clk or posedge areset) begin
  if (areset) begin
    state <= WALK_LEFT;
  end else begin
    state <= next_state;
  end
end

// Next state logic
always @* begin
  case (state)
    WALK_LEFT:
      begin
        if (bump_left == 1 && bump_right == 0) begin
          next_state = WALK_RIGHT;
        end
        else begin
          next_state = WALK_LEFT;
        end
      end
    WALK_RIGHT:
      begin
        if (bump_right == 1 && bump_left == 0) begin
          next_state = WALK_LEFT;
        end
        else begin
          next_state = WALK_RIGHT;
        end
      end
  endcase
end

// Output logic
always @* begin
  case (state)
    WALK_LEFT:
      begin
        walk_left = 1;
        walk_right = 0;
      end
    WALK_RIGHT:
      begin
        walk_left = 0;
        walk_right = 1;
      end
  endcase
end

endmodule