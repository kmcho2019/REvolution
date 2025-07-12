module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define states
parameter STATE_WALK_LEFT = 1'b0;
parameter STATE_WALK_RIGHT = 1'b1;

reg current_state;
reg next_state;

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        STATE_WALK_LEFT: begin
            if (bump_left) begin
                next_state <= STATE_WALK_RIGHT;
            end else begin
                next_state <= current_state;
            end
        end
        STATE_WALK_RIGHT: begin
            if (bump_right) begin
                next_state <= STATE_WALK_LEFT;
            end else begin
                next_state <= current_state;
            end
        end
        default: begin
            next_state <= STATE_WALK_LEFT;
        end
    endcase

    // If both bumps are detected, switch directions
    if (bump_left && bump_right) begin
        next_state <= ~current_state;
    end
end

// Output logic
assign walk_left = (current_state == STATE_WALK_LEFT) ? 1'b1 : 1'b0;
assign walk_right = (current_state == STATE_WALK_RIGHT) ? 1'b1 : 1'b0;

endmodule