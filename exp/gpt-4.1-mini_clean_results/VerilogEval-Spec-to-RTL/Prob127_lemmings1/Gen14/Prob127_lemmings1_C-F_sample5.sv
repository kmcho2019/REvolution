module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    // State encoding for readability
    localparam WALK_LEFT  = 1'b0;
    localparam WALK_RIGHT = 1'b1;

    reg state, next_state;

    // Next state combinational logic using concise conditions covering all bump input cases
    always @(*) begin
        if (bump_left & ~bump_right)
            next_state = WALK_RIGHT;
        else if (~bump_left & bump_right)
            next_state = WALK_LEFT;
        else if (bump_left & bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // State register with asynchronous positive-edge reset to WALK_LEFT
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs directly from state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule