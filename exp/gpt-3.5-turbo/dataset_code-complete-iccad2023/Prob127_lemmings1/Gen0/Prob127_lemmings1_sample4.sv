module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  output reg walk_left,
  output reg walk_right
);

// State definition
parameter STATE_WALK_LEFT = 1'b0;
parameter STATE_WALK_RIGHT = 1'b1;

// Internal state signal
reg state;

// Moore state machine logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_WALK_LEFT; // Reset to walking left
        walk_left <= 1;
        walk_right <= 0;
    end
    else begin
        case (state)
            STATE_WALK_LEFT: begin
                if (bump_left && bump_right) begin
                    state <= STATE_WALK_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                end
                else if (bump_left) begin
                    state <= STATE_WALK_RIGHT;
                    walk_left <= 0;
                    walk_right <= 1;
                end
            end
            STATE_WALK_RIGHT: begin
                if (bump_left && bump_right) begin
                    state <= STATE_WALK_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                end
                else if (bump_right) begin
                    state <= STATE_WALK_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                end
            end
        endcase
    end
end


endmodule