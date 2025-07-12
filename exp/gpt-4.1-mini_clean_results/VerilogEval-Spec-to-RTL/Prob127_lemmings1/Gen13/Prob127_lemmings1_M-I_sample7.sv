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

    // Determine if any bump happens (enable state update)
    wire bump_any = bump_left | bump_right;

    // Next-state logic (combinational)
    // If both bumps, invert state. If only bump_left, go right. 
    // If only bump_right, go left. If no bump, hold.
    always @(*) begin
        if (bump_any) begin
            if (bump_left & bump_right)
                next_state = ~state;
            else if (bump_left)
                next_state = WALK_RIGHT;
            else // bump_right only
                next_state = WALK_LEFT;
        end else begin
            next_state = state;
        end
    end

    // State register with asynchronous reset and clock enable
    // Update state only on bump or reset, reducing unnecessary toggles
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else if (bump_any)
            state <= next_state;
    end

    // Moore outputs based on current state
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule