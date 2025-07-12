module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // One-hot encoded state bits:
    // state_left = 1 means walking left
    // state_right = 1 means walking right
    reg state_left, state_right;
    reg next_state_left, next_state_right;

    // Asynchronous positive edge reset: set to walk_left
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_left  <= 1'b1;
            state_right <= 1'b0;
        end else begin
            state_left  <= next_state_left;
            state_right <= next_state_right;
        end
    end

    // Next state logic combinational block
    always @(*) begin
        // Default: hold current state
        next_state_left  = state_left;
        next_state_right = state_right;

        if (bump_left & bump_right) begin
            // Both bumps: toggle state
            next_state_left  = state_right;
            next_state_right = state_left;
        end else if (bump_left) begin
            // Bumped left => walk right
            next_state_left  = 1'b0;
            next_state_right = 1'b1;
        end else if (bump_right) begin
            // Bumped right => walk left
            next_state_left  = 1'b1;
            next_state_right = 1'b0;
        end
        // else hold current state
    end

    // Outputs directly from one-hot state bits (Moore machine)
    assign walk_left  = state_left;
    assign walk_right = state_right;

endmodule