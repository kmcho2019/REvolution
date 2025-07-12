module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk_left, 1 = walk_right
    reg state, next_state;

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // Reset to walk_left
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        // Priority:
        // If both bumps, toggle direction
        // Else if bumped left, walk right
        // Else if bumped right, walk left
        // Else hold current state
        if (bump_left && bump_right)
            next_state = ~state;
        else if (bump_left)
            next_state = 1'b1;  // walk_right
        else if (bump_right)
            next_state = 1'b0;  // walk_left
        else
            next_state = state;
    end

    // Moore output logic: outputs depend only on current state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule