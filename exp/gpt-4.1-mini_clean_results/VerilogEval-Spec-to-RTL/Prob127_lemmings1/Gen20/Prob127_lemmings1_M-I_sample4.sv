module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state, next_state;

    wire bump_any = bump_left | bump_right;

    // Next-state logic: toggle state if bumped on any side
    always @(*) begin
        if (bump_any)
            next_state = ~state;
        else
            next_state = state;
    end

    // State register with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else
            state <= next_state;
    end

    // Moore outputs derived directly from state
    assign walk_left  = ~state;
    assign walk_right = state;

endmodule