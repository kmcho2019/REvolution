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

    reg state;
    wire next_state;

    // Combinational logic for next_state using continuous assign
    // next_state logic derived from:
    // If bumped left only => walk right (1)
    // If bumped right only => walk left (0)
    // If both bumped => toggle state
    // If no bump => hold state
    assign next_state = (bump_left & ~bump_right) ? WALK_RIGHT :
                        (~bump_left & bump_right) ? WALK_LEFT  :
                        (bump_left & bump_right)   ? ~state     :
                        state;

    // Sequential state update with asynchronous positive-edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    // Moore outputs
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule