module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

// Define the states
enum logic [0:0] {WALK_LEFT, WALK_RIGHT} state, next_state;

// Output logic based on the current state
always_comb begin
    walk_left = (state == WALK_LEFT) ? 1'b1 : 1'b0;
    walk_right = (state == WALK_RIGHT) ? 1'b1 : 1'b0;
end

// State machine logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        // Switch direction if bumped
        if (bump_left) begin
            state <= WALK_RIGHT;
        end else if (bump_right) begin
            state <= WALK_LEFT;
        end else if (bump_left && bump_right) begin
            // If bumped on both sides, still switch direction
            if (state == WALK_LEFT) begin
                state <= WALK_RIGHT;
            end else begin
                state <= WALK_LEFT;
            end
        end
    end
end

endmodule