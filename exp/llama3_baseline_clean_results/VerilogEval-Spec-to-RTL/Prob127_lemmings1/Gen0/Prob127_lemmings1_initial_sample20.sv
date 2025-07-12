module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

// Define states
parameter WALK_LEFT = 1'b0;
parameter WALK_RIGHT = 1'b1;

// Internal state variable
reg state;

// Assign outputs based on state
assign walk_left = ~state;
assign walk_right = state;

// Next state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to WALK_LEFT state
        state <= WALK_LEFT;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (bump_left) begin
                    // If bumped on the left, transition to WALK_RIGHT state
                    state <= WALK_RIGHT;
                end else if (bump_right) begin
                    // If bumped on the right, no change
                end else begin
                    // No change
                end
            end
            WALK_RIGHT: begin
                if (bump_right) begin
                    // If bumped on the right, transition to WALK_LEFT state
                    state <= WALK_LEFT;
                end else if (bump_left) begin
                    // If bumped on the left, no change
                end else begin
                    // No change
                end
            end
        endcase
    end
end

endmodule