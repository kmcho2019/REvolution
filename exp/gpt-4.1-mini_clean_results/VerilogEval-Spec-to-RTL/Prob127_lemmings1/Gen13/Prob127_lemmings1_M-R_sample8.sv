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

    // Next state logic: 
    // - If bumped on left, walk right (state=1)
    // - If bumped on right, walk left (state=0)
    // - If both bump_left and bump_right, toggle state
    wire bump = bump_left | bump_right;
    wire bump_both = bump_left & bump_right;

    wire next_state;

    assign next_state = (bump_both) ? ~state :
                        (bump_left)  ? 1'b1 : 
                        (bump_right) ? 1'b0 : 
                        state;

    // State register with asynchronous posedge reset to WALK_LEFT
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else
            state <= next_state;
    end

    // Moore outputs derived from state directly
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule