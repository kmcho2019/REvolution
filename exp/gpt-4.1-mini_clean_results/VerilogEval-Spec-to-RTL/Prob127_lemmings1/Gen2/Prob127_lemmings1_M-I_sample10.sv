module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = WALK_LEFT, 1 = WALK_RIGHT
    reg state, next_state;

    // Async reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else
            state <= next_state;
    end

    // Next state logic: if bumped on either side (or both), flip state; else hold
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Outputs: walk_left = ~state, walk_right = state
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule