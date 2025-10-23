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

    // Async reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else
            state <= next_state;
    end

    // Next state logic simplified:
    // If any bump (left or right) occurs, toggle the state.
    // If no bump, remain in current state.
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Moore outputs as complementary signals based on state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule