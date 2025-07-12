module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding: 0 = walk left, 1 = walk right
    reg state, next_state;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // WALK_LEFT
        else
            state <= next_state;
    end

    // Next state logic: if any bump is detected, invert direction
    // else maintain current direction
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Outputs: Moore machine outputs are directly derived from state
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule