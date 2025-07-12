module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define states
parameter WALK_LEFT = 1'b0;
parameter WALK_RIGHT = 1'b1;

// Internal state and next state variables
reg current_state;
reg next_state;

// Output logic
assign walk_left = ~current_state;
assign walk_right = current_state;

// State transition logic
always @(*) begin
    case (current_state)
        WALK_LEFT: begin
            if (bump_left) next_state = WALK_RIGHT;
            else next_state = WALK_LEFT;
        end
        WALK_RIGHT: begin
            if (bump_right) next_state = WALK_LEFT;
            else next_state = WALK_RIGHT;
        end
    endcase
end

// Reset and clock logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= WALK_LEFT;
    end else begin
        current_state <= next_state;
    end
end

endmodule