module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = WALK_LEFT, 1 = WALK_RIGHT
    reg state;

    wire bump_both = bump_left & bump_right;
    wire bump_any  = bump_left | bump_right;

    // Next state logic: switch if any bump, and decide direction
    // If bumped on both sides, invert current state (switch direction)
    // If only bumped on left, go right (state=1)
    // If only bumped on right, go left (state=0)
    wire next_state = (bump_both) ? ~state :
                      (bump_left) ? 1'b1 :
                      (bump_right) ? 1'b0 :
                      state;

    // State register with async posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else
            state <= next_state;
    end

    // Outputs directly from state
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule