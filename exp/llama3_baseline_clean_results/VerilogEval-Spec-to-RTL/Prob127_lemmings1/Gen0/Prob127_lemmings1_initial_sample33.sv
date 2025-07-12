module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define states
parameter STATE_LEFT = 1'b0;
parameter STATE_RIGHT = 1'b1;

// Internal state and next state
reg current_state;
reg next_state;

// Define state transitions
always @(*) begin
    case(current_state)
        STATE_LEFT: begin
            if(bump_left) begin
                next_state = STATE_RIGHT;
            end else begin
                next_state = STATE_LEFT;
            end
        end
        STATE_RIGHT: begin
            if(bump_right) begin
                next_state = STATE_LEFT;
            end else begin
                next_state = STATE_RIGHT;
            end
        end
    endcase
end

// Handle both bump_left and bump_right being high at the same time
always @(*) begin
    if(bump_left && bump_right) begin
        if(current_state == STATE_LEFT) begin
            next_state = STATE_RIGHT;
        end else begin
            next_state = STATE_LEFT;
        end
    end
end

// Update current state on positive edge of clock
always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= STATE_LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Output walking direction based on current state
always @(*) begin
    case(current_state)
        STATE_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        STATE_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule