module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Combinational logic: priority to bump_left to walk right,
    // else bump_right to walk left, else hold state.
    always @(*) begin
        if (bump_left)
            next_state = WALK_RIGHT;
        else if (bump_right)
            next_state = WALK_LEFT;
        else
            next_state = state;
    end

    // Sequential logic with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule