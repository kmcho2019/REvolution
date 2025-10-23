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

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic simplified
    always @(*) begin
        // If any bump (left or right) is active, switch direction
        if (bump_left | bump_right)
            next_state = ~state;
        else
            next_state = state;
    end

    // Moore output: drive walk_left from state, derive walk_right as complement
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = ~walk_left;

endmodule