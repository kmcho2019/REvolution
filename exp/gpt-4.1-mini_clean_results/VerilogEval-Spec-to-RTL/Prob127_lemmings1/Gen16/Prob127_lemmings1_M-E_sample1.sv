module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // Direction bit: 0 = walk left, 1 = walk right
    reg direction;

    // Async reset and state update: invert direction if bumped on either side
    always @(posedge clk or posedge areset) begin
        if (areset)
            direction <= 1'b0;  // walk left on reset
        else if (bump_left | bump_right)
            direction <= ~direction; // invert direction on bump
    end

    // Outputs from current state (Moore outputs)
    assign walk_left  = ~direction;
    assign walk_right =  direction;

endmodule