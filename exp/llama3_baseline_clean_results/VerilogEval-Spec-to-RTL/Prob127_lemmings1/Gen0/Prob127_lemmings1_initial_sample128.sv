module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states
localparam STATE_LEFT = 1'b0;
localparam STATE_RIGHT = 1'b1;

// Declare the state register
reg current_state;
reg next_state;

// Assign the output signals based on the current state
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
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
        end
    endcase
end

// Determine the next state based on the current state and input bumps
always @(*) begin
    case(current_state)
        STATE_LEFT: begin
            if (bump_left) begin
                next_state = STATE_RIGHT;
            end else if (bump_right) begin
                next_state = STATE_LEFT;
            end else begin
                next_state = STATE_LEFT;
            end
        end
        STATE_RIGHT: begin
            if (bump_right) begin
                next_state = STATE_LEFT;
            end else if (bump_left) begin
                next_state = STATE_RIGHT;
            end else begin
                next_state = STATE_RIGHT;
            end
        end
        default: begin
            next_state = STATE_LEFT;
        end
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_LEFT;
    end else begin
        if (bump_left && bump_right) begin
            current_state <= ~current_state;
        end else if (bump_left) begin
            current_state <= STATE_RIGHT;
        end else if (bump_right) begin
            current_state <= STATE_LEFT;
        end else begin
            current_state <= current_state;
        end
    end
end

endmodule