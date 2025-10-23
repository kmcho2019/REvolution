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

    // State register with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        if (bump_left && bump_right)
            next_state = ~state;       // Both bumps: toggle state
        else if (bump_left)
            next_state = WALK_RIGHT;   // bump_left: walk right
        else if (bump_right)
            next_state = WALK_LEFT;    // bump_right: walk left
        else
            next_state = state;         // no bump: hold current state
    end

    // Outputs derived directly from state bit to minimize logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = ~walk_left;

endmodule