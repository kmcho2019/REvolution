module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg state;

    // Next state combinational logic:
    // If bumped both sides: toggle state
    // Else if bumped left only: walk_right (1)
    // Else if bumped right only: walk_left (0)
    // Else hold state
    // Single boolean expression combining these:
    // next_state = (bump_left & ~bump_right)            // bump left only → walk_right (1)
    //            | (bump_left & bump_right & ~state)    // bump both → toggle
    //            | (state & ~ (bump_left | bump_right)); // no bump → hold

    wire next_state = (bump_left & ~bump_right) 
                    | (bump_left & bump_right & ~state) 
                    | (state & ~ (bump_left | bump_right));

    // State register with asynchronous positive edge reset to walk_left (0)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Moore outputs derived from state
    assign walk_left  = ~state;
    assign walk_right =  state;

endmodule