module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Combinational next state logic
    always @(*) begin
        if (bump_left && bump_right)
            next_state = ~state;          // bump both sides: invert direction
        else if (bump_left)
            next_state = WALK_RIGHT;      // bump left: walk right
        else if (bump_right)
            next_state = WALK_LEFT;       // bump right: walk left
        else
            next_state = state;            // no bump: hold state
    end

    // Sequential state update with async active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Outputs derived from state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule