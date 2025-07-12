module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state, next_state;

    // Asynchronous reset (posedge) sets state to WALK_LEFT (state=1)
    // Define WALK_LEFT as 1, WALK_RIGHT as 0 for simplicity and output mapping
    localparam WALK_LEFT  = 1'b1;
    localparam WALK_RIGHT = 1'b0;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic:
    // If bumped on left or right (or both), invert direction.
    // Else, stay in current state.
    always @(*) begin
        if (bump_left || bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Moore outputs: walk_left = state, walk_right = ~state
    assign walk_left  = state;
    assign walk_right = ~state;

endmodule