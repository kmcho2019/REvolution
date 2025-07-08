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

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        if (bump_left | bump_right)
            next_state = ~state; // switch direction if bumped
        else
            next_state = state;  // remain in current state
    end

    // Outputs - Moore machine outputs depend on current state only
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule