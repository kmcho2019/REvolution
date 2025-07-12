module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // Async reset, state update with direction toggle on any bump input
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // WALK_LEFT
        else if (bump_left | bump_right)
            state <= ~state; // toggle direction
        else
            state <= state; // hold current state
    end

    // Moore outputs derived from state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule