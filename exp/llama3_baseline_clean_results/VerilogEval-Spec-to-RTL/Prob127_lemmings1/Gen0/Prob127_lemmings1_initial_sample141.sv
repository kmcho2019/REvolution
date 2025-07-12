module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states of the state machine
parameter STATE_LEFT = 1'b0;
parameter STATE_RIGHT = 1'b1;

// Internal signals to keep track of the current and next state
reg current_state;
reg next_state;

// Assign outputs based on the current state
assign walk_left = ~current_state;
assign walk_right = current_state;

// Determine the next state based on the current state and inputs
always @(bump_left or bump_right or current_state) begin
    case (current_state)
        STATE_LEFT: begin
            if (bump_left) begin
                next_state = STATE_RIGHT;
            end else begin
                next_state = STATE_LEFT;
            end
        end
        STATE_RIGHT: begin
            if (bump_right) begin
                next_state = STATE_LEFT;
            end else begin
                next_state = STATE_RIGHT;
            end
        end
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            // If bumped from both sides, switch directions
            current_state <= ~current_state;
        end else begin
            current_state <= next_state;
        end
    end
end

endmodule