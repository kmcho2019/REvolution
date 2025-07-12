module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot state encoding:
    // state_walk_left  = 1'b1 when walking left
    // state_walk_right = 1'b1 when walking right
    reg state_walk_left, state_walk_right;
    reg next_walk_left, next_walk_right;

    // Asynchronous positive edge reset and state flip-flops update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_walk_left  <= 1'b1;  // Initialize walking left
            state_walk_right <= 1'b0;
        end else begin
            state_walk_left  <= next_walk_left;
            state_walk_right <= next_walk_right;
        end
    end

    // Next state logic combinational block
    always @(*) begin
        // Default maintain current state
        next_walk_left  = state_walk_left;
        next_walk_right = state_walk_right;

        // If bumped on left, move right
        if (bump_left)
        begin
            next_walk_left  = 1'b0;
            next_walk_right = 1'b1;
        end

        // If bumped on right, move left
        if (bump_right)
        begin
            next_walk_left  = 1'b1;
            next_walk_right = 1'b0;
        end

        // If bumped on both sides simultaneously,
        // the above logic executes both conditions;
        // since bump_right check comes later, it will overwrite bump_left.
        // To handle toggling on simultaneous bumps, check first:
        if (bump_left && bump_right) begin
            // Toggle the state
            next_walk_left  = state_walk_right;
            next_walk_right = state_walk_left;
        end
    end

    // Outputs directly reflect the one-hot state registers
    assign walk_left  = state_walk_left;
    assign walk_right = state_walk_right;

endmodule